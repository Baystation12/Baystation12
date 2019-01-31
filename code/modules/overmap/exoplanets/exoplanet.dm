/obj/effect/overmap/sector/exoplanet
	name = "exoplanet"
	icon_state = "globe"
	var/list/seeds = list()
	var/list/animals = list()
	var/max_animal_count
	var/datum/gas_mixture/atmosphere
	var/list/breathgas = list()	//list of gases animals/plants require to survive
	var/badgas					//id of gas that is toxic to life here

	var/lightlevel = 0 //This default makes turfs not generate light. Adjust to have exoplanents be lit.
	var/night = TRUE
	var/daycycle //How often do we change day and night
	var/daycolumn = 0 //Which column's light needs to be updated next?
	var/daycycle_column_delay = 10 SECONDS

	in_space = 0
	var/maxx
	var/maxy
	var/landmark_type = /obj/effect/shuttle_landmark/automatic

	var/list/actors = list() //things that appear in engravings on xenoarch finds.
	var/list/species = list() //list of names to use for simple animals

	var/repopulating = 0
	var/repopulate_types = list() // animals which have died that may come back

	var/features_budget = 2
	//pre-defined list of features templates to pick from
	var/list/possible_features = list(
									/datum/map_template/ruin/exoplanet/monolith,
									/datum/map_template/ruin/exoplanet/hydrobase,
									/datum/map_template/ruin/exoplanet/crashed_pod,
									/datum/map_template/ruin/exoplanet/hut,
									/datum/map_template/ruin/exoplanet/playablecolony)

/obj/effect/overmap/sector/exoplanet/New(nloc, max_x, max_y)
	if(!GLOB.using_map.use_overmap)
		return

	maxx = max_x ? max_x : world.maxx
	maxy = max_y ? max_y : world.maxy

	name = "[generate_planet_name()], \a [name]"

	world.maxz++
	forceMove(locate(1,1,world.maxz))

	var/list/feature_types = possible_features.Copy()
	possible_features.Cut()
	for(var/T in feature_types)
		var/datum/map_template/ruin/exoplanet/ruin = new T
		possible_features += ruin
	..()

/obj/effect/overmap/sector/exoplanet/proc/build_level()
	generate_atmosphere()
	generate_map()
	generate_features()
	generate_landing(2)		//try making 4 landmarks
	update_biome()
	generate_daycycle()
	START_PROCESSING(SSobj, src)

//attempt at more consistent history generation for xenoarch finds.
/obj/effect/overmap/sector/exoplanet/proc/get_engravings()
	if(!actors.len)
		actors += pick("alien humanoid","an amorphic blob","a short, hairy being","a rodent-like creature","a robot","a primate","a reptilian alien","an unidentifiable object","a statue","a starship","unusual devices","a structure")
		actors += pick("alien humanoids","amorphic blobs","short, hairy beings","rodent-like creatures","robots","primates","reptilian aliens")

	var/engravings = "[actors[1]] \
	[pick("surrounded by","being held aloft by","being struck by","being examined by","communicating with")] \
	[actors[2]]"
	if(prob(50))
		engravings += ", [pick("they seem to be enjoying themselves","they seem extremely angry","they look pensive","they are making gestures of supplication","the scene is one of subtle horror","the scene conveys a sense of desperation","the scene is completely bizarre")]"
	engravings += "."
	return engravings

//Not that it should ever get deleted but just in case
/obj/effect/overmap/sector/exoplanet/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/effect/overmap/sector/exoplanet/Process(wait, tick)
	if(animals.len < 0.5*max_animal_count && !repopulating)
		repopulating = 1
		max_animal_count = round(max_animal_count * 0.5)
	for(var/zlevel in map_z)
		if(repopulating)
			for(var/i = 1 to round(max_animal_count - animals.len))
				if(prob(10))
					var/turf/simulated/T = locate(rand(1,maxx), rand(1,maxy), zlevel)
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
		for(var/i = 1 to maxx)
			var/turf/simulated/T = locate(i, 2, zlevel)
			if(istype(T) && T.zone && T.zone.contents.len > (maxx*maxy*0.25)) //if it's a zone quarter of zlevel, good enough odds it's planetary main one
				Z = T.zone
				break
		if(Z && !Z.fire_tiles.len && !atmosphere.compare(Z.air)) //let fire die out first if there is one
			var/datum/gas_mixture/daddy = new() //make a fake 'planet' zone gas
			daddy.copy_from(atmosphere)
			daddy.group_multiplier = Z.air.group_multiplier
			Z.air.equalize(daddy)

	if(daycycle)
		if(tick % round(daycycle / wait) == 0)
			night = !night
			daycolumn = 1
		if(daycolumn && tick % round(daycycle_column_delay / wait) == 0)
			update_daynight()

