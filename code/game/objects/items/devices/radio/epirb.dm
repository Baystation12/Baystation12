/obj/item/device/radio/epirb
	icon = 'icons/obj/radio.dmi'
	name = "emergency position-indicating radio beacon"
	desc = "a pocket sized distress beacon"
	suffix = "\[3\]"
	icon_state = "epirb"
	item_state = "epirb"
	var/obj/effect/overmap/radio/distress/emergency_signal
	/// Integer. The `world.time` value of the last distress broadcast.
	var/last_message_time = 0
	/// Integer. The `world.time` of the last activation toggle.
	var/last_activation_time = 0
	/// Integer. The amount of time the machine must wait before toggling activation state. Used to prevent spam.
	var/const/activation_frequency = 1 MINUTE

/obj/item/device/radio/epirb/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/nanoui/master_ui = null, datum/topic_state/state = GLOB.default_state)
	var/obj/effect/overmap/visitable/O = map_sectors["[get_z(src)]"]
	if(!O)
		to_chat(user, SPAN_WARNING("You cannot deploy \the [src] here."))
		return
	var/toggle_prompt = alert(user, "Activate the beacon...", "[src] Options", "[emergency_signal ? "Off" : "On"]", "Distress", "Cancel")

	if (toggle_prompt == "Cancel")
		return

	if ((!Adjacent(user) || user.stat) && !(isrobot(user) || (isghost(user) && isadmin(user))))
		to_chat(user, SPAN_WARNING("You're not able to do that to \the [src] right now."))
	switch(toggle_prompt)
		if ("Off")
			deactivate()

		if ("Distress")
			if (emergency_signal)

				to_chat(user, SPAN_WARNING("This beacon is already broadcasting a distress signal!"))
				return
			else
				activate_distress()

/obj/item/device/radio/epirb/proc/activate_distress()
	var/obj/effect/overmap/visitable/O = map_sectors["[get_z(src)]"]

	visible_message(SPAN_WARNING("\The [src] beeps urgently as it whirrs to life, sending out intermittent tones."))

	log_and_message_admins("A distress beacon was activated in [get_area(src)].", usr, get_turf(src))

	playsound(src, 'sound/machines/sensors/newcontact.ogg', 50, 3, 3)

	emergency_signal = new()

	last_activation_time = world.time

	emergency_signal.set_origin(O)

	update_icon()

/obj/item/device/radio/epirb/proc/deactivate()

	visible_message(SPAN_NOTICE("\The [src] winds down to a halt, cutting short it's radio broadcast."))

	playsound(src, 'sound/machines/sensors/newcontact.ogg', 50, 3, 3)

	QDEL_NULL(emergency_signal)

	last_activation_time = world.time

	update_icon()

/obj/item/device/radio/epirb/Destroy()
	QDEL_NULL(emergency_signal)
	. = ..()

/obj/effect/overmap/radio/distress
	name = "distress dataspike"
	icon_state = "radio"
	color = COLOR_NT_RED

/obj/effect/overmap/radio/distress/get_scan_data(mob/user)
	return "A unilateral, broadband data broadcast originating at \the [source] carrying only an emergency code sequence."

/obj/effect/overmap/radio/distress/Initialize()
	..()
	for(var/obj/machinery/computer/ship/helm/H in SSmachines.machinery)
		H.visible_message(SPAN_WARNING("\the [H] pings uneasily as it detects a distress signal."))
		playsound(H, 'sound/machines/sensors/newcontact.ogg', 50, 3, 3)
