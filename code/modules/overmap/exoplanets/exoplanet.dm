/obj/effect/overmap/sector/exoplanet
	name = "Exoplanet"
	var/list/seeds = list()
	var/list/animals = list()
	var/datum/gas_mixture/atmosphere
	in_space = 0

/obj/effect/overmap/sector/exoplanet/New()
	if(!using_map.use_overmap)
		qdel(src)
		return
	world.maxz++
	forceMove(locate(1,1,world.maxz))
	..()

/obj/effect/overmap/sector/exoplanet/initialize()
	..()
	air_processing_killed = TRUE
	generate_map()
	air_processing_killed = FALSE
	generate_landing()
	generate_atmosphere()
	update_biome()

/obj/effect/overmap/sector/exoplanet/proc/generate_map()

/obj/effect/overmap/sector/exoplanet/proc/get_biostuff(var/datum/random_map/noise/exoplanet/random_map)
	seeds += random_map.small_flora_types
	if(random_map.big_flora_types)
		seeds += random_map.big_flora_types
	for(var/mob/living/simple_animal/A in living_mob_list_)
		if(A.z in map_z)
			animals += A

/obj/effect/overmap/sector/exoplanet/proc/update_biome()
	var/list/mingas = list()
	for(var/gas in atmosphere.gas)
		mingas[gas] = round(0.4*atmosphere.gas[gas]) 
	var/list/badgases = gas_data.gases.Copy()
	badgases -= atmosphere.gas
	var/badgas = pick(badgases)

	for(var/datum/seed/S in seeds)
		S.set_trait(TRAIT_IDEAL_HEAT,          atmosphere.temperature + rand(-5,5),800,70)
		S.set_trait(TRAIT_HEAT_TOLERANCE,      S.get_trait(TRAIT_HEAT_TOLERANCE) + rand(-5,5),800,70)
		S.set_trait(TRAIT_LOWKPA_TOLERANCE,    atmosphere.return_pressure() + rand(-5,-50),80,0)
		S.set_trait(TRAIT_HIGHKPA_TOLERANCE,   atmosphere.return_pressure() + rand(5,50),500,110)
		if(S.exude_gasses)
			S.exude_gasses -= badgas
		if(atmosphere.get_gas("phoron"))
			S.set_trait(TRAIT_TOXINS_TOLERANCE, rand(7,15))

	for(var/mob/living/simple_animal/A in animals)
		A.minbodytemp = atmosphere.temperature - 20
		A.maxbodytemp = atmosphere.temperature + 30
		if(A.min_gas)
			A.min_gas = mingas.Copy()
		if(A.max_gas)
			A.max_gas = list()
			A.max_gas[badgas] = 5

/obj/effect/overmap/sector/exoplanet/proc/generate_landing()
	var/turf/T = locate(rand(20, world.maxx-20), rand(20, world.maxy - 10),map_z[map_z.len])
	if(T)
		var/obj/effect/shuttle_landmark/automatic/A = new(T)
		A.base_area = T.loc
	return T

/obj/effect/overmap/sector/exoplanet/proc/generate_atmosphere()
	atmosphere = new
	atmosphere.adjust_gas("oxygen", MOLES_O2STANDARD, 0)
	atmosphere.adjust_gas("nitrogen", MOLES_N2STANDARD)
	if(prob(90)) //let the fuckery commence
		var/list/oldgas = atmosphere.gas.Copy()
		var/list/newgases = gas_data.gases.Copy()
		if(prob(90)) //all phoron planet should be rare
			newgases -= "phoron"
		if(prob(20)) //alium gas should be slightly less common than mundane shit
			newgases -= "aliether"
		for(var/g in oldgas) //swapping gases wholesale. don't try at home
			var/ng = pick_n_take(newgases)
			if(ng in oldgas)
				atmosphere.gas[ng] += oldgas[g]
			else
				atmosphere.gas[ng] = oldgas[g]
			if(g != ng)
				atmosphere.gas -= g
	atmosphere.temperature = T20C + rand(-10, 10)
	var/factor = max(rand(60,140)/100, 0.6)
	atmosphere.multiply(factor)

