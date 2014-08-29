// Updated version of old powerswitch by Atlantis
// Has better texture, and is now considered electronic device
// AI has ability to toggle it in 5 seconds
// Humans need 30 seconds (AI is faster when it comes to complex electronics)
// Used for advanced grid control (read: Substations)

/obj/structure/breakerbox
	name = "Breaker Box"
	desc = "Large panel with breakers used to control connected power circuits."
	icon = 'icons/obj/power.dmi'
	icon_state = "bbox_off"
	var/icon_state_on = "bbox_on"
	var/icon_state_off = "bbox_off"
	flags = FPRINT
	density = 1
	anchored = 1
	var/on = 0
	var/busy = 0

/obj/structure/breakerbox/examine()
	..()
	usr << "Large machine with heavy duty switching circuits used for advanced grid control"
	if(on)
		usr << "\green It seems to be online."
	else
		usr << "\red It seems to be offline"

/obj/structure/breakerbox/attack_ai(mob/user)
	if(busy)
		user << "\red System is busy. Please wait until current operation is finished before changing power settings."
		return

	..()

	busy = 1
	user << "\green Updating power settings.."
	if(do_after(user, 50)) //5s for AI as AIs can manipulate electronics much faster.
		set_state(!on)
		user << "\green Update Completed. New setting:[on ? "on": "off"]"
	busy = 0


/obj/structure/breakerbox/attack_hand(mob/user)

	if(busy)
		user << "\red System is busy. Please wait until current operation is finished before changing power settings."
		return

	..()

	busy = 1
	for(var/mob/O in viewers(user))
		O.show_message(text("\red [user] started reprogramming [src]!"), 1)

	if(do_after(user, 300)) // 30s for non-AIs as humans have to manually reprogram it and rapid switching may cause some lag / powernet updates flood. If AIs spam it they can be easily traced.
		set_state(!on)
		for(var/mob/O in viewers(user))
			O.show_message(text("\red [user] finished reprogramming the [src]!"), 1)
	busy = 0

/obj/structure/breakerbox/proc/set_state(var/state)
	on = state
	if(on)
		icon_state = icon_state_on
		var/list/connection_dirs = list()
		for(var/direction in list(1,2,4,8,5,6,9,10))
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
			PN.number = powernets.len + 1
			powernets += PN
			PN.cables += C

			C.mergeConnectedNetworks(C.d2)
			C.mergeConnectedNetworksOnTurf()

	else
		icon_state = icon_state_off
		for(var/obj/structure/cable/C in src.loc)
			del(C)
