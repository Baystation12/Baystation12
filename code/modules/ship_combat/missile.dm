var/global/missile_starts = list()

/obj/item/weapon/missile_grab
	name = "grab"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "reinforce"
	flags = 0
	layer = 21
	abstract = 1
	item_state = "nothing"
	w_class = 20.0

	var/mob/living/carbon/human/container
	var/obj/machinery/missile/holding
	var/destroying = 0

	Destroy()
		invisibility = 101
		destroying = 1
		if(container && src in container)
			container.drop_from_inventory(src)
		loc = null
		container = null
		holding = null
		return ..()

	New()
		..()
		processing_objects.Add(src)

	process()
		if(destroying) return PROCESS_KILL
		if(!container || !src in container)
			dropped()
		return

	dropped()
		if(!destroying)
			holding.let_go()
			qdel(src)
		return 0


	throw_at()
		dropped()
		return

/obj/machinery/missile
	name = "light missile"
	desc = "A light proximity missile!"
	icon = 'icons/obj/missile.dmi'
	icon_state = "light"

	w_class = 100
	can_pull = 0
	density = 0

	var/list/grabs = list()
	var/req_grabs = 1
	var/width = 1
	var/space_only = 1
	var/moving = 0
	var/delay_time = 0
	var/move_delay = 0
	var/power = 1
	var/range = 6

	var/damage = 10 // used for fake ships

	var/spawn_type = /obj/item/missile/ship

	New()
		..()
		processing_objects.Add(src)

	Destroy()
		processing_objects.Remove(src)
		let_go()
		..()

	proc/let_go()
		for(var/mob/living/carbon/human/H in grabs)
			for(var/obj/item/weapon/missile_grab/G in H.contents)
				G.destroying = 1
				G.dropped(H)
				qdel(G)
			H << "<span class='warning'>You let go of \the [src]!</span>"
			H.machine = null
		grabs.Cut()
		moving = 0

/obj/machinery/missile/Move(var/newloc)
	var/obj/machinery/missile/M = locate() in newloc
	if(M)
		return 0
	return ..()

/obj/machinery/missile/attack_hand(mob/user as mob)
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.a_intent == I_GRAB)
			if(H.machine && H.machine == src)
				user.visible_message("<span class='notice'>[user] lets go of \the [src]!</span>", "<span class='notice'>You let go of \the [src]!</span>")
				let_go()
				return
			else if(H.get_active_hand() || H.get_inactive_hand())
				user << "<span class='notice'>You need two free hands to carry \the [src]!</span>"
			else if(!H.stat && !H.lying && !H.restrained())
				if(H.machine)
					H.machine = null
				grabs += H
				H.visible_message("<span class='warning'>[user] grabs \the [src]!</span>", "<span class='warning'>You grab \the [src]</span>")
				H.machine = src
				var/obj/item/weapon/missile_grab/G = new (get_turf(src))
				var/obj/item/weapon/missile_grab/G2 = new (get_turf(src))
				G.holding = src
				G2.holding = src
				G.container = H
				G2.container = H
				H.put_in_hands(G)
				H.put_in_hands(G2)
				src.add_fingerprint(usr)

	//Copied from multi_tile.dm
//	switch(dir)
//		if(EAST, WEST)
//			bound_width = width * world.icon_size
//			bound_height = world.icon_size
//		else
//			bound_width = world.icon_size
//			bound_height = width * world.icon_size
	return

/obj/machinery/missile/relaymove(var/mob/user, var/direction)
	var/mob/living/carbon/human/H = user
	if(!istype(H)) return 0
	if(!Adjacent(H))
		for(var/mob/living/carbon/human/toremove in grabs)
			if(toremove == user)
				for(var/obj/item/weapon/missile_grab/G in H.contents)
					if(!G.destroying)
						G.dropped()
		return 0
	if(grabs.len >= req_grabs)
		if(moving)
			user << "<span class='notice'>The [src] is already moving!</span>"
			return 1
		if(H == grabs[1])
			var/turf/T = get_step_to(src, get_step(src, direction))
			for(var/obj/O in T)
				if(T.density)
					user << "<span class='warning'>You cannot move \the [src] there!</span>"
					return 1
			H.visible_message("<span class='notice'>[H] begins moving \the [src]..</span>")
			moving = 1
			var/N = max(1, (grabs.len - req_grabs) + 1)
			if(do_after(H, (move_delay*H.species.brute_mod)/N))
				moving = 0
				step_to(src, get_step_to(src, get_step(src, direction)))
				for(var/mob/M in grabs)
					step_to(M, get_step_to(src, get_step(src, direction)))
			else
				moving = 0
				return 1
		else
			var/mob/M = grabs[1]
			H << "<span class='notice'>[M] is directing \the [src]!</span>"
	return 1

