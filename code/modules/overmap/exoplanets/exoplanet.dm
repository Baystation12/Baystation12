/obj/effect/overmap/sector/exoplanet
	name = "exoplanet"
	icon_state = "globe"
	var/list/seeds = list()
	var/list/animals = list()
	var/max_animal_count
	var/datum/gas_mixture/atmosphere
	var/list/breathgas = list()	//list of gases animals/plants require to survive
	var/badgas					//id of gas that is toxic to life here

	var/lightlevel
	in_space = 0
	var/maxx
	var/maxy
	var/landmark_type = /obj/effect/shuttle_landmark/automatic

	var/list/actors = list() //things that appear in engravings on xenoarch finds.
	var/list/species = list() //list of names to use for simple animals

	var/repopulating = 0
	var/repopulate_types = list() // animals which have died that may come back


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
		START_PROCESSING(SSobj, src)

//attempt at more consistent history generation for xenoarch finds.
/obj/effect/overmap/sector/exoplanet/proc/get_engravings()
	if(!actors)
		actors += pick("alien humanoid","amorphic blob","short, hairy being","rodent-like creature","robot","primate","reptilian alien","unidentifiable object","statue","starship","unusual devices","structure")
		actors += pick("alien humanoids","amorphic blobs","short, hairy beings","rodent-like creatures","robots","primates","reptilian aliens")

	var/engravings = "[pick("Engraved","Carved","Etched")] on the item is [pick("an image of","a frieze of","a depiction of")] a \
	[pick(actors[1])] \
	[pick("surrounded by","being held aloft by","being struck by","being examined by","communicating with")] \
	[pick(actors[2])]"
	if(prob(50))
		engravings += ", [pick("they seem to be enjoying themselves","they seem extremely angry","they look pensive","they are making gestures of supplication","the scene is one of subtle horror","the scene conveys a sense of desperation","the scene is completely bizarre")]"
	engravings += "."
	return engravings

//Not that it should ever get deleted but just in case
/obj/effect/overmap/sector/exoplanet/Destroy()
		. = ..()
		STOP_PROCESSING(SSobj, src)

/obj/effect/overmap/sector/exoplanet/Process()
	if(animals.len < 0.5*max_animal_count && !repopulating)
		repopulating = 1
		max_animal_count = round(max_animal_count * 0.5)
	for(var/zlevel in map_z)
		if(repopulating)
			for(var/i = 1 to round(max_animal_count - animals.len))
				if(prob(10))
					var/turf/simulated/T = locate(rand(1,world.maxx), rand(1,world.maxy), zlevel)
					var/mob_type = pick(repopulate_types)
					var/mob/S = new mob_type(T)
					animals += S
					GLOB.death_event.register(S, src, /obj/effect/overmap/sector/exoplanet/proc/remove_animal)
					GLOB.destroyed_event.register(S, src, /obj/effect/overmap/sector/exoplanet/proc/remove_animal)
					adapt_animal(S)
			if(animals.len >= max_animal_count)
				repopulating = 0

		if(!atmosphere)
			continue
		var/zone/Z
		for(var/i = 1 to world.maxx)
			var/turf/simulated/T = locate(i, 1, zlevel)
			if(istype(T) && T.zone && T.zone.contents.len > (world.maxx*world.maxy*0.25)) //if it's a zone quarter of zlevel, good enough odds it's planetary main one
				Z = T.zone
				break
		if(Z && !Z.fire_tiles.len && !atmosphere.compare(Z.air)) //let fire die out first if there is one
			var/datum/gas_mixture/daddy = new() //make a fake 'planet' zone gas
			daddy.copy_from(atmosphere)
			daddy.group_multiplier = Z.air.group_multiplier
			Z.air.equalize(daddy)

/obj/effect/overmap/sector/exoplanet/proc/remove_animal(var/mob/M)
	animals -= M
	GLOB.death_event.unregister(M, src)
	GLOB.destroyed_event.unregister(M, src)
	repopulate_types |= M.type

/obj/effect/overmap/sector/exoplanet/proc/generate_map()

