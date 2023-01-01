#define NEIGHBOR_REFRESH_TIME 100

/obj/effect/vine/proc/get_cardinal_neighbors()
	var/list/cardinal_neighbors = list()
	for(var/check_dir in GLOB.cardinal)
		var/turf/simulated/T = get_step(get_turf(src), check_dir)
		if(istype(T))
			cardinal_neighbors |= T
	return cardinal_neighbors

/obj/effect/vine/proc/get_zlevel_neighbors()
	var/list/zlevel_neighbors = list()

	var/turf/start = loc
	var/turf/up = GetAbove(loc)
	var/turf/down = GetBelow(loc)

	if(start && start.CanZPass(src, DOWN))
		zlevel_neighbors += down
	if(up && up.CanZPass(src, UP))
		zlevel_neighbors += up

	return zlevel_neighbors

/obj/effect/vine/proc/get_neighbors()
	var/list/neighbors = list()

	for(var/turf/simulated/floor in get_cardinal_neighbors())
		if(get_dist(parent, floor) > spread_distance)
			continue

		var/blocked = 0
		for(var/obj/effect/vine/other in floor.contents)
			if(other.seed == src.seed)
				blocked = 1
				break
		if(blocked)
			continue

		if(floor.density)
			if(LAZYACCESS(seed.chems, /datum/reagent/acid/polyacid))
				spawn(rand(5,25)) floor.ex_act(EX_ACT_LIGHT)
			continue

		if(!Adjacent(floor) || !floor.Enter(src))
			continue

		neighbors |= floor

	neighbors |= get_zlevel_neighbors()
	return neighbors

/obj/effect/vine/Process()
	var/turf/simulated/T = get_turf(src)
	if(!istype(T))
		return

	//Take damage from bad environment if any
	adjust_health(-seed.handle_environment(T,T.return_air(),null,1))
	if(health <= 0)
		return

	//Vine fight!
	for(var/obj/effect/vine/other in T)
		if(other.seed != seed)
			other.vine_overrun(seed, src)

	//Growing up
	if(health < max_health)
		adjust_health(1)
		if(round(growth_threshold) && !(health % growth_threshold))
			update_icon()

	if(is_mature())
		//Find a victim
		if(!buckled_mob)
			var/list/mob/living/targets = targets_in_range()
			if(targets && targets.len && prob(round(seed.get_trait(TRAIT_POTENCY)/4)))
				entangle(pick(targets))

		//Handle the victim
		if(buckled_mob)
			seed.do_sting(buckled_mob,src)
			if(seed.get_trait(TRAIT_CARNIVOROUS))
				seed.do_thorns(buckled_mob,src)

		//Try to spread
		if(parent && parent.possible_children && prob(spread_chance))
			var/list/neighbors = get_neighbors()
			if(neighbors?.len)
				spread_to(pick(neighbors))

		//Try to settle down
		if(can_spawn_plant())
			plant = new(T,seed)
			plant.dir = src.dir
			plant.SetTransform(others = transform)
			plant.age = seed.get_trait(TRAIT_MATURATION)-1
			plant.update_icon()
			if(growth_type==0) //Vines do not become invisible.
				set_invisibility(INVISIBILITY_MAXIMUM)
			else
				plant.layer = layer + 0.1

	if(should_sleep())
		STOP_PROCESSING(SSvines, src)

/obj/effect/vine/proc/can_spawn_plant()
	var/turf/simulated/T = get_turf(src)
	return parent == src && health == max_health && !plant && istype(T) && !T.CanZPass(src, DOWN)

/obj/effect/vine/proc/should_sleep()
	if(buckled_mob) //got a victim to fondle
		return FALSE
	if(length(get_neighbors())) //got places to spread to
		return FALSE
	if(health < max_health) //got some growth to do
		return FALSE
	if(targets_in_range()) //got someone to grab
		return FALSE
	if(can_spawn_plant()) //should settle down and spawn a tray
		return FALSE
	return TRUE

//spreading vines aren't created on their final turf.
//Instead, they are created at their parent and then move to their destination.
/obj/effect/vine/proc/spread_to(turf/target_turf)
	var/obj/effect/vine/child = new(get_turf(src),seed,parent) // This should do a little bit of animation.
	//move out to the destination
	if(child.forceMove(target_turf))
		child.update_icon()
		child.set_dir(child.calc_dir())
		child.update_icon()
		// Some plants eat through plating.
		if(islist(seed.chems) && !isnull(seed.chems[/datum/reagent/acid/polyacid]))
			target_turf.ex_act(prob(80) ? EX_ACT_LIGHT : EX_ACT_HEAVY)
	else
		qdel(child)

/obj/effect/vine/proc/wake_neighbors()
	// This turf is clear now, let our buddies know.
	for(var/turf/simulated/check_turf in (get_cardinal_neighbors() | get_zlevel_neighbors()))
		if(!istype(check_turf))
			continue
		for(var/obj/effect/vine/neighbor in check_turf.contents)
			START_PROCESSING(SSvines, neighbor)

/obj/effect/vine/proc/targets_in_range()
	var/list/mob/targets = list()
	for(var/turf/simulated/check_turf in (get_cardinal_neighbors() | get_zlevel_neighbors() | list(loc)))
		if(!istype(check_turf))
			continue
		for(var/mob/living/M in check_turf.contents)
			if(prob(5) || !M.skill_check(SKILL_BOTANY, SKILL_PROF))
				targets |= M
	if(targets.len)
		return targets

/obj/effect/vine/proc/die_off()
	// Kill off our plant.
	if(plant) plant.die()
	wake_neighbors()
	qdel(src)

#undef NEIGHBOR_REFRESH_TIME
