/obj/machinery/space_battle/warp_pad
	name = "warp pad"
	desc = "A pad used to warp across ships, or sections of ships."
	icon_state = "tele"
	density = 0

	var/obj/machinery/space_battle/warp_pad/destination
	var/list/destinations = list()
	var/cpt = 100 // cost per tile.
	var/cps = 1000 // cost per sector
	var/obj/item/weapon/cell/backup_power
	var/teleporting = 0

	initialize()
		..()
		reconnect()

	Destroy()
		if(backup_power)
			qdel(backup_power)
			backup_power = null
		id_tag = null
		for(var/obj/machinery/space_battle/warp_pad/P in destinations)
			P.reconnect()
		destinations.Cut()
		destination = null
		return ..()

	reconnect(var/recurring = 1)
		..()
		destinations.Cut()
		for(var/obj/machinery/space_battle/warp_pad/P in world)
			if(P != src && P.id_tag == src.id_tag && !(P in destinations))
				var/area/ship_battle/us = get_area(src)
				var/area/ship_battle/them = get_area(P)
				if(us.team == them.team)
					destinations.Add(P)
					if(recurring)
						P.reconnect(0)
		if(destinations.len)
			destination = pick(destinations)

	examine(var/mob/user)
		..()
		if(backup_power)
			user << "<span class='notice'>It has a [backup_power] installed with [backup_power.percent()]% charge left!</span>"

	attackby(var/obj/item/I, var/mob/user)
		if(istype(I, /obj/item/weapon/cell))
			if(backup_power && istype(backup_power))
				user.visible_message("<span class='notice'>\The [user] begins replacing the backup power in \the [src] with \the [I]!</span>")
			else
				user.visible_message("<span class='notice'>\The [user] begins installing \the [I]!</span>")
			if(do_after(user, 150))
				if(backup_power)
					backup_power.forceMove(get_turf(src))
					backup_power = null
				backup_power = I
				user.drop_item()
				I.forceMove(src)
		return ..()

	attack_hand(var/mob/user)
		if(destinations.len)
			var/index = destinations.Find(destination)
			if(index >= destinations.len)
				index = 1
			else index++
			destination = destinations[index]
			var/area/A = get_area(destination)
			src.visible_message("<span class='notice'>\The [user] sets \the [src]'s destination to: [A ? A.name : src.name]!</span>")

	Crossed(atom/movable/A as mob|obj)
//		..()
		if(teleporting) return
		var/mob/living/carbon/human/H
		if(istype(A, /mob/living/carbon/human))
			H = A
		else if(isobserver(A))
			teleport(A, 1)
			return
		else if(istype(A, /mob/missile_eye))
			return
		if(!stat & (BROKEN|NOPOWER))
			var/turf/T = src.loc
			var/obj/structure/cable/C = T.get_cable_node()
			var/datum/powernet/powernet
			if(C)	powernet = C.powernet		// find the powernet of the connected cable
			if(powernet && istype(powernet) || backup_power)
				if(destination && istype(destination))
					if(!(destination.stat & (BROKEN|NOPOWER)))
						var/cost = get_cost()
						if(cost)
							var/passed = 0
							if(powernet && powernet.draw_power(cost) == cost)
								passed = 1
							else if(backup_power && backup_power.checked_use(cost/4))
								passed = 2
							if(passed)
								if(H)
									H << "<span class='notice'>\The [src] glows brightly as it begins warming up..</span>"
									if(do_after(H, max(20, (cost / 100) * passed)))
										teleport(H)
								else
									spawn(max(20, (cost / 100) * passed))
										teleport(A)
								return 1
							else if(H)
								H << "<span class='warning'>\The [src] buzzes, \"Insufficient power!\"</span>"
						else if(H)
							H << "<span class='warning'>\The [src] buzzes, \"Unable to find destination!\"</spna>"
					else if(H)
						H << "<span class='warning'>\The [src] buzzes, \"Destination not responding!\"</span>"
				else if(H)
					H << "<span class='warning'>\The [src] buzzes, \"No destination!\"</span>"
			else if(H)
				H << "<span class='warning'>\The [src] buzzes, \"No connected power cables!\"</span>"
		return 0

	proc/teleport(var/atom/teleported as obj|mob, var/forced = 0)
		if(!forced)
			var/mob/living/carbon/holder = locate() in get_turf(src)
			if(holder)
				if(teleported in holder.contents) return
			if(istype(teleported, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = teleported
				H << "<span class='warning'>You feel a sudden sense of vertigo!</span>"
				var/efficiency = get_efficiency(1,0,5)
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
						H << "<span class='danger'>\The [src] flashes a warning briefly before your vision is filled with light!</span>"
						spawn(10)
							H.forceMove(pick_area_turf(A))
		destination.teleporting = 1
		if(istype(teleported, /obj))
			var/obj/O = teleported
			O.forceMove(get_turf(destination))
		else
			var/mob/M = teleported
			M.forceMove(get_turf(destination))
		if(!forced)
			src.visible_message("<span class='notice'>\The [teleported] disappears in a sudden flash of light!</span>")
		spawn(2)
			destination.teleporting = 0


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
			return 1000+abs(dist * cps * get_efficiency(-1,1))

