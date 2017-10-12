/obj/effect/overmap/sector/exoplanet/grass
	name = "lush exoplanet"
	desc = "Planet with abundant flora and fauna."
	color = "#538224"

/obj/effect/overmap/sector/exoplanet/grass/generate_map()
	if(prob(40))
		lightlevel = rand(1,7)/10	//give a chance of twilight jungle
	for(var/zlevel in map_z)
		var/datum/random_map/noise/exoplanet/M = new /datum/random_map/noise/exoplanet/grass(md5(world.time + rand(-100,1000)),1,1,zlevel,maxx,maxy,0,1,1)
		get_biostuff(M)

/obj/effect/overmap/sector/exoplanet/grass/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.temperature = T20C + rand(10, 30)
		atmosphere.update_values()

/obj/effect/overmap/sector/exoplanet/grass/adapt_seed(var/datum/seed/S)
	..()
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
	ambience = list('sound/effects/wind/wind_2_1.ogg','sound/effects/wind/wind_2_2.ogg','sound/effects/wind/wind_3_1.ogg','sound/effects/wind/wind_4_1.ogg','sound/ambience/eeriejungle2.ogg','sound/ambience/eeriejungle1.ogg')

/area/exoplanet/grass/play_ambience(var/mob/living/L)
	..()
	if(!L.ear_deaf && L.client && !L.client.ambience_playing)
		L.client.ambience_playing = 1
		L.playsound_local(get_turf(L),sound('sound/ambience/jungle.ogg', repeat = 1, wait = 0, volume = 25, channel = 2))

/datum/random_map/noise/exoplanet/grass
	descriptor = "grass exoplanet"
	smoothing_iterations = 2
	land_type = /turf/simulated/floor/exoplanet/grass
	water_type = /turf/simulated/floor/exoplanet/water/shallow
	planetary_area = /area/exoplanet/grass
	plantcolors = list("#0e1e14","#1a3e38","#5a7467","#9eab88","#6e7248", "RANDOM")

	flora_prob = 30
	large_flora_prob = 50
	flora_diversity = 6
	fauna_types = list(/mob/living/simple_animal/yithian, /mob/living/simple_animal/tindalos, /mob/living/simple_animal/hostile/jelly)

/datum/random_map/noise/exoplanet/grass/spawn_fauna(var/turf/T, value)
	if(prob(5))
		new/mob/living/simple_animal/hostile/giant_spider/nurse(T)
	else
		..()

/turf/simulated/floor/exoplanet/grass
	name = "grass"
	icon = 'icons/turf/jungle.dmi'
	icon_state = "grass2"
	mudpit = 1

/turf/simulated/floor/exoplanet/grass/Initialize()
	. = ..()
	if(!resources)
		resources = list()
	if(prob(70))
		resources["carbonaceous rock"] = rand(3,5)
	if(prob(5))
		resources["uranium"] = rand(1,3)
	if(prob(2))
		resources["diamond"] = 1

/turf/simulated/floor/exoplanet/grass/fire_act(datum/gas_mixture/air, temperature, volume)
	if((temperature > T0C + 200 && prob(5)) || temperature > T0C + 1000) 
		name = "scorched ground"
		icon_state = "scorched"