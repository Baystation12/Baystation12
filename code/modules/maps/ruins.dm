GLOBAL_LIST_EMPTY(banned_ruin_ids)

/proc/seedRuins(list/z_levels = null, budget = 0, whitelist = /area/space, list/potentialRuins, var/maxx = world.maxx, var/maxy = world.maxy)
	if(!z_levels || !z_levels.len)
		WARNING("No Z levels provided - Not generating ruins")
		return

	for(var/zl in z_levels)
		var/turf/T = locate(1, 1, zl)
		if(!T)
			WARNING("Z level [zl] does not exist - Not generating ruins")
			return

	var/list/ruins = potentialRuins.Copy()
	for(var/R in potentialRuins)
		var/datum/map_template/ruin/ruin = R
		if(ruin.id in GLOB.banned_ruin_ids)
			ruins -= ruin //remove all prohibited ids from the candidate list; used to forbit global duplicates.

//Each iteration needs to either place a ruin or strictly decrease either the budget or ruins.len (or break).
	while(budget > 0)
		// Pick a ruin
		var/datum/map_template/ruin/ruin = null
		if(ruins && ruins.len)
			ruin = pick(ruins)
			if(ruin.cost > budget)
				ruins -= ruin
				continue //Too expensive, get rid of it and try again
		else
			log_world("Ruin loader had no ruins to pick from with [budget] left to spend.")
			break
		// Try to place it
		var/sanity = 20
		// And if we can't fit it anywhere, give up, try again

		while(sanity > 0)
			sanity--

			var/width_border = TRANSITIONEDGE + RUIN_MAP_EDGE_PAD + round(ruin.width / 2)
			var/height_border = TRANSITIONEDGE + RUIN_MAP_EDGE_PAD + round(ruin.height / 2)
			var/z_level = pick(z_levels)
			if(width_border > maxx - width_border || height_border > maxx - height_border) // Too big and will never fit.
				ruins -= ruin //So let's not even try anymore with this one.
				break

			var/turf/T = locate(rand(width_border, maxx - width_border), rand(height_border, maxy - height_border), z_level)
			var/valid = TRUE

			for(var/turf/check in ruin.get_affected_turfs(T,1))
				var/area/new_area = get_area(check)
				if(!(istype(new_area, whitelist)) || check.turf_flags & TURF_FLAG_NORUINS)
					if(sanity == 0)
						ruins -= ruin //It didn't fit, and we are out of sanity. Let's make sure not to keep trying the same one.
					valid = FALSE
					break //Let's try again

			if(!valid)
				continue
			log_world("Ruin \"[ruin.name]\" placed at ([T.x], [T.y], [T.z])")

			load_ruin(T, ruin)
			if(ruin.cost >= 0)
				budget -= ruin.cost
			if(!(ruin.template_flags & TEMPLATE_FLAG_ALLOW_DUPLICATES))
				for(var/other_ruin_datum in ruins)
					var/datum/map_template/ruin/other_ruin = other_ruin_datum
					if(ruin.id == other_ruin.id)
						ruins -= ruin //Remove all ruins with the same id if we don't allow duplicates
				GLOB.banned_ruin_ids += ruin.id //and ban them globally too
			break

proc/load_ruin(turf/central_turf, datum/map_template/template)
	if(!template)
		return FALSE
	for(var/i in template.get_affected_turfs(central_turf, 1))
		var/turf/T = i
		for(var/mob/living/simple_animal/monster in T)
			qdel(monster)
	template.load(central_turf,centered = TRUE)
	var/datum/map_template/ruin = template
	if(istype(ruin))
		new /obj/effect/landmark/ruin(central_turf, ruin)

	if(template.template_flags & TEMPLATE_FLAG_NO_RUINS)
		for(var/i in template.get_affected_turfs(central_turf, 1))
			var/turf/T = i
			T.turf_flags |= TURF_FLAG_NORUINS

	return TRUE
