/obj/machinery/space_battle/tube
	name = "firing breech"
	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "mass_driver"
	resistance = 2.5
	density = 0
	idle_power_usage = 100
	power_channel = EQUIP
	var/jammed = 0
	var/charging = 0
	var/obj/machinery/space_battle/computer/missile/computer
	var/obj/machinery/space_battle/tube_barrel/barrel
	var/mob/to_kill // Muahaha
	var/list/can_pass = list(/obj/structure/grille, /obj/machinery/shieldwall, /obj/machinery/space_battle/tube_barrel)

	Destroy()
		if(computer)
			computer.tube = null
			computer = null
		if(to_kill)
			qdel(to_kill)
		..()

	New()
		var/turf/T = get_step(loc,dir)
		barrel = locate() in T
		..()

	rename()
		if(computer)
			name = "[initial(name)]([computer.id_num])"

/obj/machinery/space_battle/tube/proc/jammed()
	if(!barrel)
		jammed = 1
	else
		var/list/rails = get_rail_list(0, 0)
		var/obj/machinery/space_battle/tube_barrel/jammed = pick(rails)
		jammed.jam(src)
		jammed = 2

/obj/machinery/space_battle/tube/proc/get_rail_list(var/can_be_blocked = 0, var/must_be_charged = 0, var/jamming = 0, var/brokenaffects = 0)
	var/obj/machinery/space_battle/tube_barrel/next = barrel
	var/list/rails = list()
	var/counting = 1
	while(counting)
		if(!next)
			break
		if(next.jammed && jamming == 1)
			break
		if(next.jammed && jamming == 2)
			return -1
		if(next.current_charge >= next.maxcharge && !(next.stat & (NOPOWER)))
			rails.Add(next)
		if((next.stat & BROKEN) && brokenaffects)
			break
		var/turf/T = get_step(next.loc,dir)
		next = locate() in T
		if(can_be_blocked)
			for(var/obj/O in T)
				if(O.density && !is_type_in_list(O, can_pass))
					if(istype(O, /mob/living))
						var/mob/living/M = O
						M.apply_damage(can_be_blocked)
						M << "<span class='danger'>\The [src] suddenly activates and you're knocked back with great force!</span>"
						T.visible_message("\red [src] staggers under the impact!","\red You stagger under the impact!")
						src.throw_at(get_edge_target_turf(src,dir),1,rand(10,100)) //Rip
					else
						return 0
		if(!next)
			counting = 0
			break
	return rails

