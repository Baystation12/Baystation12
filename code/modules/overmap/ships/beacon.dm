/obj/machinery/radio_beacon
	name = "transmission beacon"
	desc = "A bulky hyperspace transmitter, capable of continuously broadcasting a signal that can be picked up by ship sensors."
	icon = 'icons/obj/machines/beacon.dmi'
	icon_state = "beacon"
	density = TRUE
	anchored = TRUE
	idle_power_usage = 0
	health_max = 100
	active_power_usage = 1 KILOWATTS
	construct_state = /singleton/machine_construction/default/panel_closed
	var/obj/overmap/radio/signal
	var/obj/overmap/radio/distress/emergency_signal
	/// Integer. The `world.time` value of the last distress broadcast.
	var/last_message_time = 0
	/// Integer. The `world.time` of the last activation toggle.
	var/last_activation_time = 0
	/// Integer. The amount of time the machine must wait before toggling activation state. Used to prevent spam.
	var/const/activation_frequency = 1 MINUTE

/obj/item/stock_parts/circuitboard/radio_beacon
	name = "circuit board (transmission beacon)"
	board_type = "machine"
	icon_state = "mcontroller"
	build_path = /obj/machinery/radio_beacon
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 5, TECH_BLUESPACE = 3)
	req_components = list(
							/obj/item/stock_parts/subspace/ansible = 1,
							/obj/item/stock_parts/subspace/filter = 1,
							/obj/item/stock_parts/subspace/amplifier = 1,
						)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/battery/buildable/stock = 1,
		/obj/item/cell/high = 1
	)


/obj/machinery/radio_beacon/interface_interact(mob/user, skip_time_check = FALSE)
	if (!CanInteract(user, DefaultTopicState()))
		return

	if (inoperable())
		to_chat(user, SPAN_WARNING("A small red light flashes on \the [src]."))
		return

	var/obj/overmap/visitable/O = map_sectors["[get_z(src)]"]
	if(!O)
		to_chat(user, SPAN_WARNING("You cannot deploy \the [src] here."))
		return

	var/toggle_prompt = alert(user, "Turn the beacon...", "[src] Options", "[signal || emergency_signal ? "Off" : "On"]", "Distress", "Cancel")

	if (toggle_prompt == "Cancel")
		return

	if (QDELETED(src) || stat)
		return

	switch(toggle_prompt)
		if ("On")
			if (emergency_signal)
				to_chat(user, SPAN_WARNING("Turn off the distress signal first!"))
				return
			else
				activate()
		if ("Off")
			deactivate()
		if ("Distress")
			if (signal)
				to_chat(user, SPAN_WARNING("Turn off the radio broadcast first!"))
				return

			if (emergency_signal)
				to_chat(user, SPAN_WARNING("This beacon is already broadcasting a distress signal!"))
				return

			activate_distress()

/obj/machinery/radio_beacon/proc/activate()
	var/obj/overmap/visitable/O = map_sectors["[get_z(src)]"]
	var/message = sanitize(input("What should it broadcast?") as message|null)
	if(!message)
		return

	visible_message(SPAN_NOTICE("\The [src] whirrs to life, starting its radio broadcast."))

	playsound(src, 'sound/machines/sensors/newcontact.ogg', 50, 3, 3)

	signal = new()

	last_activation_time = world.time

	signal.message = message
	signal.set_origin(O)

	update_use_power(POWER_USE_ACTIVE)
	update_icon()

/obj/machinery/radio_beacon/proc/activate_distress()
	var/obj/overmap/visitable/O = map_sectors["[get_z(src)]"]

	visible_message(SPAN_WARNING("\The [src] beeps urgently as it whirrs to life, sending out intermittent tones."))

	log_and_message_admins("A distress beacon was activated in [get_area(src)].", usr, get_turf(src))

	playsound(src, 'sound/machines/sensors/newcontact.ogg', 50, 3, 3)

	emergency_signal = new()

	last_activation_time = world.time

	emergency_signal.set_origin(O)

	update_use_power(POWER_USE_ACTIVE)
	update_icon()

/obj/machinery/radio_beacon/proc/deactivate()

	visible_message(SPAN_NOTICE("\The [src] winds down to a halt, cutting short it's radio broadcast."))

	playsound(src, 'sound/machines/sensors/newcontact.ogg', 50, 3, 3)

	QDEL_NULL(signal)
	QDEL_NULL(emergency_signal)

	last_activation_time = world.time

	update_use_power(POWER_USE_OFF)
	update_icon()

/obj/machinery/radio_beacon/power_change()
	. = ..()
	if(!. || !use_power) return

	if(!is_powered())
		deactivate()

/obj/machinery/radio_beacon/on_update_icon()
	ClearOverlays()
	if(panel_open)
		AddOverlays("[icon_state]_panel")
	if(is_powered())
		AddOverlays(emissive_appearance(icon, "[icon_state]_lights"))
		AddOverlays("[icon_state]_lights")
	if(signal)
		AddOverlays(emissive_appearance(icon, "[icon_state]_lights_active"))
		AddOverlays("[icon_state]_lights_active")
	else if(emergency_signal)
		AddOverlays(emissive_appearance(icon, "[icon_state]_lights_distress"))
		AddOverlays("[icon_state]_lights_distress")

/obj/machinery/radio_beacon/Destroy()
	QDEL_NULL(signal)
	QDEL_NULL(emergency_signal)
	. = ..()

/obj/overmap/radio
	name = "radio signal"
	icon_state = "radio"
	scannable = TRUE
	color = COLOR_AMBER
	var/message
	var/obj/overmap/source

/obj/overmap/radio/get_scan_data(mob/user)
	return list("A radio signal originating at \the [source].<br><br> \
	---BEGINNING OF TRANSMISSION---<br><br> \
	[message] \
	<br><br>---END OF TRANSMISSION---")

/obj/overmap/radio/proc/set_origin(obj/overmap/origin)
	GLOB.moved_event.register(origin, src, /obj/overmap/radio/proc/follow)
	GLOB.destroyed_event.register(origin, src, /datum/proc/qdel_self)
	forceMove(origin.loc)
	source = origin
	pixel_x = -(origin.bound_width - 6)
	pixel_y = origin.bound_height - 6

/obj/overmap/radio/proc/follow(atom/movable/am, old_loc, new_loc)
	forceMove(new_loc)

/obj/overmap/radio/Destroy()
	GLOB.destroyed_event.unregister(source, src)
	GLOB.moved_event.unregister(source, src)
	source = null
	. = ..()

/obj/overmap/radio/distress
	name = "distress dataspike"
	icon_state = "radio"
	color = COLOR_NT_RED

/obj/overmap/radio/distress/get_scan_data(mob/user)
	return list("A unilateral, broadband data broadcast originating at \the [source] carrying only an emergency code sequence.")

/obj/overmap/radio/distress/Initialize()
	..()
	for(var/obj/machinery/computer/ship/helm/H in SSmachines.machinery)
		H.visible_message(SPAN_WARNING("\the [H] pings uneasily as it detects a distress signal."))
		playsound(H, 'sound/machines/sensors/newcontact.ogg', 50, 3, 3)
