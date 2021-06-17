GLOBAL_LIST_EMPTY(banned_ruin_ids)

/proc/seedRuins(list/zlevels, budget, list/potentialRuins, allowed_area = /area/space, var/maxx = world.maxx, var/maxy = world.maxy)
	if (!length(z_levels))
		UNLINT(WARNING("No Z levels provided - Not generating ruins"))
		return

	for (var/z in zlevels)
		var/turf/check = locate(1, 1, z)
		if (!check)
			UNLINT(WARNING("Z level [z] does not exist - Not generating ruins"))
			return

	var/list/available = list()
	var/list/selected = list()
	var/remaining = budget

	for(var/datum/map_template/ruin/ruin in potentialRuins)
		if (ruin.id in GLOB.banned_ruin_ids)
			continue
		available[ruin] = ruin.spawn_weight

	if (!length(available))
		UNLINT(WARNING("No ruins available - Not generating ruins"))

	while (remaining > 0 && length(available))
		var/datum/map_template/ruin/ruin = pickweight(available)
		if (ruin.spawn_cost > remaining)
			available -= ruin
			continue

		var/width = TRANSITIONEDGE + RUIN_MAP_EDGE_PAD + round(ruin.width / 2)
		var/height = TRANSITIONEDGE + RUIN_MAP_EDGE_PAD + round(ruin.height / 2)
		if (width > maxx - width || height > maxy - height)
			available -= ruin
			continue

		for (var/attempts = 20, attempts > 0, --attempts)
			var/z = pick(zlevels)
			var/turf/choice = locate(rand(width, maxx - width), rand(height, maxy - height), z)

			var/valid = TRUE
			for (var/turf/check in ruin.get_affected_turfs(choice, 1))
				var/area/check_area = get_area(check)
				if (!istype(check_area, allowed_area) || check.turf_flags & TURF_FLAG_NORUINS)
					if (attempts == 1)
						available -= ruin
					valid = FALSE
					break
			if (!valid)
				continue

			log_world("Ruin \"[ruin.name]\" placed at ([choice.x], [choice.y], [choice.z])")

			load_ruin(choice, ruin)
			selected += ruin
			if (ruin.spawn_cost > 0)
				remaining -= ruin.spawn_cost
			if (!(ruin.template_flags & TEMPLATE_FLAG_ALLOW_DUPLICATES))
				GLOB.banned_ruin_ids += ruin.id
				available -= ruin
			break

	if (remaining)
		log_world("Ruin loader had no ruins to pick from with [budget] left to spend.")

	if (length(selected))
		report_progress("Finished selecting planet ruins ([english_list(selected)]) for [budget - remaining] cost of [budget] budget.")

	return selected

/proc/load_ruin(turf/central_turf, datum/map_template/template)
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
	return TRUE
