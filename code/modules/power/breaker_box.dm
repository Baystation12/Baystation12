// Updated version of old powerswitch by Atlantis
// Has better texture, and is now considered electronic device
// AI has ability to toggle it in 5 seconds
// Humans need 30 seconds (AI is faster when it comes to complex electronics)
// Used for advanced grid control (read: Substations)

/obj/machinery/power/breakerbox
	name = "Breaker Box"
	icon = 'icons/obj/power.dmi'
	icon_state = "bbox_off"
	//directwired = 0
	var/icon_state_on = "bbox_on"
	var/icon_state_off = "bbox_off"
	flags = FPRINT
	density = 1
	anchored = 1
	var/on = 0
	var/busy = 0
	var/directions = list(1,2,4,8,5,6,9,10)

/obj/machinery/power/breakerbox/activated
	icon_state = "bbox_on"

	// Enabled on server startup. Used in substations to keep them in bypass mode.
/obj/machinery/power/breakerbox/activated/initialize()
	set_state(1)

/obj/machinery/power/breakerbox/examine(mob/user)
	user << "Large machine with heavy duty switching circuits used for advanced grid control"
	if(on)
		user << "\green It seems to be online."
	else
		user << "\red It seems to be offline"

/obj/machinery/power/breakerbox/attack_ai(mob/user)
	if(busy)
		user << "\red System is busy. Please wait until current operation is finished before changing power settings."
		return

	busy = 1
	user << "\green Updating power settings.."
	if(do_after(user, 50)) //5s for AI as AIs can manipulate electronics much faster.
		set_state(!on)
		user << "\green Update Completed. New setting:[on ? "on": "off"]"
	busy = 0


/obj/machinery/power/breakerbox/attack_hand(mob/user)

	if(busy)
		user << "\red System is busy. Please wait until current operation is finished before changing power settings."
		return

	busy = 1
	for(var/mob/O in viewers(user))
		O.show_message(text("\red [user] started reprogramming [src]!"), 1)

	if(do_after(user, 300)) // 30s for non-AIs as humans have to manually reprogram it and rapid switching may cause some lag / powernet updates flood. If AIs spam it they can be easily traced.
		set_state(!on)
		user.visible_message(\
		"<span class='notice'>[user.name] [on ? "enabled" : "disabled"] the breaker box!</span>",\
		"<span class='notice'>You [on ? "enabled" : "disabled"] the breaker box!</span>")
	busy = 0

/obj/machinery/power/breakerbox/proc/set_state(var/state)
	on = state
	if(on)
		icon_state = icon_state_on
		var/list/connection_dirs = list()
		for(var/direction in directions)
			for(var/obj/structure/cable/C in get_step(src,direction))
				if(C.d1 == turn(direction, 180) || C.d2 == turn(direction, 180))
					connection_dirs += direction
					break

		for(var/direction in connection_dirs)
			var/obj/structure/cable/C = new/obj/structure/cable(src.loc)
			C.d1 = 0
			C.d2 = direction
			C.icon_state = "[C.d1]-[C.d2]"
			C.breaker_box = src

			var/datum/powernet/PN = new()
			PN.add_cable(C)

			C.mergeConnectedNetworks(C.d2)
			C.mergeConnectedNetworksOnTurf()

			if(C.d2 & (C.d2 - 1))// if the cable is layed diagonally, check the others 2 possible directions
				C.mergeDiagonalsNetworks(C.d2)

	else
		icon_state = icon_state_off
		for(var/obj/structure/cable/C in src.loc)
			del(C)
