/obj/machinery/atmospherics/valve/shutoff
	icon = 'icons/atmos/clamp.dmi'
	icon_state = "map_vclamp0"

	name = "automatic shutoff valve"
	desc = "An automatic valve with control circuitry and pipe integrity sensor, capable of automatically isolating damaged segments of the pipe network."
	var/close_on_leaks = TRUE	// If false it will be always open
	level = 1
	connect_types = CONNECT_TYPE_SCRUBBER | CONNECT_TYPE_SUPPLY | CONNECT_TYPE_REGULAR | CONNECT_TYPE_FUEL
	build_icon_state = "svalve"

/obj/machinery/atmospherics/valve/shutoff/on_update_icon()
	icon_state = "vclamp[open]"

/obj/machinery/atmospherics/valve/shutoff/examine(mob/user)
	. = ..()
	to_chat(user, "The automatic shutoff circuit is [close_on_leaks ? "enabled" : "disabled"].")

/obj/machinery/atmospherics/valve/shutoff/Initialize()
	. = ..()
	open()
	hide(1)

/obj/machinery/atmospherics/valve/shutoff/interface_interact(var/mob/user)
	if(CanInteract(user, DefaultTopicState()))
		close_on_leaks = !close_on_leaks
		to_chat(user, "You [close_on_leaks ? "enable" : "disable"] the automatic shutoff circuit.")
		return TRUE

/obj/machinery/atmospherics/valve/shutoff/hide(var/do_hide)
	if(do_hide)
		if(level == 1)
			layer = PIPE_LAYER
		else if(level == 2)
			..()
	else
		reset_plane_and_layer()

/obj/machinery/atmospherics/valve/shutoff/Process()
	..()

	if (!network_node1 || !network_node2)
		if(open)
			close()
		return

	if (!close_on_leaks)
		if (!open)
			open()
		return

	if (network_node1.leaks.len || network_node2.leaks.len)
		if (open)
			close()
	else if (!open)
		open()
