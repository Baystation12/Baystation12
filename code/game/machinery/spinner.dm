/obj/machinery/spinner
	name = "spinner"
	icon = 'icons/obj/stationobjs.dmi' // remove when done
	icon_state = "spinner"
	desc = "A thing that spin things."
	plane = ABOVE_TURF_PLANE
	layer = ABOVE_TILE_LAYER
	anchored = 1
	use_power = 1
	idle_power_usage = 10


/obj/machinery/spinner/proc/spin()
	if(!isturf(loc))
		return
	for(var/atom/movable/A in get_turf(src))
		if(A.simulated && !A.anchored)
			A.dir = turn(A.dir,90)

/obj/machinery/spinner/attack_hand(mob/user as mob)
	spin()

/obj/machinery/spinner/attack_ai(mob/user as mob)
	return attack_hand(user)