/obj/effect/overmap/sector/exoplanet/proc/update_daynight()
	var/light = 0.1
	if(!night)
		light = lightlevel
	for(var/turf/simulated/floor/exoplanet/T in block(locate(daycolumn,1,min(map_z)),locate(daycolumn,maxy,max(map_z))))
		T.set_light(light, 0.1, 2)
	daycolumn++
	if(daycolumn > maxx)
		daycolumn = 0

/obj/effect/overmap/sector/exoplanet/proc/remove_animal(var/mob/M)
	animals -= M
	GLOB.death_event.unregister(M, src)
	GLOB.destroyed_event.unregister(M, src)
	repopulate_types |= M.type

/obj/effect/overmap/sector/exoplanet/proc/generate_map()

/obj/effect/overmap/sector/exoplanet/proc/generate_features()
	seedRuins(map_z, features_budget, /area/exoplanet, possible_features, maxx, maxy)

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

/obj/effect/overmap/sector/exoplanet/proc/generate_daycycle()
	if(lightlevel)
		night = FALSE //we start with a day if we have light.

		//When you set daycycle ensure that the minimum is larger than [maxx * daycycle_column_delay].
		//Otherwise the right side of the exoplanet can get stuck in a forever day.
		daycycle = rand(10 MINUTES, 40 MINUTES)

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
	if(prob(50))
		var/chem_type = SSchemistry.get_random_chem(TRUE, atmosphere.temperature)
		if(chem_type)
			var/nutriment = S.chems[/datum/reagent/nutriment]
			S.chems.Cut()
			S.chems[/datum/reagent/nutriment] = nutriment
			S.chems[chem_type] = list(rand(1,10),rand(10,20))

/obj/effect/overmap/sector/exoplanet/proc/adapt_animal(var/mob/living/simple_animal/A)
	if(species[A.type])
		A.SetName(species[A.type])
		A.real_name = species[A.type]
	else
		A.SetName("alien creature")
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
			A.SetName(newname)
			A.real_name = newname
			A.verbs -= /mob/living/simple_animal/proc/name_species
	return TRUE

//Tries to generate num landmarks, but avoids repeats.
/obj/effect/overmap/sector/exoplanet/proc/generate_landing(num = 1)
	var/places = list()
	var/attempts = 10*num
	var/new_type = landmark_type
	while(num)
		attempts--
		var/turf/T = locate(rand(20, maxx-20), rand(20, maxy - 10),map_z[map_z.len])
		if(!T || (T in places)) // Two landmarks on one turf is forbidden as the landmark code doesn't work with it.
			continue
		if(attempts >= 0) // While we have the patience, try to find better spawn points. If out of patience, put them down wherever, so long as there are no repeats.
			var/valid = 1
			var/list/block_to_check = block(locate(T.x - 10, T.y - 10, T.z), locate(T.x + 10, T.y + 10, T.z))
			for(var/turf/check in block_to_check)
				if(!istype(get_area(check), /area/exoplanet) || check.turf_flags & TURF_FLAG_NORUINS)
					valid = 0
					break
			if(attempts >= 10)
				if(check_collision(T.loc, block_to_check)) //While we have lots of patience, ensure landability
					valid = 0
			else //Running out of patience, but would rather not clear ruins, so switch to clearing landmarks and bypass landability check
				new_type = /obj/effect/shuttle_landmark/automatic/clearing

			if(!valid)
				continue

		num--
		places += T
		new new_type(T)

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
		newgases -= "watervapor"

		var/sanity = prob(99.9)

		var/total_moles = MOLES_CELLSTANDARD * rand(80,120)/100
		var/gasnum = rand(1,4)
		var/i = 1
		while(i <= gasnum && total_moles && newgases.len)
			var/ng = pick_n_take(newgases)	//pick a gas
			if(sanity) //make sure atmosphere is not flammable... always
				var/badflag = 0
				if(gas_data.flags[ng] & XGM_GAS_OXIDIZER)
					badflag = XGM_GAS_FUEL
				if(gas_data.flags[ng] & XGM_GAS_FUEL)
					badflag = XGM_GAS_OXIDIZER
				if(badflag)
					for(var/g in newgases)
						if(gas_data.flags[g] & badflag)
							newgases -= g
					sanity = 0

			var/part = total_moles * rand(3,80)/100 //allocate percentage to it
			if(i == gasnum || !newgases.len) //if it's last gas, let it have all remaining moles
				part = total_moles
			atmosphere.gas[ng] += part
			total_moles = max(total_moles - part, 0)
			i++

	//Set up gases for living things
	for(var/gas in atmosphere.gas)
		breathgas[gas] = round(0.4*atmosphere.gas[gas])
	var/list/badgases = gas_data.gases.Copy()
	badgases -= atmosphere.gas
	badgas = pick(badgases)

