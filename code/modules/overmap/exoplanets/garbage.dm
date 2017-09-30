/obj/effect/overmap/sector/exoplanet/garbage
	name = "settled exoplanet"
	desc = "An arid exoplanet with artificial structures detected on the surface."

/obj/effect/overmap/sector/exoplanet/garbage/generate_map()
	if(prob(50))
		lightlevel = rand(5,10)/10	//deserts are usually :lit:
	for(var/zlevel in map_z)
		var/datum/random_map/noise/exoplanet/M = new /datum/random_map/noise/exoplanet/garbage(md5(world.time + rand(-100,1000)),1,1,zlevel,maxx,maxy,0,1,1)
		get_biostuff(M)
		new /datum/random_map/noise/ore/poor(md5(world.time + rand(-100,1000)),1,1,zlevel,maxx,maxy,0,1,1)

/obj/effect/overmap/sector/exoplanet/garbage/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.temperature = T20C + rand(20, 100)
		atmosphere.update_values()

/obj/effect/overmap/sector/exoplanet/garbage/update_biome()
	..()
	for(var/datum/seed/S in seeds)
		if(prob(90))
			S.set_trait(TRAIT_REQUIRES_WATER,0)
		else
			S.set_trait(TRAIT_REQUIRES_WATER,1)
			S.set_trait(TRAIT_WATER_CONSUMPTION,1)
		if(prob(40))
			S.set_trait(TRAIT_STINGS,1)

/obj/effect/overmap/sector/exoplanet/garbage/adapt_animal(var/mob/living/simple_animal/A)
	..()
	A.faction = "Guardian" //stops bots form hitting each other

/datum/random_map/noise/exoplanet/garbage
	descriptor = "garbage exoplanet"
	smoothing_iterations = 4
	land_type = /turf/simulated/floor/exoplanet/desert
	planetary_area = /area/exoplanet/garbage
	plantcolors = list("#efdd6f","#7b4a12","#e49135","#ba6222","#5c755e","#120309")

	flora_prob = 1
	large_flora_prob = 0
	flora_diversity = 2
	fauna_types = list(/mob/living/simple_animal/hostile/hivebot, /mob/living/simple_animal/hostile/hivebot/range, /mob/living/simple_animal/hostile/viscerator)
	fauna_prob = 1

/datum/random_map/noise/exoplanet/garbage/get_additional_spawns(var/value, var/turf/T)
	..()
	var/v = noise2value(value)
	if(v > 5)
		new/obj/structure/rubble/house(T)
	else
		if(prob(2))
			new/obj/structure/rubble/war(T)
		if(prob(0.02))
			var/datum/artifact_find/A = new()
			new A.artifact_find_type(T)
			qdel(A)

/datum/random_map/noise/exoplanet/garbage/get_appropriate_path(var/value)
	var/v = noise2value(value)
	if(v > 6)
		return /turf/simulated/floor/exoplanet/concrete
	return land_type

/area/exoplanet/garbage
	ambience = list('sound/effects/wind/desert0.ogg','sound/effects/wind/desert1.ogg','sound/effects/wind/desert2.ogg','sound/effects/wind/desert3.ogg','sound/effects/wind/desert4.ogg','sound/effects/wind/desert5.ogg')
	base_turf = /turf/simulated/floor/exoplanet/desert

/turf/simulated/floor/exoplanet/concrete
	name = "concrete"
	desc = "Stone-like artificial material."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "concrete"