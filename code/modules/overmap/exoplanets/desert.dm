/obj/effect/overmap/sector/exoplanet/desert
	name = "Desert Exoplanet"
	desc = "An arid exoplanet with sparse biological resources but rich mineral deposits underground."

/obj/effect/overmap/sector/exoplanet/desert/generate_map()
	for(var/zlevel in map_z)
		var/datum/random_map/noise/exoplanet/M = new /datum/random_map/noise/exoplanet/desert(md5(world.time + rand(-100,1000)),1,1,zlevel,world.maxx,world.maxy)
		get_biostuff(M)
		new /datum/random_map/noise/ore/rich(md5(world.time + rand(-100,1000)),1,1,zlevel)

/obj/effect/overmap/sector/exoplanet/desert/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.temperature = T20C + rand(10, 50)
		atmosphere.update_values()

/obj/effect/overmap/sector/exoplanet/desert/update_biome()
	..()
	for(var/datum/seed/S in seeds)
		if(prob(90))
			S.set_trait(TRAIT_REQUIRES_WATER,0)
		else
			S.set_trait(TRAIT_REQUIRES_WATER,1)
			S.set_trait(TRAIT_WATER_CONSUMPTION,1)
		if(prob(15))
			S.set_trait(TRAIT_STINGS,1)

/datum/random_map/noise/exoplanet/desert
	descriptor = "desert exoplanet"
	smoothing_iterations = 4
	land_type = /turf/simulated/floor/beach/sand/desert
	planetary_area = /area/exoplanet/desert
	plantcolors = list("#EFDD6F","#7B4A12","#E49135","#BA6222","#5C755E","#120309")

	flora_prob = 10
	large_flora_prob = 0
	fauna_diversity = 4
	fauna_types = list(/mob/living/simple_animal/yithian, /mob/living/simple_animal/tindalos)

/datum/random_map/noise/exoplanet/desert/get_additional_spawns(var/value, var/turf/T)
	..()
	var/v = noise2value(value)
	if(v > 6)
		T.icon_state = "desert[v-1]"

/datum/random_map/noise/ore/rich
	deep_val = 0.7
	rare_val = 0.5

/area/exoplanet/desert
	ambience = list('sound/effects/wind/desert0.ogg','sound/effects/wind/desert1.ogg','sound/effects/wind/desert2.ogg','sound/effects/wind/desert3.ogg','sound/effects/wind/desert4.ogg','sound/effects/wind/desert5.ogg')
	base_turf = /turf/simulated/floor/beach/sand/desert