/obj/effect/overmap/sector/exoplanet/proc/process_map_edge(atom/movable/A)
	var/new_x = A.x
	var/new_y = A.y
	var/old_x = A.x
	var/old_y = A.y
	if(A.x <= TRANSITIONEDGE)
		new_x = maxx - TRANSITIONEDGE - 2
		old_x = A.x + 1

	else if (A.x >= (maxx - TRANSITIONEDGE + 1))
		new_x = TRANSITIONEDGE + 1
		old_x = A.x - 1

	else if (A.y <= TRANSITIONEDGE)
		new_y = maxy - TRANSITIONEDGE -2
		old_y = A.y + 1

	else if (A.y >= (maxy - TRANSITIONEDGE + 1))
		new_y = TRANSITIONEDGE + 1
		old_y = A.y - 1

	var/turf/T = locate(new_x, new_y, A.z)
	if(T)
		if(T.density) // dense thing will block movement
			T = locate(old_x, old_y, A.z)
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

	//intended x*y size, used to adjust spawn probs
	var/intended_x = 150
	var/intended_y = 150
	var/large_flora_prob = 60
	var/flora_prob = 60
	var/fauna_prob = 2
	var/flora_diversity = 4

	var/list/fauna_types = list()
	var/list/small_flora_types = list()
	var/list/big_flora_types = list()
	var/list/plantcolors = list("RANDOM")

/datum/random_map/noise/exoplanet/New(var/seed, var/tx, var/ty, var/tz, var/tlx, var/tly, var/do_not_apply, var/do_not_announce, var/never_be_priority = 0)
	target_turf_type = world.turf
	planetary_area = new planetary_area()
	water_level = rand(water_level_min,water_level_max)
	generate_flora()

	//automagically adjust probs for bigger maps to help with lag
	var/size_mod = intended_x / tlx * intended_y / tly
	flora_prob *= size_mod
	large_flora_prob *= size_mod
	fauna_prob *= size_mod

	..()

	GLOB.using_map.base_turf_by_z[num2text(tz)] = land_type

/datum/random_map/noise/exoplanet/proc/noise2value(var/value)
	return min(9,max(0,round((value/cell_range)*10)))

/datum/random_map/noise/exoplanet/apply_to_turf(var/x,var/y)
	var/turf/T = ..()
	if(!T)
		return
	if(limit_x < world.maxx && (T.y == limit_y || T.x == limit_x))
		T.set_density(1)
		T.set_opacity(1)
		if(istype(T, /turf/simulated))
			var/turf/simulated/S = T
			S.blocks_air = 1
	if(T.x <= TRANSITIONEDGE || T.x >= (limit_x - TRANSITIONEDGE + 1) || T.y <= TRANSITIONEDGE || T.y >= (limit_y - TRANSITIONEDGE + 1))
		new/obj/effect/fogofwar(T)

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
		var/planticon = "alien[rand(1,4)]"
		S.set_trait(TRAIT_PRODUCT_ICON,planticon)
		S.set_trait(TRAIT_PLANT_ICON,planticon)
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
	if(large_flora_prob)
		var/tree_diversity = max(1,flora_diversity/2)
		for(var/i = 1 to tree_diversity)
			var/datum/seed/S = new()
			S.randomize()
			S.set_trait(TRAIT_PRODUCT_ICON,"alien[rand(1,5)]")
			S.set_trait(TRAIT_PLANT_ICON,"tree")
			S.set_trait(TRAIT_SPREAD,0)
			S.set_trait(TRAIT_HARVEST_REPEAT,1)
			S.set_trait(TRAIT_LARGE,1)
			var/color = pick(plantcolors)
			if(color == "RANDOM")
				color = get_random_colour(0,75,190)
			S.set_trait(TRAIT_LEAVES_COLOUR,color)
			S.chems[/datum/reagent/woodpulp] = 1
			big_flora_types += S

