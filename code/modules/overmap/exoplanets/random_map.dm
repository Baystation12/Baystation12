/datum/random_map/noise/exoplanet
	descriptor = "exoplanet"
	smoothing_iterations = 1
	var/area/planetary_area = /area/exoplanet

	var/water_level
	var/water_level_min = 0
	var/water_level_max = 5
	var/land_type = /turf/simulated/floor
	var/water_type

	//intended x*y size, used to adjust spawn probs
	var/intended_x = 150
	var/intended_y = 150
	var/large_flora_prob = 60
	var/flora_prob = 60
	var/fauna_prob = 2
	var/flora_diversity = 4

	var/list/fauna_types = list()
	var/list/small_flora_types = list()
	var/list/big_flora_types = list()
	var/list/plantcolors = list("RANDOM")

/datum/random_map/noise/exoplanet/New(var/seed, var/tx, var/ty, var/tz, var/tlx, var/tly, var/do_not_apply, var/do_not_announce, var/never_be_priority = 0, var/_planetary_area)
	target_turf_type = world.turf
	water_level = rand(water_level_min,water_level_max)
	generate_flora()
	planetary_area = _planetary_area
	//automagically adjust probs for bigger maps to help with lag
	var/size_mod = intended_x / tlx * intended_y / tly
	flora_prob *= size_mod
	large_flora_prob *= size_mod
	fauna_prob *= size_mod

	..()

	GLOB.using_map.base_turf_by_z[num2text(tz)] = land_type

/datum/random_map/noise/exoplanet/proc/noise2value(var/value)
	return min(9,max(0,round((value/cell_range)*10)))
	
/datum/random_map/noise/exoplanet/proc/is_edge_turf(turf/T)
	return T.x <= TRANSITIONEDGE || T.x >= (limit_x - TRANSITIONEDGE + 1) || T.y <= TRANSITIONEDGE || T.y >= (limit_y - TRANSITIONEDGE + 1)

/datum/random_map/noise/exoplanet/get_map_char(var/value)
	if(water_type && noise2value(value) < water_level)
		return "~"
	return "[noise2value(value)]"

/datum/random_map/noise/exoplanet/get_appropriate_path(var/value)
	if(water_type && noise2value(value) < water_level)
		return water_type
	else
		return land_type

/datum/random_map/noise/exoplanet/get_additional_spawns(var/value, var/turf/T)
	if(is_edge_turf(T))
		return
	switch(noise2value(value))
		if(2 to 3)
			if(prob(flora_prob))
				spawn_flora(T)
			if(prob(fauna_prob))
				spawn_fauna(T)
		if(5 to 6)
			if(prob(flora_prob/3))
				spawn_flora(T)
		if(7 to 9)
			if(prob(flora_prob))
				spawn_flora(T)
			else if(prob(large_flora_prob))
				spawn_flora(T, 1)

/datum/random_map/noise/exoplanet/proc/spawn_fauna(var/turf/T)
	if(LAZYLEN(fauna_types))
		var/beastie = pick(fauna_types)
		new beastie(T)

/datum/random_map/noise/exoplanet/proc/generate_flora()
	for(var/i = 1 to flora_diversity)
		var/datum/seed/S = new()
		S.randomize()
		var/planticon = "alien[rand(1,4)]"
		S.set_trait(TRAIT_PRODUCT_ICON,planticon)
		S.set_trait(TRAIT_PLANT_ICON,planticon)
		var/color = pick(plantcolors)
		if(color == "RANDOM")
			color = get_random_colour(0,75,190)
		S.set_trait(TRAIT_PLANT_COLOUR,color)
		var/carnivore_prob = rand(100)
		if(carnivore_prob < 10)
			S.set_trait(TRAIT_CARNIVOROUS,2)
			S.set_trait(TRAIT_SPREAD,1)
		else if(carnivore_prob < 20)
			S.set_trait(TRAIT_CARNIVOROUS,1)
		small_flora_types += S
	if(large_flora_prob)
		var/tree_diversity = max(1,flora_diversity/2)
		for(var/i = 1 to tree_diversity)
			var/datum/seed/S = new()
			S.randomize()
			S.set_trait(TRAIT_PRODUCT_ICON,"alien[rand(1,5)]")
			S.set_trait(TRAIT_PLANT_ICON,"tree")
			S.set_trait(TRAIT_SPREAD,0)
			S.set_trait(TRAIT_HARVEST_REPEAT,1)
			S.set_trait(TRAIT_LARGE,1)
			var/color = pick(plantcolors)
			if(color == "RANDOM")
				color = get_random_colour(0,75,190)
			S.set_trait(TRAIT_LEAVES_COLOUR,color)
			S.chems[/datum/reagent/woodpulp] = 1
			big_flora_types += S

/datum/random_map/noise/exoplanet/proc/spawn_flora(var/turf/T, var/big)
	if(big)
		if(LAZYLEN(big_flora_types))
			new /obj/machinery/portable_atmospherics/hydroponics/soil/invisible(T, pick(big_flora_types), 1)
	else
		if(LAZYLEN(small_flora_types))
			new /obj/machinery/portable_atmospherics/hydroponics/soil/invisible(T, pick(small_flora_types), 1)
