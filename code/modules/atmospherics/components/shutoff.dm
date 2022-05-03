#define NODE1_CLOSED 1
#define NODE2_CLOSED 2

/obj/machinery/atmospherics/valve/shutoff
	icon = 'icons/atmos/clamp.dmi'
	icon_state = "map_vclamp0"

	name = "automatic shutoff valve"
	desc = "An automatic valve with control circuitry and pipe integrity sensor, capable of automatically isolating damaged segments of the pipe network."
	clicksound = 'sound/machines/buttonbeep.ogg'
	clickvol = 20
	var/close_on_leaks = TRUE	// If false it will be always open
	var/shutoff_state = 0
	level = 1
	connect_types = CONNECT_TYPE_REGULAR
	build_icon_state = "svalve"

/obj/machinery/atmospherics/valve/shutoff/on_update_icon()
	icon_state = "vclamp[icon_connect_type]"
	overlays.Cut()
	if (!close_on_leaks)
		overlays += image('icons/atmos/clamp.dmi', "override[icon_connect_type]")
		return
	if (shutoff_state & NODE1_CLOSED)
		overlays += image('icons/atmos/clamp.dmi', "closed1[icon_connect_type]")
	if (shutoff_state & NODE2_CLOSED)
		overlays += image('icons/atmos/clamp.dmi', "closed2[icon_connect_type]")

/obj/machinery/atmospherics/valve/shutoff/examine(mob/user)
	. = ..()
	to_chat(user, "The automatic shutoff circuit is [close_on_leaks ? "enabled" : "disabled"].")

/obj/machinery/atmospherics/valve/shutoff/Initialize()
	. = ..()
	open()

/obj/machinery/atmospherics/valve/atmos_init()
	. = ..()
	var/turf/T = loc
	hide(hides_under_flooring() && !T.is_plating())

/obj/machinery/atmospherics/valve/shutoff/interface_interact(mob/user)
	if(CanInteract(user, DefaultTopicState()))
		close_on_leaks = !close_on_leaks
		update_icon()
		to_chat(user, SPAN_NOTICE("You [close_on_leaks ? "enable" : "disable"] the automatic shutoff circuit."))
		CouldUseTopic(user)
		return TRUE

/obj/machinery/atmospherics/valve/shutoff/physical_attack_hand(mob/user)
	return FALSE

/obj/machinery/atmospherics/valve/shutoff/hide(var/do_hide)
	if(istype(loc, /turf/simulated))
		set_invisibility(do_hide ? 101 : 0)
	update_underlays()

/obj/machinery/atmospherics/valve/shutoff/Process()
	..()

	var/new_shutoff_state = 0
	if (close_on_leaks)
		if (!network_node1 || network_node1.leaks.len)
			new_shutoff_state |= NODE1_CLOSED
		if (!network_node2 || network_node2.leaks.len)
			new_shutoff_state |= NODE2_CLOSED

	if (shutoff_state == new_shutoff_state)
		return

	shutoff_state = new_shutoff_state

	if (shutoff_state > 0)
		if (open)
			close()
	else if (!open)
		open()

	update_icon()

/obj/machinery/atmospherics/valve/shutoff/scrubbers
	name = "scrubber shutoff valve"
	icon_state = "map_vclamp0-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	icon_connect_type = "-scrubbers"

/obj/machinery/atmospherics/valve/shutoff/supply
	name = "supply shutoff valve"
	icon_state = "map_vclamp0-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	icon_connect_type = "-supply"

/obj/machinery/atmospherics/valve/shutoff/fuel
	name = "fuel shutoff valve"
	connect_types = CONNECT_TYPE_FUEL

#undef NODE1_CLOSED
#undef NODE2_CLOSED