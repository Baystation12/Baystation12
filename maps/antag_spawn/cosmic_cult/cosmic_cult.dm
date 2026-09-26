/datum/map_template/ruin/antag_spawn/cosmic_cult
	name = "The Cosmic Dark"
	suffixes = list("cosmic_cult/the_cosmic_dark.dmm")
	skybox_background_for_zs = "void"
	skybox_stars_for_zs = "wisp"
	skybox_color_for_zs = COLOR_WHITE
	area_usage_test_exempted_areas = list(/area/cosmic_dark)

/datum/map_template/ruin/antag_spawn/cosmic_cult/after_load(z)
	..()
	var/ambient_group_index = SSambient_lighting.create_group("#42356c", 1.0)
	if (ambient_group_index < 0)
		return
	SSambient_lighting.z_group_indices["[z]"] = ambient_group_index
	var/datum/ambient_group/group = SSambient_lighting.groups[ambient_group_index]
	for (var/turf/T in block(locate(1, 1, z), locate(world.maxx, world.maxy, z)))
		if (TURF_IS_DYNAMICALLY_LIT_UNSAFE(T))
			group.add_turf(T)
