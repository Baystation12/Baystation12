/obj/effect/overmap/sector/exoplanet
	name = "exoplanet"
	var/list/seeds = list()
	var/list/animals = list()
	var/datum/gas_mixture/atmosphere
	var/lightlevel
	in_space = 0
	var/maxx
	var/maxy
	var/landmark_type = /obj/effect/shuttle_landmark/automatic


/obj/effect/overmap/sector/exoplanet/New()
	if(!GLOB.using_map.use_overmap)
		qdel(src)
		return

	maxx = world.maxx
	maxy = world.maxy

	name = "[generate_planet_name()], \a [name]"

	world.maxz++
	forceMove(locate(1,1,world.maxz))
	map_z = GetConnectedZlevels(z)
	for(var/zlevel in map_z)
		map_sectors["[zlevel]"] = src

	..()

/obj/effect/overmap/sector/exoplanet/proc/build_level()
	spawn()
		generate_atmosphere()
		generate_map()
		generate_landing()
		update_biome()

/obj/effect/overmap/sector/exoplanet/proc/generate_map()

/obj/effect/overmap/sector/exoplanet/proc/get_biostuff(var/datum/random_map/noise/exoplanet/random_map)
	seeds += random_map.small_flora_types
	if(random_map.big_flora_types)
		seeds += random_map.big_flora_types
	for(var/mob/living/simple_animal/A in GLOB.living_mob_list_)
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
		if(S.consume_gasses)
			S.consume_gasses = list(pick(atmosphere.gas)) // ensure that if the plant consumes a gas, the atmosphere will have it
		if(atmosphere.get_gas("phoron"))
			S.set_trait(TRAIT_TOXINS_TOLERANCE, rand(7,15))

	for(var/mob/living/simple_animal/A in animals)
		A.minbodytemp = atmosphere.temperature - 20
		A.maxbodytemp = atmosphere.temperature + 30
		A.bodytemperature = (A.maxbodytemp+A.minbodytemp)/2
		if(A.min_gas)
			A.min_gas = mingas.Copy()
		if(A.max_gas)
			A.max_gas = list()
			A.max_gas[badgas] = 5

/obj/effect/overmap/sector/exoplanet/proc/generate_landing()
	var/turf/T = locate(rand(20, maxx-20), rand(20, maxy - 10),map_z[map_z.len])
	if(T)
		var/obj/effect/shuttle_landmark/automatic/A = new landmark_type(T)
		A.base_area = T.loc
	return T

/obj/effect/overmap/sector/exoplanet/proc/generate_atmosphere()
	atmosphere = new
	atmosphere.adjust_gas("oxygen", MOLES_O2STANDARD, 0)
	atmosphere.adjust_gas("nitrogen", MOLES_N2STANDARD)
	if(prob(80)) //let the fuckery commence
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

	var/water_level
	var/water_level_min = 0
	var/water_level_max = 5
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
	water_level = rand(water_level_min,water_level_max)
	generate_flora()
	..()

/datum/random_map/noise/exoplanet/proc/noise2value(var/value)
    return min(9,max(0,round((value/cell_range)*10)))

/datum/random_map/noise/exoplanet/get_map_char(var/value)
	if(water_type && noise2value(value) < water_level)
		return "~"
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
		S.set_trait(TRAIT_HARVEST_REPEAT,1)
		big_flora_types += S

/datum/random_map/noise/exoplanet/proc/spawn_flora(var/turf/T, var/big)
	if(big)
		new /obj/effect/plant(T, pick(big_flora_types), start_matured = 1)
	else
		new /obj/effect/plant(T, pick(small_flora_types), start_matured = 1)

/turf/simulated/floor/exoplanet
	name = "space land"
	icon = 'icons/misc/beach.dmi'
	icon_state = "desert"

/turf/simulated/floor/exoplanet/New()
	if(GLOB.using_map.use_overmap)
		var/obj/effect/overmap/sector/exoplanet/E = map_sectors["[z]"]
		if(istype(E))
			if(E.atmosphere)
				initial_gas = E.atmosphere.gas.Copy()
				temperature = E.atmosphere.temperature
			if(E.lightlevel)
				light_power = E.lightlevel
				light_range = 2
	..()

/turf/simulated/floor/exoplanet/ex_act(severity)
	switch(severity)
		if(1)
			ChangeTurf(get_base_turf_by_area(src))
		if(2)
			if(prob(40))
				ChangeTurf(get_base_turf_by_area(src))

/turf/simulated/floor/exoplanet/water/shallow
	name = "shallow water"
	icon_state = "seashallow"
	movement_delay = 2

/turf/simulated/floor/exoplanet/water/update_dirt()
	return	// Water doesn't become dirty