/obj/effect/overmap/sector/exoplanet/proc/get_biostuff(var/datum/random_map/noise/exoplanet/random_map)
	seeds += random_map.small_flora_types
	if(random_map.big_flora_types)
		seeds += random_map.big_flora_types
	for(var/mob/living/simple_animal/A in GLOB.living_mob_list_)
		if(A.z in map_z)
			animals += A
			GLOB.death_event.register(A, src, /obj/effect/overmap/sector/exoplanet/proc/remove_animal)
			GLOB.destroyed_event.register(A, src, /obj/effect/overmap/sector/exoplanet/proc/remove_animal)
	max_animal_count = animals.len

/obj/effect/overmap/sector/exoplanet/proc/update_biome()
	for(var/datum/seed/S in seeds)
		adapt_seed(S)

	for(var/mob/living/simple_animal/A in animals)
		adapt_animal(A)

/obj/effect/overmap/sector/exoplanet/proc/adapt_seed(var/datum/seed/S)
	S.set_trait(TRAIT_IDEAL_HEAT,          atmosphere.temperature + rand(-5,5),800,70)
	S.set_trait(TRAIT_HEAT_TOLERANCE,      S.get_trait(TRAIT_HEAT_TOLERANCE) + rand(-5,5),800,70)
	S.set_trait(TRAIT_LOWKPA_TOLERANCE,    atmosphere.return_pressure() + rand(-5,-50),80,0)
	S.set_trait(TRAIT_HIGHKPA_TOLERANCE,   atmosphere.return_pressure() + rand(5,50),500,110)
	if(S.exude_gasses)
		S.exude_gasses -= badgas
	if(S.consume_gasses)
		S.consume_gasses = list(pick(atmosphere.gas)) // ensure that if the plant consumes a gas, the atmosphere will have it
	for(var/g in atmosphere.gas)
		if(gas_data.flags[g] & XGM_GAS_CONTAMINANT)
			S.set_trait(TRAIT_TOXINS_TOLERANCE, rand(10,15))

/obj/effect/overmap/sector/exoplanet/proc/adapt_animal(var/mob/living/simple_animal/A)
	if(species[A.type])
		A.name = species[A.type]
		A.real_name = species[A.type]
	else
		A.name = "alien creature"
		A.real_name = "alien creature"
		A.verbs |= /mob/living/simple_animal/proc/name_species
	A.minbodytemp = atmosphere.temperature - 20
	A.maxbodytemp = atmosphere.temperature + 30
	A.bodytemperature = (A.maxbodytemp+A.minbodytemp)/2
	if(A.min_gas)
		A.min_gas = breathgas.Copy()
	if(A.max_gas)
		A.max_gas = list()
		A.max_gas[badgas] = 5

/obj/effect/overmap/sector/exoplanet/proc/get_random_species_name()
	return pick("nol","shan","can","fel","xor")+pick("a","e","o","t","ar")+pick("ian","oid","ac","ese","inian","rd")

/obj/effect/overmap/sector/exoplanet/proc/rename_species(var/species_type, var/newname, var/force = FALSE)
	if(species[species_type] && !force)
		return FALSE

	species[species_type] = newname
	log_and_message_admins("renamed [species_type] to [newname]")
	for(var/mob/living/simple_animal/A in animals)
		if(istype(A,species_type))
			A.name = newname
			A.real_name = newname
			A.verbs -= /mob/living/simple_animal/proc/name_species
	return TRUE

/obj/effect/overmap/sector/exoplanet/proc/generate_landing()
	var/turf/T = locate(rand(20, maxx-20), rand(20, maxy - 10),map_z[map_z.len])
	if(T)
		new landmark_type(T)
	return T

