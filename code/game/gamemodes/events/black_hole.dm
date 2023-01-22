/obj/effect/bhole
	name = "black hole"
	icon = 'icons/obj/objects.dmi'
	desc = "FUCK FUCK FUCK AAAHHH!"
	icon_state = "bhole3"
	opacity = 1
	unacidable = TRUE
	density = FALSE
	anchored = TRUE

/obj/effect/bhole/New()
	spawn(4)
		controller()

/obj/effect/bhole/proc/controller()
	while(src)

		if(!isturf(loc))
			qdel(src)
			return

		//DESTROYING STUFF AT THE EPICENTER
		for(var/mob/living/M in orange(1,src))
			qdel(M)
		for(var/obj/O in orange(1,src))
			qdel(O)
		var/base_turf = get_base_turf_by_area(src)
		for(var/turf/simulated/ST in orange(1,src))
			if(ST.type == base_turf)
				continue
			ST.ChangeTurf(base_turf)

		sleep(6)
		grav(10, EX_ACT_LIGHT, 10, 0 )
		sleep(6)
		grav( 8, EX_ACT_LIGHT, 10, 0 )
		sleep(6)
		grav( 9, EX_ACT_LIGHT, 10, 0 )
		sleep(6)
		grav( 7, EX_ACT_HEAVY, 40, 1 )
		sleep(6)
		grav( 5, EX_ACT_HEAVY, 40, 1 )
		sleep(6)
		grav( 6, EX_ACT_HEAVY, 40, 1 )
		sleep(6)
		grav( 4, EX_ACT_DEVASTATING, 50, 6 )
		sleep(6)
		grav( 3, EX_ACT_DEVASTATING, 50, 6 )
		sleep(6)
		grav( 2, EX_ACT_DEVASTATING, 75,25 )
		sleep(6)



		//MOVEMENT
		if( prob(50) )
			src.anchored = FALSE
			step(src,pick(GLOB.alldirs))
			src.anchored = TRUE

/obj/effect/bhole/proc/grav(var/r, var/ex_act_force, var/pull_chance, var/turf_removal_chance)
	if(!isturf(loc))	//blackhole cannot be contained inside anything. Weird stuff might happen
		qdel(src)
		return
	for(var/t = -r, t < r, t++)
		affect_coord(x+t, y-r, ex_act_force, pull_chance, turf_removal_chance)
		affect_coord(x-t, y+r, ex_act_force, pull_chance, turf_removal_chance)
		affect_coord(x+r, y+t, ex_act_force, pull_chance, turf_removal_chance)
		affect_coord(x-r, y-t, ex_act_force, pull_chance, turf_removal_chance)
	return

/obj/effect/bhole/proc/affect_coord(var/x, var/y, var/ex_act_force, var/pull_chance, var/turf_removal_chance)
	//Get turf at coordinate
	var/turf/T = locate(x, y, z)
	if(isnull(T))	return

	//Pulling and/or ex_act-ing movable atoms in that turf
	if( prob(pull_chance) )
		for(var/obj/O in T.contents)
			if(O.anchored)
				O.ex_act(ex_act_force)
			else
				step_towards(O,src)
		for(var/mob/living/M in T.contents)
			step_towards(M,src)

	//Destroying the turf
	if( T && istype(T,/turf/simulated) && prob(turf_removal_chance) )
		var/turf/simulated/ST = T
		var/base_turf = get_base_turf_by_area(src)
		if(ST.type != base_turf)
			ST.ChangeTurf(base_turf)
