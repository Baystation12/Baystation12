/obj/effect/overmap/sector/exoplanet/chlorine
	name = "chlorine exoplanet"
	desc = "An exoplanet with a chlorine based ecosystem. Large quantities of liquid chlorine are present."
	color = "#efff7c"
	possible_features = list(/datum/map_template/ruin/exoplanet/monolith,
							/datum/map_template/ruin/exoplanet/hydrobase,
							/datum/map_template/ruin/exoplanet/hut,
							/datum/map_template/ruin/exoplanet/crashed_pod,
							/datum/map_template/ruin/exoplanet/fountain,
							/datum/map_template/ruin/exoplanet/spider_nest,
							/datum/map_template/ruin/exoplanet/radshrine,
							/datum/map_template/ruin/exoplanet/deserted_lab)

/obj/effect/overmap/sector/exoplanet/chlorine/generate_map()
	if(prob(50))
		lightlevel = rand(7,10)/10 //It could be night.
	else
		lightlevel = 0.1
	for(var/zlevel in map_z)
		var/datum/random_map/noise/exoplanet/M = new /datum/random_map/noise/exoplanet/chlorine(md5(world.time + rand(-100,1000)),1,1,zlevel,maxx,maxy,0,1,1)
		get_biostuff(M)
		new /datum/random_map/noise/ore/poor(md5(world.time + rand(-100,1000)),1,1,zlevel,maxx,maxy,0,1,1)

/obj/effect/overmap/sector/exoplanet/chlorine/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.adjust_gas("chlorine", MOLES_O2STANDARD)
		atmosphere.temperature = T100C - rand(0, 100)
		atmosphere.update_values()

/datum/random_map/noise/exoplanet/chlorine
	descriptor = "chlorine exoplanet"
	smoothing_iterations = 3
	land_type = /turf/simulated/floor/exoplanet/chlorine_sand
	water_type = /turf/simulated/floor/exoplanet/water/shallow/chlorine_liquid
	water_level_min = 2
	water_level_max = 3
	planetary_area = /area/exoplanet/chlorine
	plantcolors = list("#eba487", "#ceeb87", "#eb879c", "#ebd687", "#f6d6c9", "#f2b3e0")
	fauna_prob = 2
	flora_prob = 30
	large_flora_prob = 10
	flora_diversity = 5
	fauna_types = list(/mob/living/simple_animal/thinbug, /mob/living/simple_animal/hostile/retaliate/beast/samak/alt, /mob/living/simple_animal/yithian, /mob/living/simple_animal/tindalos, /mob/living/simple_animal/hostile/retaliate/jelly)

/area/exoplanet/chlorine
	ambience = list('sound/effects/wind/desert0.ogg','sound/effects/wind/desert1.ogg','sound/effects/wind/desert2.ogg','sound/effects/wind/desert3.ogg','sound/effects/wind/desert4.ogg','sound/effects/wind/desert5.ogg')
	base_turf = /turf/simulated/floor/exoplanet/chlorine_sand

/turf/simulated/floor/exoplanet/water/shallow/chlorine_liquid
	name = "chlorine marsh"
	icon = 'icons/turf/chlorine.dmi'
	icon_state = "chlorine_liquid"
	desc = "A pool of noxious liquid chlorine. It's full of silt and plant matter."

/turf/simulated/floor/exoplanet/chlorine_sand
	name = "chlorinated sand"
	icon = 'icons/turf/chlorine.dmi'
	icon_state = "chlorine_sand1"
	desc = "Sand that has been heavily contaminated by chlorine."

/turf/simulated/floor/exoplanet/chlorine_sand/New()
	icon_state = pick("chlorine_sand[rand(1,12)]")
	..()