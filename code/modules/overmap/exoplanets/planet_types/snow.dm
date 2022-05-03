/obj/effect/overmap/visitable/sector/exoplanet/snow
	name = "snow exoplanet"
	desc = "Cold planet with limited plant life."
	color = "#dcdcdc"
	planetary_area = /area/exoplanet/snow
	rock_colors = list(COLOR_DARK_BLUE_GRAY, COLOR_GUNMETAL, COLOR_GRAY80, COLOR_DARK_GRAY)
	plant_colors = list("#d0fef5","#93e1d8","#93e1d8", "#b2abbf", "#3590f3", "#4b4e6d")
	map_generators = list(/datum/random_map/noise/exoplanet/snow, /datum/random_map/noise/ore/poor)
	surface_color = "#e8faff"
	water_color = "#b5dfeb"
	habitability_distribution = list(HABITABILITY_IDEAL = 30, HABITABILITY_OKAY = 50, HABITABILITY_BAD = 10)
	has_trees = TRUE
	flora_diversity = 4
	fauna_types = list(/mob/living/simple_animal/hostile/retaliate/beast/samak, /mob/living/simple_animal/hostile/retaliate/beast/diyaab, /mob/living/simple_animal/hostile/retaliate/beast/shantak)
	megafauna_types = list(/mob/living/simple_animal/hostile/retaliate/giant_crab)

/obj/effect/overmap/visitable/sector/exoplanet/snow/generate_atmosphere()
	..()
	if(atmosphere)
		var/limit = 0
		if(habitability_class <= HABITABILITY_OKAY)
			var/datum/species/human/H = /datum/species/human
			limit = initial(H.cold_level_1) + rand(1,10)
		atmosphere.temperature = max(T0C - rand(10, 100), limit)
		atmosphere.update_values()

/datum/random_map/noise/exoplanet/snow
	descriptor = "snow exoplanet"
	smoothing_iterations = 1
	flora_prob = 5
	large_flora_prob = 10
	water_level_max = 3
	land_type = /turf/simulated/floor/exoplanet/snow
	water_type = /turf/simulated/floor/exoplanet/ice

/area/exoplanet/snow
	ambience = list('sound/effects/wind/tundra0.ogg','sound/effects/wind/tundra1.ogg','sound/effects/wind/tundra2.ogg','sound/effects/wind/spooky0.ogg','sound/effects/wind/spooky1.ogg')
	base_turf = /turf/simulated/floor/exoplanet/snow
