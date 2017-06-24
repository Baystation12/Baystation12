/obj/effect/overmap/sector/exoplanet/snow
	name = "Snow Exoplanet"
	desc = "Cold planet with limited plant life."

/obj/effect/overmap/sector/exoplanet/snow/generate_map()
	for(var/zlevel in map_z)
		var/datum/random_map/noise/exoplanet/M = new /datum/random_map/noise/exoplanet/snow(md5(world.time + rand(-100,1000)),1,1,zlevel,world.maxx,world.maxy)
		get_biostuff(M)

/obj/effect/overmap/sector/exoplanet/snow/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.temperature = T0C - rand(0, 50)
		atmosphere.update_values()
	
/datum/random_map/noise/exoplanet/snow
	descriptor = "snow exoplanet"
	smoothing_iterations = 1
	flora_prob = 30
	large_flora_prob = 20
	water_level = 3
	land_type = /turf/simulated/floor/snow
	water_type = /turf/simulated/floor/ice
	planetary_area = /area/exoplanet/snow
	fauna_types = list(/mob/living/simple_animal/hostile/samak, /mob/living/simple_animal/hostile/diyaab, /mob/living/simple_animal/hostile/shantak)
	plantcolors = list("#D0FEF5","#93E1D8","#93E1D8", "#B2ABBF", "#3590F3", "#4B4E6D")

/area/exoplanet/snow
	ambience = list('sound/effects/wind/tundra0.ogg','sound/effects/wind/tundra1.ogg','sound/effects/wind/tundra2.ogg','sound/effects/wind/spooky0.ogg','sound/effects/wind/spooky1.ogg')
	base_turf = /turf/simulated/floor/snow