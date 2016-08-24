/obj/machinery/space_battle/warp_pad
	name = "warp pad"
	desc = "A pad used to warp across ships, or sections of ships."
	icon_state = "tele0"

	var/obj/machinery/space_battle/warp_pad/destination
	var/list/destinations = list()
	var/cpt = 100 // power cost per tile
	var/stored_charge = 0
	var/charge_rate = 10

	New()
		..()
		for(var/obj/machinery/space_battle/warp_pad/P in world)
			if(P.id_tag && P.id_tag == src.id_tag)
				destinations.Add(P)
		destination = pick(destinations)

	process()
		var/turf/T = get_turf(src)
		var/mob/living/carbon/human/H = locate() in T
		if(H)
			if(!stored_charge)
				src.visible_message("<span class='notice'>\The [src] begins warming up!</span>")
				update_icon()
			var/efficiency = 0.1
			if(circuit_board)
				efficiency = circuit_board.get_efficiency(0,1,1)
			var/obj/structure/cable/C = T.get_cable_node()
			var/datum/powernet/PN
			if(C)	PN = C.powernet		// find the powernet of the connected cable

			if(PN)
				stored_charge += PN.draw_power(charge_rate * efficiency)
			if(stored_charge >= get_cost())
				if(!destination)
					src.visible_message("</span class='warning'>\The [src] beeps, \"Error: Destination unreachable!\"</span>")
					stored_charge = 0
					return
				playsound(src.loc, 'sound/weapons/emitter.ogg', 25, 1)
				H.visible_message("<span class='notice'>\The [H] dissapears in a flash of blue light!</span>")
				var/turf/newturf = get_turf(destination)
				if(T)
					H.forceMove(newturf)
				else
					H.forceMove(destination)
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(5, 1, src)
				s.start()
				var/datum/effect/effect/system/spark_spread/d = new /datum/effect/effect/system/spark_spread
				d.set_up(5, 1, destination)
				d.start()
				H.Paralyse(10)
				if(prob(90))
					spawn(rand(1,200))
						H << "<span class='notice'>You feel tingly.</span>"
				else
					spawn(rand(1,200))
						H << "<span class='notice'>You feel tingly from the recent warp and your legs give way!</span>"
						H.Weaken(rand(1,20))
		else if(stored_charge)
			stored_charge -= 50
			if(stored_charge <= 0)
				update_icon()

	examine(var/mob/user)
		..()
		if(stored_charge && destination)
			user << "<span class='notice'>It is [((stored_charge / get_cost()) * 100)]% charged!</span>"

	proc/get_cost()
		return (get_dist(src, destination) * cpt * (circuit_board ? circuit_board.get_efficiency(-1,1,1) : 1.8))

	update_icon()
		if(stored_charge)
			icon_state = "tele1"
		else
			icon_state = initial(icon_state)