/obj/machinery/space_battle/tube/proc/fire_missile(var/turf/location, var/turf/start)
	var/to_return
	var/count = 0
	var/efficiency = get_efficiency(-1, 1)
	if(stat & NOPOWER)
		return "ERROR: Firing tube lacks power!"
	else if(stat & BROKEN)
		return "ERROR: Firing tube malfunction!"
	var/list/rails = get_rail_list(50, 1, 2, 1)
	if(rails == 0)
		return "ERROR: Firing tube blocked!"
	if(rails == -1)
		return "ERROR: Firing tube jammed!"
	for(var/obj/machinery/missile/M in loc)
		count++
		if(jammed) //Failsafe
			return "ERROR: Tube jammed!"
		if(count >= 2)
			jammed()
			qdel(M)
			return "ERROR: Tube jammed due to overload!"
		if(to_kill)
			if(get_dist(to_kill, src) >= 2)
				to_kill = null
			else
				to_kill.loc = M
				to_kill << "<span class='danger'>You're caught in \the [M]'s launch!</span>"

		var/mob/lasttouch = get_mob_by_key(M.fingerprintslast)
		if(lasttouch && lasttouch.client)
			lasttouch.client.missiles_loaded += 1
		if(rails.len)
			M.power *= (1+(rails.len*0.02))
		var/obj/effect/overmap/target = map_sectors["[start.z]"]
		if(target.shielding)
			var/obj/effect/adv_shield/shield = pick(target.shielding.shields)
			if(shield && shield.take_damage(M.damage * 0.4))
				to_return = M.fire_missile(location, start)
			else
				qdel(M)
				to_return = "Missile intercepted by shields!"
		else
			to_return = M.fire_missile(location, start)
		use_power(3000)
		if(computer && computer.firing_angle != "Carefully Aimed")
			if(computer.firing_angle == "Flanking")
				if(prob(10*efficiency))
					jammed()
			if(computer.firing_angle == "Rapid Fire")
				if(prob(30*efficiency))
					jammed()
			else if(prob(5*efficiency))
				jammed()
	if(!count || !to_return)
		var/junk_count = 0
		for(var/atom/movable/A in loc)
			if(A == src) continue
			if(istype(A, /mob/living/carbon))
				A.forceMove(get_turf(start))
				step_towards(A, location)
				A.throw_at(location, 150, 25, src)
				spawn(10)
					if(istype(A, /mob/living/carbon/human))
						var/mob/living/carbon/human/H = A
						H.apply_damage(rand(20,80), BRUTE, null, 0, 0, 0, "Heavy Impact")
			if(istype(A, /obj))
				var/obj/item/weapon/throw_holder = new (get_turf(start))
				throw_holder.name = A.name
				throw_holder.icon = A.icon
				throw_holder.icon_state = A.icon_state
				qdel(A)
				step_towards(throw_holder, location)
				spawn(0)
				throw_holder.throw_at(location, 150, 25, src)
			junk_count++
		if(!junk_count)
			return "ERROR: No missile found!"
		else
			return 1
	var/turf/T = get_turf(src)
	var/datum/gas_mixture/env = T.return_air()
	if(env && env.return_pressure())
		for(var/mob/living/carbon/human/H in view(7))
			var/ear_safety = 0
			if(istype(H:l_ear, /obj/item/clothing/ears/earmuffs) || istype(H:r_ear, /obj/item/clothing/ears/earmuffs))
				ear_safety += 2
			if(istype(H:head, /obj/item/clothing/head/helmet))
				ear_safety += 1
			if(ear_safety < 2)
				if(prob(100-(33*ear_safety)))
					H.ear_damage += rand(0, 5)
					H.ear_deaf = max(H.ear_deaf,15)
	flick("mass_driver_anim", src)
	if(to_return == 1)
		for(var/obj/machinery/space_battle/tube_barrel/B in rails)
			B.fired()
			sleep(1)
	spawn(5)
		return to_return

/obj/item/weapon/throw_holder

	throw_impact()
		explosion(src, 0, 0, 1, 2)
		qdel(src)

/obj/machinery/space_battle/tube/attackby(var/obj/item/O, var/mob/user)
	var/efficiency = get_efficiency(-1,1)
	if(istype(O, /obj/item/weapon/screwdriver) && jammed)
		user.visible_message("<span class='notice'>\The [user] begins to unjam \the [src]..</span>")
		if(do_after(user, rand(100,200)))
			user.visible_message("<span class='notice'>[user] carefully unjams \the [src]!</span>", "<span class='notice'>You unjam \the [src]!</span>")
			if(prob(10*efficiency))
				user << "<span class='warning'>Whilst unjamming \the [src], your arm gets stuck in the mechanism! You need a moment to get free..</span>"
				to_kill = user
				user.Weaken(30)
			if(user.client)
				user.client.repairs_made += 1
			jammed = 0
			return
	..()

/obj/machinery/space_battle/tube/attack_hand(var/mob/user)
	if(computer)
		user << "<span class='notice'>You begin unlocking \the [src]'s manual control panel..</span>"
		if(do_after(user, rand(100,200)))
			computer.attack_hand(user, 1)
			return


/obj/machinery/space_battle/tube/Crossed(atom/movable/A as mob|obj)
	if(computer)
		if(computer.eye)
			if(istype(A, /obj) || istype(A, /mob/living))
				computer.eye << "<span class='notice'>Loaded: [A]</span>"
	if(barrel && istype(A, /obj/machinery/missile))
		barrel.charge_up()
	else if(!barrel) // try locating the barrel again.
		var/turf/T = get_step(loc,dir)
		barrel = locate() in T
		if(barrel)
			barrel.charge_up()
	..()

