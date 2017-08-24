/obj/effect/overmap/sector/exoplanet/snow
	name = "snow exoplanet"
	desc = "Cold planet with limited plant life."

/obj/effect/overmap/sector/exoplanet/snow/generate_map()
	for(var/zlevel in map_z)
		var/datum/random_map/noise/exoplanet/M = new /datum/random_map/noise/exoplanet/snow(md5(world.time + rand(-100,1000)),1,1,zlevel,maxx,maxy,0,1,1)
		get_biostuff(M)
		new /datum/random_map/noise/ore/poor(md5(world.time + rand(-100,1000)),1,1,zlevel,maxx,maxy,0,1,1)

/obj/effect/overmap/sector/exoplanet/snow/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.temperature = T0C - rand(10, 100)
		atmosphere.update_values()

/datum/random_map/noise/exoplanet/snow
	descriptor = "snow exoplanet"
	smoothing_iterations = 1
	flora_prob = 30
	large_flora_prob = 20
	water_level_max = 3
	land_type = /turf/simulated/floor/exoplanet/snow
	water_type = /turf/simulated/floor/exoplanet/ice
	planetary_area = /area/exoplanet/snow
	fauna_types = list(/mob/living/simple_animal/hostile/samak, /mob/living/simple_animal/hostile/diyaab, /mob/living/simple_animal/hostile/shantak)
	plantcolors = list("#D0FEF5","#93E1D8","#93E1D8", "#B2ABBF", "#3590F3", "#4B4E6D")

/area/exoplanet/snow
	ambience = list('sound/effects/wind/tundra0.ogg','sound/effects/wind/tundra1.ogg','sound/effects/wind/tundra2.ogg','sound/effects/wind/spooky0.ogg','sound/effects/wind/spooky1.ogg')
	base_turf = /turf/simulated/floor/exoplanet/snow/

/datum/random_map/noise/ore/poor
	deep_val = 0.8
	rare_val = 0.9

/turf/simulated/floor/exoplanet/ice
	name = "ice"
	icon = 'icons/turf/snow.dmi'
	icon_state = "ice"

/turf/simulated/floor/exoplanet/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"

/turf/simulated/floor/exoplanet/snow/New()
	icon_state = pick("snow[rand(1,12)]","snow0")
	..()