/datum/random_map/noise/exoplanet/proc/spawn_flora(var/turf/T, var/big)
	if(big)
		new /obj/machinery/portable_atmospherics/hydroponics/soil/invisible(T, pick(big_flora_types), 1)
	else
		new /obj/machinery/portable_atmospherics/hydroponics/soil/invisible(T, pick(small_flora_types), 1)

/turf/simulated/floor/exoplanet
	name = "space land"
	icon = 'icons/turf/desert.dmi'
	icon_state = "desert"
	has_resources = 1
	var/diggable = 1
	var/mudpit = 0	//if pits should not take turf's color

/turf/simulated/floor/exoplanet/can_engrave()
	return FALSE

/turf/simulated/floor/exoplanet/Entered(atom/movable/A)
	..()

	if(A.simulated && GLOB.using_map.use_overmap)
		var/obj/effect/overmap/sector/exoplanet/sector = map_sectors["[z]"]
		if(istype(sector))
			if (A.x <= TRANSITIONEDGE || A.x >= (sector.maxx - TRANSITIONEDGE + 1) || A.y <= TRANSITIONEDGE || A.y >= (sector.maxy - TRANSITIONEDGE + 1))
				sector.process_map_edge(A)

/turf/simulated/floor/exoplanet/New()
	if(GLOB.using_map.use_overmap)
		var/obj/effect/overmap/sector/exoplanet/E = map_sectors["[z]"]
		if(istype(E))
			if(E.atmosphere)
				initial_gas = E.atmosphere.gas.Copy()
				temperature = E.atmosphere.temperature
			//Must be done here, as light data is not fully carried over by ChangeTurf (but overlays are).
			set_light(E.lightlevel, 0.1, 2)
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
	var/reagent_type = /datum/reagent/water

/turf/simulated/floor/exoplanet/water/shallow/attackby(obj/item/O, var/mob/living/user)
	var/obj/item/weapon/reagent_containers/RG = O
	if (reagent_type && istype(RG) && RG.is_open_container() && RG.reagents)
		RG.reagents.add_reagent(reagent_type, min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		user.visible_message("<span class='notice'>[user] fills \the [RG] from \the [src].</span>","<span class='notice'>You fill \the [RG] from \the [src].</span>")
	else
		return ..()

/turf/simulated/floor/exoplanet/water/update_dirt()
	return	// Water doesn't become dirty

/obj/effect/fogofwar
	name = "fog of war"
	desc = "Thar be dragons"
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	opacity = 0
	anchored = 1
	mouse_opacity = 0
	simulated = 0

/turf/simulated/floor/exoplanet/Initialize()
	. = ..()
	update_icon(1)

/turf/simulated/floor/exoplanet/on_update_icon(var/update_neighbors)
	overlays.Cut()
	for(var/direction in GLOB.cardinal)
		var/turf/turf_to_check = get_step(src,direction)
		if(!istype(turf_to_check, type))
			var/image/rock_side = image(icon, "edge[pick(0,1,2)]", dir = turn(direction, 180))
			rock_side.plating_decal_layerise()
			switch(direction)
				if(NORTH)
					rock_side.pixel_y += world.icon_size
				if(SOUTH)
					rock_side.pixel_y -= world.icon_size
				if(EAST)
					rock_side.pixel_x += world.icon_size
				if(WEST)
					rock_side.pixel_x -= world.icon_size
			overlays += rock_side
		else if(update_neighbors)
			turf_to_check.update_icon()

/turf/simulated/floor/exoplanet/water/on_update_icon()
	return