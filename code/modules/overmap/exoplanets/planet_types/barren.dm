/obj/overmap/visitable/sector/exoplanet/barren
	name = "barren exoplanet"
	desc = "An exoplanet that couldn't hold its atmosphere."
	color = "#6c6c6c"
	planetary_area = /area/exoplanet/barren
	rock_colors = list(COLOR_BEIGE, COLOR_GRAY80, COLOR_BROWN)
	map_generators = list(/datum/random_map/noise/exoplanet/barren, /datum/random_map/noise/ore/rich)
	ruin_tags_blacklist = RUIN_HABITAT|RUIN_WATER
	features_budget = 6
	surface_color = "#807d7a"
	water_color = null
	habitability_weight = HABITABILITY_LOCKED
	has_trees = FALSE

/obj/overmap/visitable/sector/exoplanet/barren/generate_atmosphere()
	atmosphere = new

/obj/overmap/visitable/sector/exoplanet/barren/generate_flora()
	return

/datum/random_map/noise/exoplanet/barren
	descriptor = "barren exoplanet"
	smoothing_iterations = 4
	land_type = /turf/simulated/floor/exoplanet/barren
	flora_prob = 0.1
	large_flora_prob = 0
	fauna_prob = 0

/turf/simulated/floor/exoplanet/barren
	name = "ground"
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"

/turf/simulated/floor/exoplanet/barren/on_update_icon()
	ClearOverlays()
	if(prob(20))
		AddOverlays(image('icons/turf/flooring/decals.dmi', "asteroid[rand(0,9)]"))

/turf/simulated/floor/exoplanet/barren/Initialize()
	. = ..()
	update_icon()

/area/exoplanet/barren
	name = "\improper Planetary surface"
	ambience = list('sound/effects/wind/wind_2_1.ogg','sound/effects/wind/wind_2_2.ogg','sound/effects/wind/wind_3_1.ogg','sound/effects/wind/wind_4_1.ogg','sound/effects/wind/wind_4_2.ogg','sound/effects/wind/wind_5_1.ogg')
	base_turf = /turf/simulated/floor/exoplanet/barren
