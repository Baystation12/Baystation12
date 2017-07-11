/obj/effect/overmap/sector/exoplanet/grass
	name = "Lush Exoplanet"
	desc = "Planet with abnundant flora and fauna."

/obj/effect/overmap/sector/exoplanet/grass/generate_map()
	for(var/zlevel in map_z)
		var/datum/random_map/noise/exoplanet/M = new /datum/random_map/noise/exoplanet/grass(md5(world.time + rand(-100,1000)),1,1,zlevel,world.maxx,world.maxy)
		get_biostuff(M)
	
/obj/effect/overmap/sector/exoplanet/grass/update_biome()
	..()
	for(var/datum/seed/S in seeds)
		var/carnivore_prob = rand(100)
		if(carnivore_prob < 15)
			S.set_trait(TRAIT_CARNIVOROUS,2)
		else if(carnivore_prob < 30)
			S.set_trait(TRAIT_CARNIVOROUS,1)
		if(prob(15) || (S.get_trait(TRAIT_CARNIVOROUS) && prob(40)))
			S.set_trait(TRAIT_BIOLUM,1)
			S.set_trait(TRAIT_BIOLUM_COLOUR,get_random_colour(0,75,190))

		if(prob(30))
			S.set_trait(TRAIT_PARASITE,1)
		var/vine_prob = rand(100)
		if(vine_prob < 15)
			S.set_trait(TRAIT_SPREAD,2)
		else if(vine_prob < 30)
			S.set_trait(TRAIT_SPREAD,1)

/area/exoplanet/grass
	base_turf = /turf/simulated/floor/exoplanet/grass

/datum/random_map/noise/exoplanet/grass
	descriptor = "grass exoplanet"
	smoothing_iterations = 2
	land_type = /turf/simulated/floor/exoplanet/grass
	water_type = /turf/simulated/floor/exoplanet/water/shallow
	planetary_area = /area/exoplanet/grass
	plantcolors = list("#0E1E14","#1A3E38","#5A7467","#9EAB88","#6E7248", "RANDOM")

	flora_prob = 30
	large_flora_prob = 50
	fauna_diversity = 6
	fauna_types = list(/mob/living/simple_animal/yithian, /mob/living/simple_animal/tindalos, /mob/living/simple_animal/hostile/jelly)

/datum/random_map/noise/exoplanet/grass/spawn_fauna(var/turf/T, value)
	if(prob(5))
		new/mob/living/simple_animal/hostile/giant_spider/nurse(T)
	else
		..()

/turf/simulated/floor/exoplanet/grass
	name = "grass"
	icon = 'icons/misc/beach.dmi'
	icon_state = "dgrass0"

/turf/simulated/floor/exoplanet/grass/New()
	icon_state = "dgrass[rand(0,4)]"
	..()