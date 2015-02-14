/obj/effect/plant/process()

	// Something is very wrong, kill ourselves.
	if(!seed)
		die_off()

	// Handle life.
	var/turf/simulated/T = get_turf(src)
	if(istype(T))
		health -= seed.handle_environment(T, T.return_air(),1)
	if(health < max_health)
		health += rand(3,5)
		if(health > max_health)
			health = max_health
	refresh_icon()

	if(buckled_mob)
		seed.do_sting(buckled_mob,src)
		if(seed.get_trait(TRAIT_CARNIVOROUS))
			seed.do_thorns(buckled_mob,src)

	var/list/possible_locs = list()
	var/failed_turfs = 0

	for(var/turf/simulated/floor/floor in range(1))
		if((locate(/obj/effect/plant) in floor.contents) || (locate(/obj/effect/dead_plant) in floor.contents) || floor.density)
			failed_turfs++
		if(floor.Enter(src))
			possible_locs |= floor

	if(health == max_health && failed_turfs > 3 && !plant)
		plant = new(T,seed)
		plant.age = seed.get_trait(TRAIT_MATURATION)-1
		plant.update_icon()
		if(growth_type==0) //Vines do not become invisible.
			invisibility = INVISIBILITY_MAXIMUM
		else
			plant.layer = layer + 0.1

	if(possible_locs.len && prob(spread_chance))
		for(var/i=1,i<=seed.get_trait(TRAIT_YIELD),i++)
			if(!possible_locs.len)
				break
			if(prob(spread_into_adjacent))
				var/turf/target_turf = pick(possible_locs)
				possible_locs -= target_turf
				var/obj/effect/plant/child = new(target_turf, seed)
				child.parent = get_root()
				child.parent.children |= child

	if(buckled_mob || health != max_health || possible_locs.len)
		wake_up() // We still need to process!

/obj/effect/plant/proc/wake_up()
	if(plant_controller)
		plant_controller.add_plant(src)

/obj/effect/plant/proc/die_off(var/no_remains, var/no_del)
	// Remove ourselves from our parent.
	if(parent && parent.children)
		parent.children -= src
	// Kill off any of our children (and as an added bonus, other plants in this area)
	for(var/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/plant in get_turf(src))
		plant.dead = 1
		plant.update_icon()
	// Cause the plants around us to update.
	if(children && children.len)
		for(var/obj/effect/plant/child in children)
			child.die_off()
	for(var/obj/effect/plant/neighbor in view(1,src))
		neighbor.wake_up()

	if(!no_remains && !(locate(/obj/effect/dead_plant) in get_turf(src)))
		var/obj/effect/dead_plant/plant_remains = new(get_turf(src))
		plant_remains.icon = src.icon
		plant_remains.icon_state = src.icon_state
	if(!no_del)
		del(src)