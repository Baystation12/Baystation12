/mob/living/chorus
	var/datum/chorus_building/selected_building = null //What we are currently selecting for building
	var/datum/chorus_building/delete/deletion = new()
	var/list/currently_building = list()
	var/list/buildings = list()
	var/construct_speed = 1 //Split up between all constructs
	var/construct_limit // Maximum number of active builds
	var/last_build_warning // world.time of last build warning
	var/build_warning_interval = 30 SECONDS // Time interval of build warnings

/mob/living/chorus/proc/add_building(var/obj/structure/building)
	if(!istype(building))
		return
	buildings |= building
	update_buildings_followers()
	if(istype(building, /obj/structure/chorus))
		var/obj/structure/chorus/C = building
		if(!C.gives_sight)
			return
	chorus_net.add_source(building)

/mob/living/chorus/proc/remove_building(var/obj/structure/building)
	buildings -= building
	chorus_net.remove_source(building)
	update_buildings_followers()

/mob/living/chorus/proc/start_building(var/datum/chorus_building/blueprint, var/atom/target)
	if(blueprint == deletion)
		return

	else if (!construct_limit_check())
		to_chat(usr, SPAN_WARNING("You already have too many in progress constructions. Build more nerve clusters to increase this limit, or cancel an in progress build first."))
		return

	var/bp = blueprint.build(target, src, TRUE)
	if(bp)
		currently_building += bp

/mob/living/chorus/proc/stop_building(var/obj/structure/chorus_blueprint/cb, var/delete_it = TRUE)
	currently_building -= cb
	cb.stop_building(delete_it)

/mob/living/chorus/proc/get_buildings_by_tier()
	return form.get_buildings_by_tier()


/mob/living/chorus/proc/calculate_real_construct_speed(construct_count = null)
	if (construct_count == null)
		construct_count = currently_building.len
	var/real_construct_speed = 25 * construct_speed / (24 + construct_speed)
	if (construct_count)
		real_construct_speed = real_construct_speed / construct_count
	return real_construct_speed


/mob/living/chorus/proc/construct_limit_check(add_one = TRUE)
	var/construct_count = currently_building.len
	if (add_one)
		construct_count++
	return calculate_real_construct_speed(construct_count) >= 1 ? TRUE : FALSE


/mob/living/chorus/Life()
	. = ..()
	if(.)
		if(currently_building.len)
			for(var/b in currently_building)
				var/obj/structure/chorus_blueprint/cb = b
				if (!cb || !istype(cb)) // Null value protection
					stop_building(cb)
					if (!currently_building.len) // Divide by 0 protection
						break
					continue
				var/con_speed = calculate_real_construct_speed()
				if(cb.build_amount(con_speed))
					currently_building -= cb

			if (world.time > last_build_warning + build_warning_interval && !construct_limit_check(FALSE))
				to_chat(src, SPAN_WARNING("The number of in progress organ builds exceeds your current limit of ongoing build(s). This will negatively impact build speed and may result in infinite build times. Deleting excess in-progress builds is recommended."))
				last_build_warning = world.time
		else if(health < maxHealth) //Not building? Heal ourselves
			health = min(maxHealth, health + construct_speed)

/mob/living/chorus/Destroy()
	QDEL_NULL_LIST(buildings)
	QDEL_NULL_LIST(currently_building)
	. = ..()

/mob/living/chorus/proc/set_selected_building(var/n_build)
	selected_building = n_build
	var/datum/hud/chorus/C = hud_used
	C.update_selected(n_build)

/mob/living/chorus/proc/get_dist_to_nearest_building(var/atom/A)
	var/atom/a = get_atom_closest_to_atom(A, buildings + src)
	if(a)
		. = get_dist(A, a)

/mob/living/chorus/proc/get_building_type_amount(var/type)
	. = 0
	for(var/b in buildings)
		if(istype(b, type))
			.++

/mob/living/chorus/proc/update_buildings_followers()
	var/datum/hud/chorus/C = hud_used
	C.update_followers_buildings(followers.len, buildings.len)

/mob/living/chorus/proc/start_delete()
	set_selected_building(deletion)
