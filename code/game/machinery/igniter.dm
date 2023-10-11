/obj/machinery/igniter
	name = "igniter"
	desc = "It's useful for igniting flammable items."
	icon = 'icons/obj/structures/igniter.dmi'
	icon_state = "igniter1"
	var/on = 0
	anchored = TRUE
	idle_power_usage = 20
	active_power_usage = 1000

	uncreated_component_parts = list(
		/obj/item/stock_parts/radio/receiver,
		/obj/item/stock_parts/power/apc
	)
	public_variables = list(
		/singleton/public_access/public_variable/igniter_on
	)
	public_methods = list(
		/singleton/public_access/public_method/igniter_toggle
	)
	stock_part_presets = list(/singleton/stock_part_preset/radio/receiver/igniter = 1)

/obj/machinery/igniter/Initialize()
	. = ..()
	update_icon()

/obj/machinery/igniter/on_update_icon()
	..()
	icon_state = "igniter[on]"

/obj/machinery/igniter/interface_interact(mob/user)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	ignite()
	visible_message(SPAN_NOTICE("\The [user] toggles \the [src]."))
	return TRUE

/obj/machinery/igniter/Process()
	if(is_powered())
		var/turf/location = src.loc
		if (isturf(location))
			location.hotspot_expose(1000,500,1)
	return 1

/obj/machinery/igniter/proc/ignite()
	use_power_oneoff(2000)
	on = !on
	if(on)
		START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	else
		STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	update_icon()

/singleton/public_access/public_variable/igniter_on
	expected_type = /obj/machinery/igniter
	name = "igniter active"
	desc = "Whether or not the igniter is igniting."
	can_write = FALSE
	has_updates = FALSE

/singleton/public_access/public_variable/holosign_on/access_var(obj/machinery/igniter/igniter)
	return igniter.on

/singleton/public_access/public_method/igniter_toggle
	name = "igniter toggle"
	desc = "Toggle the igniter on or off."
	call_proc = /obj/machinery/igniter/proc/ignite

/singleton/stock_part_preset/radio/receiver/igniter
	frequency = BUTTON_FREQ
	receive_and_call = list("button_active" = /singleton/public_access/public_method/igniter_toggle)

// Wall mounted remote-control igniter.

/obj/machinery/sparker
	name = "mounted igniter"
	desc = "A wall-mounted ignition device."
	icon = 'icons/obj/structures/mounted_igniter.dmi'
	icon_state = "migniter"
	var/disable = 0
	var/last_spark = 0
	var/base_state = "migniter"
	anchored = TRUE
	idle_power_usage = 20
	active_power_usage = 1000

	uncreated_component_parts = list(
		/obj/item/stock_parts/radio/receiver,
		/obj/item/stock_parts/power/apc
	)
	public_methods = list(
		/singleton/public_access/public_method/sparker_spark
	)
	stock_part_presets = list(/singleton/stock_part_preset/radio/receiver/sparker = 1)

/obj/machinery/sparker/on_update_icon()
	..()
	if(disable)
		icon_state = "migniter-d"
	else if(powered())
		icon_state = "migniter"
//		src.sd_SetLuminosity(2)
	else
		icon_state = "migniter-p"
//		src.sd_SetLuminosity(0)

/obj/machinery/sparker/attackby(obj/item/W as obj, mob/user as mob)
	if(isScrewdriver(W))
		add_fingerprint(user)
		disable = !disable
		if(disable)
			user.visible_message(SPAN_WARNING("[user] has disabled the [src]!"), SPAN_WARNING("You disable the connection to the [src]."))
		else if(!disable)
			user.visible_message(SPAN_WARNING("[user] has reconnected the [src]!"), SPAN_WARNING("You fix the connection to the [src]."))
		update_icon()
	else
		..()

/obj/machinery/sparker/attack_ai()
	if (anchored)
		return ignite()
	else
		return

/obj/machinery/sparker/proc/ignite()
	if (!powered())
		return

	if (disable || (last_spark && world.time < last_spark + 50))
		return


	flick("migniter-spark", src)
	var/datum/effect/spark_spread/s = new /datum/effect/spark_spread
	s.set_up(2, 1, src)
	s.start()
	src.last_spark = world.time
	use_power_oneoff(2000)
	var/turf/location = src.loc
	if (isturf(location))
		location.hotspot_expose(1000,500,1)
	return 1

/obj/machinery/sparker/emp_act(severity)
	if(inoperable())
		..(severity)
		return
	ignite()
	..(severity)

/singleton/public_access/public_method/sparker_spark
	name = "spark"
	desc = "Creates sparks to ignite nearby gases."
	call_proc = /obj/machinery/sparker/proc/ignite

/singleton/stock_part_preset/radio/receiver/sparker
	frequency = BUTTON_FREQ
	receive_and_call = list("button_active" = /singleton/public_access/public_method/sparker_spark)

/obj/machinery/button/ignition
	name = "ignition switch"
	desc = "A remote control switch for a mounted igniter."
