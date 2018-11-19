/obj/effect/overmap/sector/exoplanet/shrouded
	name = "shrouded exoplanet"
	desc = "An exoplanet shrouded in a perpetual storm of bizzare, light absorbing particles."
	color = "#3e3960"
	possible_features = list(/datum/map_template/ruin/exoplanet/monolith,
							/datum/map_template/ruin/exoplanet/hydrobase,
							/datum/map_template/ruin/exoplanet/tar_anomaly,
							/datum/map_template/ruin/exoplanet/hut,
							/datum/map_template/ruin/exoplanet/drill_site,
							/datum/map_template/ruin/exoplanet/crashed_pod,
							/datum/map_template/ruin/exoplanet/radshrine,
							/datum/map_template/ruin/exoplanet/spider_nest,
							/datum/map_template/ruin/exoplanet/deserted_lab)

/obj/effect/overmap/sector/exoplanet/shrouded/generate_map()
	for(var/zlevel in map_z)
		var/datum/random_map/noise/exoplanet/M = new /datum/random_map/noise/exoplanet/shrouded(md5(world.time + rand(-100,1000)),1,1,zlevel,maxx,maxy,0,1,1)
		get_biostuff(M)
		new /datum/random_map/noise/ore/poor(md5(world.time + rand(-100,1000)),1,1,zlevel,maxx,maxy,0,1,1)

/obj/effect/overmap/sector/exoplanet/shrouded/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.temperature = T20C - rand(10, 20)
		atmosphere.update_values()

/datum/random_map/noise/exoplanet/shrouded
	descriptor = "shrouded exoplanet"
	smoothing_iterations = 2
	flora_prob = 10
	large_flora_prob = 20
	flora_diversity = 3
	water_level_max = 3
	water_level_min = 1
	land_type = /turf/simulated/floor/exoplanet/shrouded
	water_type = /turf/simulated/floor/exoplanet/water/shallow/tar
	planetary_area = /area/exoplanet/shrouded
	fauna_types = list(/mob/living/simple_animal/hostile/retaliate/royalcrab, /mob/living/simple_animal/hostile/retaliate/jelly/alt, /mob/living/simple_animal/hostile/retaliate/beast/shantak/alt, /mob/living/simple_animal/hostile/giant_spider/hunter)
	plantcolors = list("3c5434", "2f6655", "0e703f", "495139", "394c66", "1a3b77", "3e3166", "52457c", "402d56", "580d6d")

/area/exoplanet/shrouded
	forced_ambience = list("sound/ambience/spookyspace1.ogg", "sound/ambience/spookyspace2.ogg")
	base_turf = /turf/simulated/floor/exoplanet/shrouded

/turf/simulated/floor/exoplanet/water/shallow/tar
	name = "tar"
	icon = 'icons/turf/shrouded.dmi'
	icon_state = "shrouded_tar"
	desc = "A pool of viscous and sticky tar."
	movement_delay = 12

/turf/simulated/floor/exoplanet/water/shallow/tar/get_footstep_sound()
	return safepick(footstep_sounds[FOOTSTEP_WATER])


/turf/simulated/floor/exoplanet/shrouded
	name = "packed sand"
	icon = 'icons/turf/shrouded.dmi'
	icon_state = "shrouded"
	desc = "Sand that has been packed in to solid earth."

/turf/simulated/floor/exoplanet/shrouded/New()
	icon_state = pick("shrouded[rand(0,7)]")
	..()