/area/exoplanet
	name = "\improper Planetary surface"
	ambience = list('sound/effects/wind/wind_2_1.ogg','sound/effects/wind/wind_2_2.ogg','sound/effects/wind/wind_3_1.ogg','sound/effects/wind/wind_4_1.ogg','sound/effects/wind/wind_4_2.ogg','sound/effects/wind/wind_5_1.ogg')

//Random map itself

/datum/random_map/noise/exoplanet
	descriptor = "exoplanet"
	smoothing_iterations = 1
	var/area/planetary_area = /area/exoplanet

	var/water_level = 3
	var/land_type = /turf/simulated/floor
	var/water_type

	var/large_flora_prob = 60
	var/flora_prob = 60
	var/fauna_prob = 5
	var/fauna_diversity = 4

	var/list/fauna_types = list()
	var/list/small_flora_types = list()
	var/list/big_flora_types = list()
	var/list/plantcolors = list("RANDOM")

/datum/random_map/noise/exoplanet/New()
	target_turf_type = world.turf
	planetary_area = new planetary_area()
	water_level = rand(0,5)
	generate_flora()
	..()

/datum/random_map/noise/exoplanet/proc/noise2value(var/value)
    return min(9,max(0,round((value/cell_range)*10)))

/datum/random_map/noise/exoplanet/get_map_char(var/value)
	return "[noise2value(value)]"

/datum/random_map/noise/exoplanet/get_appropriate_path(var/value)
	if(water_type && noise2value(value) < water_level)
		return water_type
	else
		return land_type

/datum/random_map/noise/exoplanet/get_additional_spawns(var/value, var/turf/T)
	planetary_area.contents.Add(T)
	switch(noise2value(value))
		if(2 to 3)
			if(prob(flora_prob))
				spawn_flora(T)
			if(prob(fauna_prob))
				spawn_fauna(T)
		if(5 to 6)
			if(prob(flora_prob/3))
				spawn_flora(T)
		if(7 to 9)
			if(prob(flora_prob))
				spawn_flora(T)
			else if(prob(large_flora_prob))
				spawn_flora(T, 1)

/datum/random_map/noise/exoplanet/proc/spawn_fauna(var/turf/T)
    var/beastie = pick(fauna_types)
    new beastie(T)

/datum/random_map/noise/exoplanet/proc/generate_flora()
	for(var/i = 1 to fauna_diversity)
		var/datum/seed/S = new()
		S.randomize()
		S.set_trait(TRAIT_PRODUCT_ICON,pick("alien","alien-product","alien[rand(2,5)]","alien[rand(2,5)]-product"))
		S.set_trait(TRAIT_PLANT_ICON,pick("alien","alien[rand(2,4)]"))
		var/color = pick(plantcolors)
		if(color == "RANDOM")
			color = get_random_colour(0,75,190)
		S.set_trait(TRAIT_PLANT_COLOUR,color)
		var/carnivore_prob = rand(100)
		if(carnivore_prob < 10)
			S.set_trait(TRAIT_CARNIVOROUS,2)
			S.set_trait(TRAIT_SPREAD,1)
		else if(carnivore_prob < 20)
			S.set_trait(TRAIT_CARNIVOROUS,1)
		small_flora_types += S
	for(var/i = 1 to fauna_diversity)
		var/datum/seed/S = new()
		S.randomize()
		S.set_trait(TRAIT_PRODUCT_ICON,pick("alien","alien-product","alien[rand(2,5)]","alien[rand(2,5)]-product"))
		S.set_trait(TRAIT_PLANT_ICON,"tree5")
		S.set_trait(TRAIT_SPREAD,0)
		big_flora_types += S

/datum/random_map/noise/exoplanet/proc/spawn_flora(var/turf/T, var/big)
	if(big)
		new /obj/effect/plant(T, pick(big_flora_types), start_matured = 1)
	else
		new /obj/effect/plant(T, pick(small_flora_types), start_matured = 1)
