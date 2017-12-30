/obj/machinery/atmospherics/valve/shutoff
	icon = 'icons/atmos/clamp.dmi'
	icon_state = "map_vclamp0"

	name = "automatic shutoff valve"
	desc = "An automatic valve with control circuitry and pipe integrity sensor, capable of automatically isolating damaged segments of the pipe network."
	var/override_open = FALSE	// If true it will be always open
	level = 1
	connect_types = CONNECT_TYPE_SCRUBBER | CONNECT_TYPE_SUPPLY | CONNECT_TYPE_REGULAR


/obj/machinery/atmospherics/valve/shutoff/update_icon()
	icon_state = "vclamp[open]"

/obj/machinery/atmospherics/valve/shutoff/examine(var/mob/user)
	..()
	to_chat(user, "The automatic shutoff circuit is [override_open ? "disabled" : "enabled"].")

/obj/machinery/atmospherics/valve/shutoff/New()
	open()
	hide(1)
	..()

/obj/machinery/atmospherics/valve/shutoff/attack_hand(var/mob/user as mob)
	override_open = !override_open
	to_chat(user, "You [override_open ? "disable" : "enable"] the automatic shutoff circuit.")

/obj/machinery/atmospherics/valve/shutoff/attack_ai(var/mob/user as mob)
	attack_hand(user)

/obj/machinery/atmospherics/valve/shutoff/hide(var/do_hide)
	if(do_hide)
		if(level == 1)
			plane = ABOVE_PLATING_PLANE
			layer = PIPE_LAYER
		else if(level == 2)
			..()
	else
		reset_plane_and_layer()

/obj/machinery/atmospherics/valve/shutoff/Process()
	..()

	if(!network_node1 || !network_node2)
		if(open)
			close()
		return

	var/closed_auto = (network_node1.leaks.len || network_node2.leaks.len || override_open)

	if(closed_auto && open)
		close()
	else if(!closed_auto && !open)
		open()