/obj/machinery/space_battle/tube/examine(var/mob/user)
	if(jammed)
		user << "<span class='warning'>It appears to be jammed!</span>"
	..()
//	var/obj/machinery/missile/missile = locate() in get_turf(src)
//	if(missile)
//		user << "<span class='warning'>It has a charging missile on it at [missile.get_charge()]</span>"

/obj/machinery/space_battle/tube_barrel
	name = "firing tube"
	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "barrel"
	density = 1

	idle_power_usage = 1
	power_channel = EQUIP

	var/jammed = 0
	var/maxcharge = 100
	var/current_charge = 0
	active_power_usage = 20
	var/obj/machinery/space_battle/tube/tube
	has_circuit = 0
	can_be_destroyed = 0
	max_damage = 3


	New()
		layer = 2.6
		..()

	Destroy()
		tube = null
		..()

	process()
		if(use_power == 1)
			processing_objects.Remove(src)
			return
		else
			if(!(stat & (NOPOWER|BROKEN) || jammed))
				current_charge += active_power_usage/2
				if(current_charge >= maxcharge)
					flick("[initial(icon_state)]_charging", src)
					spawn(3.4)
						update_icon()
					var/turf/T = get_step(loc,dir)
					var/obj/machinery/space_battle/tube_barrel/next = locate() in T
					if(next)
						next.charge_up()
					use_power = 1
					processing_objects.Remove(src)

	update_icon()
		if(!(stat & (BROKEN|NOPOWER)))
			if(jammed)
				icon_state = "[initial(icon_state)]_jammed"
			else if(current_charge >= maxcharge)
				icon_state = "[initial(icon_state)]_charged"
			else
				icon_state = initial(icon_state)
		else return ..()

/obj/machinery/space_battle/tube_barrel/break_machine()
	..()
	if(damage_level)
		density = 0

/obj/machinery/space_battle/tube_barrel/fix_machine()
	density = 1

/obj/machinery/space_battle/tube_barrel/ex_act(var/severity)
	if(severity == 1 || (severity == 2 && prob(50)))
		current_charge = 0
		..()

/obj/machinery/space_battle/tube_barrel/proc/fired()
	flick("[initial(icon_state)]_firing", src)
	current_charge = 0
	use_power = 1
	update_icon()
	processing_objects.Remove(src)


/obj/machinery/space_battle/tube_barrel/proc/charge_up()
	if(current_charge >= maxcharge || use_power > 1) return
	use_power = 2
	processing_objects.Add(src)

/obj/machinery/space_battle/tube_barrel/proc/jam(var/obj/machinery/space_battle/tube/T)
	tube = T
	jammed = 1
	update_icon()

/obj/machinery/space_battle/tube_barrel/Bumped(var/atom/A as obj|mob)
	if(istype(A, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = A
		H.visible_message("<span class='notice'>\The [H] tries to slip under \the [src]...</span>")
		if(do_after(usr, rand(5,60)))

			H.forceMove(get_turf(src))
			return
	return ..()


/obj/machinery/space_battle/tube_barrel/attackby(var/obj/item/O, var/mob/user)
	var/efficiency = get_efficiency(-1,1)
	if(istype(O, /obj/item/weapon/screwdriver) && jammed)
		user.visible_message("<span class='notice'>\The [user] begins to unjam \the [src]..</span>")
		if(do_after(user, (rand(100,200)*efficiency)))
			user.visible_message("<span class='notice'>[user] carefully unjams \the [src]!</span>", "<span class='notice'>You unjam \the [src]!</span>")
			if(prob(10*efficiency))
				user << "<span class='warning'>Whilst unjamming \the [src], your arm gets stuck in the mechanism! You need a moment to get free...</span>"
				user.Weaken(30)
			if(user.client)
				user.client.repairs_made += 1
			jammed = 0
			update_icon()
			return
	..()



