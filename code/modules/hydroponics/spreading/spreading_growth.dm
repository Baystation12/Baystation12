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

/obj/effect/vine/proc/update_neighbors()
	// Update our list of valid neighboring turfs.

	neighbors = list()

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
			if(!isnull(seed.chems[/datum/reagent/acid/polyacid]))
				spawn(rand(5,25)) floor.ex_act(3)
			continue

		if(!Adjacent(floor) || !floor.Enter(src))
			continue

		neighbors |= floor

	neighbors |= get_zlevel_neighbors()

	if(neighbors.len)
		START_PROCESSING(SSvines, src) //if we have neighbours again, start processing

	// Update all of our friends.
	var/turf/T = get_turf(src)
	for(var/obj/effect/vine/neighbor in range(1,src))
		if(neighbor.seed == src.seed)
			neighbor.neighbors -= T

/obj/effect/vine/Process(var/grow = 1)
	// Something is very wrong, kill ourselves.
	if(!seed)
		die_off()
		return 0

	for(var/obj/effect/effect/smoke/chem/smoke in view(1, src))
		if(smoke.reagents.has_reagent(/datum/reagent/toxin/plantbgone))
			die_off()
			return

	var/turf/simulated/T = get_turf(src)

	if(grow)
		// Handle life.
		if(istype(T))
			health -= seed.handle_environment(T,T.return_air(),null,1)
		if(health < max_health)
			health += 1
			update_icon()
		if(health > max_health)
			health = max_health
		if(parent == src && health == max_health && !plant && istype(T) && !T.CanZPass(src, DOWN))
			plant = new(T,seed)
			plant.dir = src.dir
			plant.transform = src.transform
			plant.age = seed.get_trait(TRAIT_MATURATION)-1
			plant.update_icon()
			if(growth_type==0) //Vines do not become invisible.
				set_invisibility(INVISIBILITY_MAXIMUM)
			else
				plant.layer = layer + 0.1
	else
		START_PROCESSING(SSvines, src)

	if(buckled_mob)
		seed.do_sting(buckled_mob,src)
		if(seed.get_trait(TRAIT_CARNIVOROUS))
			seed.do_thorns(buckled_mob,src)

	if(world.time >= last_tick+NEIGHBOR_REFRESH_TIME)
		if(!grow)	last_tick = world.time
		update_neighbors()

	if(sampled)
		//Should be between 2-7 for given the default range of values for TRAIT_PRODUCTION
		var/chance = max(1, round(15/seed.get_trait(TRAIT_PRODUCTION)))
		if(prob(chance))
			sampled = 0

	if(is_mature())
		if(!buckled_mob)
			var/mob/living/list/targets = targets_in_range()
			if(targets && targets.len && prob(round(seed.get_trait(TRAIT_POTENCY)/4)))
				entangle(pick(targets))

		if(parent && parent.possible_children && neighbors.len && prob(spread_chance))
			spread_to(pick(neighbors))
			update_neighbors()

	// We shouldn't have spawned if the controller doesn't exist.
	check_health()
	if(!(buckled_mob || neighbors.len || (!plant && T && !T.CanZPass(src, DOWN)) || health < max_health) && !targets_in_range())
		STOP_PROCESSING(SSvines, src)

//spreading vines aren't created on their final turf.
//Instead, they are created at their parent and then move to their destination.
/obj/effect/vine/proc/spread_to(turf/target_turf)
	var/obj/effect/vine/child = new(get_turf(src),seed,parent)

	spawn(1) // This should do a little bit of animation.
		if(QDELETED(child))
			return

		//move out to the destination
		child.anchored = 0
		child.Move(target_turf)
		child.anchored = 1
		child.update_icon()

		//see if anything is there
		for(var/thing in child.loc)
			if(thing != child && istype(thing, /obj/effect/vine))
				var/obj/effect/vine/other = thing
				if(other.seed != child.seed)
					other.vine_overrun(child.seed, src) //vine fight
				qdel(child)
				return
			if(istype(thing, /obj/effect/dead_plant))
				qdel(thing)
				qdel(child)
				return
			if(isliving(thing) && (seed.get_trait(TRAIT_CARNIVOROUS) || (seed.get_trait(TRAIT_SPREAD) >= 2 && prob(round(seed.get_trait(TRAIT_POTENCY))))))
				entangle(thing)
				qdel(child)
				return

		// Update neighboring squares.
		for(var/obj/effect/vine/neighbor in range(1, child.loc)) //can use the actual final child loc now
			if(child.seed == neighbor.seed) //neighbors of different seeds will continue to try to overrun each other
				neighbor.neighbors -= target_turf

		child.finish_spreading()

/obj/effect/vine/proc/wake_neighbors()
	// This turf is clear now, let our buddies know.
	for(var/turf/simulated/check_turf in (get_cardinal_neighbors() | get_zlevel_neighbors()))
		if(!istype(check_turf))
			continue
		for(var/obj/effect/vine/neighbor in check_turf.contents)
			neighbor.neighbors |= check_turf
			START_PROCESSING(SSvines, neighbor)

/obj/effect/vine/proc/targets_in_range()
	var/mob/list/targets = list()
	for(var/turf/simulated/check_turf in (get_cardinal_neighbors() | get_zlevel_neighbors() | list(loc)))
		if(!istype(check_turf))
			continue
		for(var/mob/living/M in check_turf.contents)
			targets |= M
	if(targets.len)
		return targets

/obj/effect/vine/proc/die_off()
	// Kill off our plant.
	if(plant) plant.die()
	update_neighbors()
	wake_neighbors()
	spawn(1) if(src) qdel(src)

#undef NEIGHBOR_REFRESH_TIME