/obj/machinery/space_battle/warp_pad
	name = "warp pad"
	desc = "A pad used to warp across ships, or sections of ships."
	icon_state = "tele"
	density = 0

	var/obj/machinery/space_battle/warp_pad/destination
	var/list/destinations = list()
	var/cpt = 100 // cost per tile.
	var/cps = 1000 // cost per sector

	initialize()
		..()
		reconnect()

	reconnect()
		..()
		for(var/obj/machinery/space_battle/warp_pad/P in world)
			if(P != src && P.id_tag && P.id_tag == src.id_tag)
				destinations.Add(P)
		destination = pick(destinations)

	attack_hand(var/mob/user)
		var/index = destinations.Find(destination)
		if(index >= destinations.len)
			index = 1
		else index++
		destination = destinations[index]
		var/area/A = get_area(destination)
		src.visible_message("<span class='notice'>\The [user] sets \the [src]'s destination to: [A ? A.name : src.name]!</span>")

	Crossed(atom/movable/A as mob|obj)
		..()
		if(istype(A, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = A
			if(!H.canmove) return
			var/turf/T = src.loc
			var/obj/structure/cable/C = T.get_cable_node()
			var/datum/powernet/powernet
			if(C)	powernet = C.powernet		// find the powernet of the connected cable
			if(powernet && istype(powernet))
				if(destination && istype(destination))
					if(!(destination.stat & (BROKEN|NOPOWER)))
						var/cost = get_cost()
						if(cost)
							if(powernet.draw_power(cost))
								H << "<span class='notice'>\The [src] glows brightly as it begins warming up..</span>"
								if(do_after(H, max(20, cost / 100)))
									teleport(H)
							else
								H << "<span class='warning'>\The [src] buzzes, \"No power!\"</span>"
						else
							H << "<span class='warning'>\The [src] buzzes, \"Unable to find destination!\"</spna>"
					else
						H << "<span class='warning'>\The [src] buzzes, \"Destination not responding!\"</span>"
				else
					H << "<span class='warning'>\The [src] buzzes, \"No destination!\"</span>"
			else
				H << "<span class='warning'>\The [src] buzzes, \"No connected power cables!\"</span>"

	proc/teleport(var/mob/living/carbon/human/H)
		if(H && istype(H))
			if(prob(80))
				H << "<span class='warning'>You feel a sudden sense of vertigo, falling over!</span>"
				var/efficiency = get_efficiency(1,0)
				if(efficiency < 150)
					H.Weaken(rand(1,10))
					if(efficiency < 100)
						H.Stun(rand(1,10))
						if(efficiency < 70)
							H.Paralyse(rand(1,10))
							if(efficiency < 40)
								H.apply_damage(rand(1,10))
			if(prob(5 * get_efficiency(0,1)))
				var/area/A = get_area(destination)
				if(A)
					H << "<span class='danger'>\The [src] buzzes briefly before your vision is filled with light!</span>"
					spawn(10)
						H.forceMove(pick_area_turf(A))
			H.forceMove(get_turf(destination))
			src.visible_message("<span class='notice'>\The [H] disappears in a sudden flash of light!</span>")


	proc/get_cost()
		if(destination.z == src.z)
			return abs(get_dist(src, destination) * cpt * get_efficiency(-1, 1))
		else
			var/obj/effect/overmap/linked = map_sectors["[z]"]
			if(!linked)
				return 0 // Hax.
			var/obj/effect/overmap/target = map_sectors["[destination.z]"]
			if(!target)
				return 0
			var/dist = get_dist(linked,target)
			return abs(dist * cps * get_efficiency(-1,1))