/obj/machinery/missile/proc/fire_missile(var/turf/location, var/obj/start)
	if(start)
//		var/turf/T = get_turf(start)
//		if(T)
//			var/randdir = pick(300; 0, EAST, NORTH, SOUTH)
//			if(randdir)
//				var/randstep = rand(1,10)
//				while(randstep)
//					randstep--
//					T = get_step(T, randdir)
//				if(T) start = T
		var/obj/item/missile/ship/projectile = new spawn_type(get_turf(start), location)
		projectile.power = power
		step_towards(projectile, location)
		spawn(0)
		projectile.throw_at(location, 150, 2, src)
		qdel(src)
	else
		return "ERROR: Unable to find firing location!"
	return 1


//obj/machinery/missile/ex_act(var/severity)
//	var/obj/item/missile/ship/projectile = new spawn_type(get_turf(src))
//	projectile.throw_impact(src)
//	qdel(src)
//	return


/obj/missile_start
	name = "missile start location"
	invisibility = 101
	density = 0
	anchored = 1
	var/active = 1 // Do we have a core?
	var/team = 0
	var/alive = 1 // Do we count towards round finish?
	var/initialised = 0

	New()
		..()
		var/area/ship_battle/A = get_area(src)
		if(A && istype(A))
			team = A.team
		if(!(src in missile_starts))
			missile_starts += src

	initialize()
		..()
		spawn(100)
			refresh_alive()
			initialised = 1


	proc/refresh_alive()
		if(!initialised)
			alive = 1
		else
			alive = 0
			var/datum/game_mode/ship_battles/mode = ticker.mode
			for(var/I in mode.teams)
				if(text2num(I) == src.team)
					alive = 1

	proc/refresh_active()
		if(!initialised)
			alive = 1
			return 1
		else if(ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/ship_battles))
			active = 0
			for(var/obj/machinery/space_battle/ship_core/S in world)
				if(S.z == src.z)
					active = 1
					break
		else
			testing("Ticker mode is not correct!")
		return active



/obj/item/missile/ship

	name = "active missile"
	desc = "This looks dangerous"
	var/fuse = 60 // 60 ticks until self destruct
	var/ap = 0
	var/turf/target
	var/power = 1

	proc/breach(var/turf/simulated/wall/W)
		world << "Breaching!"
		if(!W || !istype(W)) return 0
		do
			var/ap_cost = 5
			var/atom/next = get_step(src, dir)
			if(istype(next, /turf/simulated/wall))
				ap_cost = 10
				if(istype(next, /turf/simulated/wall/r_wall))
					ap_cost = 15
			else if(istype(next, /obj))
				var/obj/N = next
				if(N.density)
					break
			ap -= ap_cost
			if(!ap)
				break
			src.loc = next
		while(ap)
		return 1

	proc/boom(atom/hit_atom)
		explosion(hit_atom, 0, 0, 2, 4)
		qdel(src)
		return

	Bump(atom/hit_atom)
		boom(hit_atom)
		..()

	throw_impact(atom/hit_atom)
		boom(hit_atom)
		return


	process()
		fuse--
		if(fuse <= 0)
			var/turf/T = get_turf(src)
			throw_impact(T) // Lazy way of doing it.
			return PROCESS_KILL

	New(var/turf/target_location)
		..()
		processing_objects.Add(src)
		target = target_location

	Destroy()
		processing_objects.Remove(src)
		..()

	Move(var/newloc)
		if(newloc)
			var/obj/machinery/space_battle/ship_core/S = locate() in newloc
			if(S)
				return Bump(S)
		return ..()

/obj/item/missile/ship/incend/boom(atom/hit_atom)
	explosion(hit_atom, 0, 0, rand(0,2), 7)
	if(istype(hit_atom, /turf))
		var/turf/T = hit_atom
		T.hotspot_expose(1000,1000)
	qdel(src)
	return

/obj/item/missile/ship/incend/breach
	ap = 20

	throw_impact(atom/hit_atom, speed)
		if(speed && ap && target)
			breach()
			spawn(1)
				boom(hit_atom)
		else boom(hit_atom)

	boom(atom/hit_atom)
		reagents.splash(hit_atom, reagents.total_volume)
		hit_atom.visible_message("<span class='danger'>\The [src] starts spewing out a noxious liquid!</span>")
		spawn(100)
			if(istype(hit_atom, /turf))
				var/turf/T = hit_atom
				T.hotspot_expose(1000,1000)
			qdel(src)
			return

	New(var/atom/target)
		var/datum/reagents/R = new/datum/reagents(1000)
		reagents = R
		R.my_atom = src
		..()