/obj/effect/overmap/sector/exoplanet/proc/generate_atmosphere()
	atmosphere = new
	if(prob(10))	//small chance of getting a perfectly habitable planet
		atmosphere.adjust_gas("oxygen", MOLES_O2STANDARD, 0)
		atmosphere.adjust_gas("nitrogen", MOLES_N2STANDARD)
	else //let the fuckery commence
		var/list/newgases = gas_data.gases.Copy()
		if(prob(90)) //all phoron planet should be rare
			newgases -= "phoron"
		if(prob(50)) //alium gas should be slightly less common than mundane shit
			newgases -= "aliether"

		var/total_moles = MOLES_CELLSTANDARD * rand(80,120)/100
		var/gasnum = rand(1,4)
		for(var/i = 1 to gasnum) //swapping gases wholesale. don't try at home
			var/ng = pick_n_take(newgases)	//pick a gas
			var/part = total_moles * rand(3,80)/100 //allocate percentage to it
			if(i == gasnum) //if it's last gas, let it have all remaining moles
				part = total_moles
			atmosphere.gas[ng] += part
			total_moles = max(total_moles - part, 0)

	atmosphere.temperature = T20C + rand(-10, 10)
	var/factor = max(rand(60,140)/100, 0.6)
	atmosphere.multiply(factor)

	//Set up gases for living things
	for(var/gas in atmosphere.gas)
		breathgas[gas] = round(0.4*atmosphere.gas[gas])
	var/list/badgases = gas_data.gases.Copy()
	badgases -= atmosphere.gas
	badgas = pick(badgases)

/obj/effect/overmap/sector/exoplanet/proc/process_map_edge(atom/movable/A)
	var/new_x
	var/new_y
	if(A.x <= TRANSITIONEDGE)
		new_x = world.maxx - TRANSITIONEDGE - 2
		new_y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

	else if (A.x >= (world.maxx - TRANSITIONEDGE + 1))
		new_x = TRANSITIONEDGE + 1
		new_y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

	else if (A.y <= TRANSITIONEDGE)
		new_y = world.maxy - TRANSITIONEDGE -2
		new_x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

	else if (A.y >= (world.maxy - TRANSITIONEDGE + 1))
		new_y = TRANSITIONEDGE + 1
		new_x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

	var/turf/T = locate(new_x, new_y, A.z)
	if(T)
		A.forceMove(T)

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
	var/fauna_prob = 2
	var/flora_diversity = 4

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
	for(var/i = 1 to flora_diversity)
		var/datum/seed/S = new()
		S.randomize()
		S.set_trait(TRAIT_PRODUCT_ICON,"alien[rand(1,5)]")
		S.set_trait(TRAIT_PLANT_ICON,"alien[rand(1,4)]")
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
	for(var/i = 1 to flora_diversity)
		var/datum/seed/S = new()
		S.randomize()
		S.set_trait(TRAIT_PRODUCT_ICON,"alien[rand(1,5)]")
		S.set_trait(TRAIT_PLANT_ICON,"tree5")
		S.set_trait(TRAIT_SPREAD,0)
		S.set_trait(TRAIT_HARVEST_REPEAT,1)
		S.chems["woodpulp"] = 1
		big_flora_types += S

/datum/random_map/noise/exoplanet/proc/spawn_flora(var/turf/T, var/big)
	if(big)
		new /obj/effect/vine(T, pick(big_flora_types), start_matured = 1)
	else
		new /obj/effect/vine(T, pick(small_flora_types), start_matured = 1)

/turf/simulated/floor/exoplanet
	name = "space land"
	icon = 'icons/turf/desert.dmi'
	icon_state = "desert"
	has_resources = 1
	var/diggable = 1
	var/mudpit = 0	//if pits should not take turf's color

/turf/simulated/floor/exoplanet/Entered(atom/movable/A)
	..()
	if(A.simulated && GLOB.using_map.use_overmap)
		if (A.x <= TRANSITIONEDGE || A.x >= (world.maxx - TRANSITIONEDGE + 1) || A.y <= TRANSITIONEDGE || A.y >= (world.maxy - TRANSITIONEDGE + 1))
			var/obj/effect/overmap/sector/exoplanet/E = map_sectors["[z]"]
			if(istype(E))
				E.process_map_edge(A)

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

/turf/simulated/floor/exoplanet/attackby(obj/item/C, mob/user)
	if(diggable && istype(C,/obj/item/weapon/shovel))
		visible_message("<span class='notice'>\The [user] starts digging \the [src]</span>")
		if(do_after(user, 50))
			to_chat(user,"<span class='notice'>You dig a deep pit.</span>")
			new /obj/structure/pit(src)
			diggable = 0
		else
			to_chat(user,"<span class='notice'>You stop shoveling.</span>")
	else
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
	icon = 'icons/misc/beach.dmi'
	icon_state = "seashallow"
	movement_delay = 2
	mudpit = 1

/turf/simulated/floor/exoplanet/water/update_dirt()
	return	// Water doesn't become dirty