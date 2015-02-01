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

	// Damaged, young hibernating or too far from parent, no chance of spreading.
	if(is_mature() || hibernating || (parent && (get_dist_to_parent(0) > spread_distance)))
		return

	// Count our neighbors and possible locations for spreading.
	var/list/possible_locs = list()
	var/count = 0
	for(var/turf/simulated/floor/floor in view(1,src))
		if((locate(/obj/effect/dead_plant) in floor.contents) || !floor.Enter(src) || floor.density)
			continue
		if(locate(/obj/effect/plant) in floor.contents)
			count++
			continue
		possible_locs |= floor

	//Entirely surrounded, try to spawn an actual plant.
	if(count>=8)
		if(!(locate(/obj/machinery/portable_atmospherics/hydroponics/soil/invisible) in T.contents))
			var/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/new_plant = new(T,seed)
			new_plant.age = seed.get_trait(TRAIT_MATURATION)-1
			new_plant.update_icon()
			if(growth_type==0) //Vines do not become invisible.
				invisibility = INVISIBILITY_MAXIMUM
			else
				new_plant.layer = 4.1

	if(prob(spread_chance))
		for(var/i=1,i<=seed.get_trait(TRAIT_YIELD),i++)
			if(!possible_locs.len)
				hibernating = 1
				world << "[src] at [x],[y] is hibernating"
				break
			if(prob(spread_into_adjacent))
				var/turf/target_turf = pick(possible_locs)
				possible_locs -= target_turf
				var/obj/effect/plant/child = new(target_turf, seed)
				child.parent = get_root()
				child.parent.children |= child

/obj/effect/plant/proc/die_off(var/no_remains, var/no_del)
	// Remove ourselves from our parent.
	if(parent && parent.children)
		parent.children -= src
	// Kill off any of our children (and add an added bonus, other plants in this area)
	for(var/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/plant in get_turf(src))
		plant.dead = 1
		plant.update_icon()
	// Cause the plants around us to update.
	if(children && children.len)
		for(var/obj/effect/plant/child in children)
			child.die_off()
	for(var/obj/effect/plant/neighbor in view(1,src))
		neighbor.hibernating = 0
	if(!no_remains && !(locate(/obj/effect/dead_plant) in get_turf(src)))
		var/obj/effect/dead_plant/plant_remains = new(get_turf(src))
		plant_remains.icon = src.icon
		plant_remains.icon_state = src.icon_state
	if(!no_del)
		del(src)