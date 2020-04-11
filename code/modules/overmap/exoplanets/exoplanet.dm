/obj/effect/overmap/visitable/sector/exoplanet
	name = "exoplanet"
	icon_state = "globe"
	in_space = 0
	var/area/planetary_area
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

	var/maxx
	var/maxy
	var/landmark_type = /obj/effect/shuttle_landmark/automatic

	var/list/rock_colors = list(COLOR_ASTEROID_ROCK)
	var/list/plant_colors = list("RANDOM")
	var/grass_color
	var/surface_color = COLOR_ASTEROID_ROCK
	var/water_color = "#436499"
	var/image/skybox_image

	var/list/actors = list() //things that appear in engravings on xenoarch finds.
	var/list/species = list() //list of names to use for simple animals

	var/repopulating = 0
	var/repopulate_types = list() // animals which have died that may come back

	var/list/possible_themes = list(/datum/exoplanet_theme/mountains,/datum/exoplanet_theme)
	var/list/themes = list()

	var/list/map_generators = list()

	//Flags deciding what features to pick
	var/ruin_tags_whitelist
	var/ruin_tags_blacklist
	var/features_budget = 4
	var/list/possible_features = list()
	var/list/spawned_features

	var/habitability_class

/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_habitability()
	var/roll = rand(1,100)
	switch(roll)
		if(1 to 10)
			habitability_class = HABITABILITY_IDEAL
		if(11 to 50)
			habitability_class = HABITABILITY_OKAY
		else
			habitability_class = HABITABILITY_BAD

/obj/effect/overmap/visitable/sector/exoplanet/New(nloc, max_x, max_y)
	if(!GLOB.using_map.use_overmap)
		return

	maxx = max_x ? max_x : world.maxx
	maxy = max_y ? max_y : world.maxy
	planetary_area = new planetary_area()

	name = "[generate_planet_name()], \a [name]"

	world.maxz++
	forceMove(locate(1,1,world.maxz))

	if(LAZYLEN(possible_themes))
		var/datum/exoplanet_theme/T = pick(possible_themes)
		themes += new T

	for(var/T in subtypesof(/datum/map_template/ruin/exoplanet))
		var/datum/map_template/ruin/exoplanet/ruin = T
		if(ruin_tags_whitelist && !(ruin_tags_whitelist & initial(ruin.ruin_tags)))
			continue
		if(ruin_tags_blacklist & initial(ruin.ruin_tags))
			continue
		possible_features += new ruin
	..()

/obj/effect/overmap/visitable/sector/exoplanet/proc/build_level()
	generate_habitability()
	generate_atmosphere()
	generate_map()
	generate_features()
	generate_landing(2)
	update_biome()
	generate_daycycle()
	generate_planet_image()
	START_PROCESSING(SSobj, src)

//attempt at more consistent history generation for xenoarch finds.
/obj/effect/overmap/visitable/sector/exoplanet/proc/get_engravings()
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

/obj/effect/overmap/visitable/sector/exoplanet/Process(wait, tick)
	if(animals.len < 0.5*max_animal_count && !repopulating)
		repopulating = 1
		max_animal_count = round(max_animal_count * 0.5)
	for(var/zlevel in map_z)
		if(repopulating)
			for(var/i = 1 to round(max_animal_count - animals.len))
				if(prob(10))
					var/turf/simulated/T = pick_area_turf(planetary_area, list(/proc/not_turf_contains_dense_objects))
					var/mob_type = pick(repopulate_types)
					var/mob/S = new mob_type(T)
					animals += S
					GLOB.death_event.register(S, src, /obj/effect/overmap/visitable/sector/exoplanet/proc/remove_animal)
					GLOB.destroyed_event.register(S, src, /obj/effect/overmap/visitable/sector/exoplanet/proc/remove_animal)
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

/obj/effect/overmap/visitable/sector/exoplanet/proc/update_daynight()
	var/light = 0.1
	if(!night)
		light = lightlevel
	for(var/turf/simulated/floor/exoplanet/T in block(locate(daycolumn,1,min(map_z)),locate(daycolumn,maxy,max(map_z))))
		T.set_light(light, 0.1, 2)
	daycolumn++
	if(daycolumn > maxx)
		daycolumn = 0

/obj/effect/overmap/visitable/sector/exoplanet/proc/remove_animal(var/mob/M)
	animals -= M
	GLOB.death_event.unregister(M, src)
	GLOB.destroyed_event.unregister(M, src)
	repopulate_types |= M.type

/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_map()
	var/list/grasscolors = plant_colors.Copy()
	grasscolors -= "RANDOM"
	if(length(grasscolors))
		grass_color = pick(grasscolors)

	for(var/datum/exoplanet_theme/T in themes)
		T.before_map_generation(src)
	for(var/zlevel in map_z)
		var/list/edges
		edges += block(locate(1, 1, zlevel), locate(TRANSITIONEDGE, maxy, zlevel))
		edges |= block(locate(maxx-TRANSITIONEDGE, 1, zlevel),locate(maxx, maxy, zlevel))
		edges |= block(locate(1, 1, zlevel), locate(maxx, TRANSITIONEDGE, zlevel))
		edges |= block(locate(1, maxy-TRANSITIONEDGE, zlevel),locate(maxx, maxy, zlevel))
		for(var/turf/T in edges)
			T.ChangeTurf(/turf/simulated/planet_edge)
		var/padding = TRANSITIONEDGE
		for(var/map_type in map_generators)
			if(ispath(map_type, /datum/random_map/noise/exoplanet))
				var/datum/random_map/noise/exoplanet/RM = new map_type(null,padding,padding,zlevel,maxx-padding,maxy-padding,0,1,1,planetary_area, plant_colors)
				get_biostuff(RM)
			else
				new map_type(null,1,1,zlevel,maxx,maxy,0,1,1,planetary_area)

/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_features()
	spawned_features = seedRuins(map_z, features_budget, /area/exoplanet, possible_features, maxx, maxy)

/obj/effect/overmap/visitable/sector/exoplanet/proc/get_biostuff(var/datum/random_map/noise/exoplanet/random_map)
	if(!istype(random_map))
		return
	seeds += random_map.small_flora_types
	if(random_map.big_flora_types)
		seeds += random_map.big_flora_types
	for(var/mob/living/simple_animal/A in GLOB.living_mob_list_)
		if(A.z in map_z)
			animals += A
			GLOB.death_event.register(A, src, /obj/effect/overmap/visitable/sector/exoplanet/proc/remove_animal)
			GLOB.destroyed_event.register(A, src, /obj/effect/overmap/visitable/sector/exoplanet/proc/remove_animal)
	max_animal_count = animals.len

/obj/effect/overmap/visitable/sector/exoplanet/proc/update_biome()
	for(var/datum/seed/S in seeds)
		adapt_seed(S)

	for(var/mob/living/simple_animal/A in animals)
		adapt_animal(A)

/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_daycycle()
	if(lightlevel)
		night = FALSE //we start with a day if we have light.

		//When you set daycycle ensure that the minimum is larger than [maxx * daycycle_column_delay].
		//Otherwise the right side of the exoplanet can get stuck in a forever day.
		daycycle = rand(10 MINUTES, 40 MINUTES)

/obj/effect/overmap/visitable/sector/exoplanet/proc/adapt_seed(var/datum/seed/S)
	S.set_trait(TRAIT_IDEAL_HEAT,          atmosphere.temperature + rand(-5,5),800,70)
	S.set_trait(TRAIT_HEAT_TOLERANCE,      S.get_trait(TRAIT_HEAT_TOLERANCE) + rand(-5,5),800,70)
	S.set_trait(TRAIT_LOWKPA_TOLERANCE,    atmosphere.return_pressure() + rand(-5,-50),80,0)
	S.set_trait(TRAIT_HIGHKPA_TOLERANCE,   atmosphere.return_pressure() + rand(5,50),500,110)
	if(S.exude_gasses)
		S.exude_gasses -= badgas
	if(atmosphere)
		if(S.consume_gasses)
			S.consume_gasses = list(pick(atmosphere.gas)) // ensure that if the plant consumes a gas, the atmosphere will have it
		for(var/g in atmosphere.gas)
			if(gas_data.flags[g] & XGM_GAS_CONTAMINANT)
				S.set_trait(TRAIT_TOXINS_TOLERANCE, rand(10,15))
	if(prob(50))
		var/chem_type = SSchemistry.get_random_chem(TRUE, atmosphere ? atmosphere.temperature : T0C)
		if(chem_type)
			var/nutriment = S.chems[/datum/reagent/nutriment]
			S.chems.Cut()
			S.chems[/datum/reagent/nutriment] = nutriment
			S.chems[chem_type] = list(rand(1,10),rand(10,20))

/obj/effect/overmap/visitable/sector/exoplanet/proc/adapt_animal(var/mob/living/simple_animal/A)
	if(species[A.type])
		A.SetName(species[A.type])
		A.real_name = species[A.type]
	else
		A.SetName("alien creature")
		A.real_name = "alien creature"
		A.verbs |= /mob/living/simple_animal/proc/name_species
	if(atmosphere)
		//Set up gases for living things
		if(!LAZYLEN(breathgas))
			var/list/goodgases = gas_data.gases.Copy()
			var/gasnum = min(rand(1,3), goodgases.len)
			for(var/i = 1 to gasnum)
				var/gas = pick(goodgases)
				breathgas[gas] = round(0.4*goodgases[gas], 0.1)
				goodgases -= gas
		if(!badgas)
			var/list/badgases = gas_data.gases.Copy()
			badgases -= atmosphere.gas
			badgas = pick(badgases)

		A.minbodytemp = atmosphere.temperature - 20
		A.maxbodytemp = atmosphere.temperature + 30
		A.bodytemperature = (A.maxbodytemp+A.minbodytemp)/2
		if(A.min_gas)
			A.min_gas = breathgas.Copy()
		if(A.max_gas)
			A.max_gas = list()
			A.max_gas[badgas] = 5
	else
		A.min_gas = null
		A.max_gas = null

/obj/effect/overmap/visitable/sector/exoplanet/proc/get_random_species_name()
	return pick("nol","shan","can","fel","xor")+pick("a","e","o","t","ar")+pick("ian","oid","ac","ese","inian","rd")

/obj/effect/overmap/visitable/sector/exoplanet/proc/rename_species(var/species_type, var/newname, var/force = FALSE)
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
/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_landing(num = 1)
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

/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_atmosphere()
	atmosphere = new
	if(habitability_class == HABITABILITY_IDEAL)
		atmosphere.adjust_gas(GAS_OXYGEN, MOLES_O2STANDARD, 0)
		atmosphere.adjust_gas(GAS_NITROGEN, MOLES_N2STANDARD)
	else //let the fuckery commence
		var/list/newgases = gas_data.gases.Copy()
		if(prob(90)) //all phoron planet should be rare
			newgases -= GAS_PHORON
		if(prob(50)) //alium gas should be slightly less common than mundane shit
			newgases -= GAS_ALIEN
		newgases -= GAS_STEAM

		var/total_moles = MOLES_CELLSTANDARD * rand(80,120)/100
		var/badflag = 0

		//Breathable planet
		if(habitability_class == HABITABILITY_OKAY)
			atmosphere.gas[GAS_OXYGEN] += MOLES_O2STANDARD
			total_moles -= MOLES_O2STANDARD
			badflag = XGM_GAS_FUEL|XGM_GAS_CONTAMINANT

		var/gasnum = rand(1,4)
		var/i = 1
		var/sanity = prob(99.9)
		while(i <= gasnum && total_moles && newgases.len)
			if(badflag && sanity)
				for(var/g in newgases)
					if(gas_data.flags[g] & badflag)
						newgases -= g
			var/ng = pick_n_take(newgases)	//pick a gas
			if(sanity) //make sure atmosphere is not flammable... always
				if(gas_data.flags[ng] & XGM_GAS_OXIDIZER)
					badflag |= XGM_GAS_FUEL
				if(gas_data.flags[ng] & XGM_GAS_FUEL)
					badflag |= XGM_GAS_OXIDIZER
				sanity = 0

			var/part = total_moles * rand(3,80)/100 //allocate percentage to it
			if(i == gasnum || !newgases.len) //if it's last gas, let it have all remaining moles
				part = total_moles
			atmosphere.gas[ng] += part
			total_moles = max(total_moles - part, 0)
			i++

/obj/effect/overmap/visitable/sector/exoplanet/get_scan_data(mob/user)
	. = ..()
	var/list/extra_data = list("<hr>")
	if(atmosphere)
		if(user.skill_check(SKILL_SCIENCE, SKILL_ADEPT))
			var/list/gases = list()
			for(var/g in atmosphere.gas)
				if(atmosphere.gas[g] > atmosphere.total_moles * 0.05)
					gases += gas_data.name[g]
			extra_data += "Atmosphere composition: [english_list(gases)]"
			var/inaccuracy = rand(8,12)/10
			extra_data += "Atmosphere pressure [atmosphere.return_pressure()*inaccuracy] kPa, temperature [atmosphere.temperature*inaccuracy] K"
		else if(user.skill_check(SKILL_SCIENCE, SKILL_BASIC))
			extra_data += "Atmosphere present"
		extra_data += "<hr>"

	if(seeds.len && user.skill_check(SKILL_SCIENCE, SKILL_BASIC))
		extra_data += "Xenoflora detected"

	if(animals.len && user.skill_check(SKILL_SCIENCE, SKILL_BASIC))
		extra_data += "Life traces detected"

	if(LAZYLEN(spawned_features) && user.skill_check(SKILL_SCIENCE, SKILL_ADEPT))
		var/ruin_num = 0
		for(var/datum/map_template/ruin/exoplanet/R in spawned_features)
			if(!(R.ruin_tags & RUIN_NATURAL))
				ruin_num++
		if(ruin_num)
			extra_data += "<hr>[ruin_num] possible artificial structure\s detected."

	. += jointext(extra_data, "<br>")

/obj/effect/overmap/visitable/sector/exoplanet/get_skybox_representation()
	return skybox_image

/obj/effect/overmap/visitable/sector/exoplanet/proc/get_base_image()
	var/image/base = image('icons/skybox/planet.dmi', "base")
	base.color = get_surface_color()
	return base

/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_planet_image()
	skybox_image = image('icons/skybox/planet.dmi', "")

	skybox_image.overlays += get_base_image()

	for(var/datum/exoplanet_theme/theme in themes)
		skybox_image.overlays += theme.get_planet_image_extra()

	if(water_color) //TODO: move water levels out of randommap into exoplanet
		var/image/water = image('icons/skybox/planet.dmi', "water")
		water.color = water_color
		water.appearance_flags = PIXEL_SCALE
		water.transform = water.transform.Turn(rand(0,360))
		skybox_image.overlays += water

	if(atmosphere && atmosphere.return_pressure() > SOUND_MINIMUM_PRESSURE)

		var/atmo_color = get_atmosphere_color()
		if(!atmo_color)
			atmo_color = COLOR_WHITE

		var/image/clouds = image('icons/skybox/planet.dmi', "weak_clouds")

		if(water_color)
			clouds.overlays += image('icons/skybox/planet.dmi', "clouds")

		clouds.color = atmo_color
		skybox_image.overlays += clouds

		var/image/atmo = image('icons/skybox/planet.dmi', "atmoring")
		skybox_image.underlays += atmo

	var/image/shadow = image('icons/skybox/planet.dmi', "shadow")
	shadow.blend_mode = BLEND_MULTIPLY
	skybox_image.overlays += shadow

	var/image/light = image('icons/skybox/planet.dmi', "lightrim")
	skybox_image.overlays += light

	if(prob(20))
		var/image/rings = image('icons/skybox/planet_rings.dmi')
		rings.icon_state = pick("sparse", "dense")
		rings.color = pick("#f0fcff", "#dcc4ad", "#d1dcad", "#adb8dc")
		rings.pixel_x = -128
		rings.pixel_y = -128
		skybox_image.overlays += rings

	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	skybox_image.appearance_flags = RESET_COLOR

/obj/effect/overmap/visitable/sector/exoplanet/proc/get_surface_color()
	return surface_color

/obj/effect/overmap/visitable/sector/exoplanet/proc/get_atmosphere_color()
	var/list/colors = list()
	for(var/g in atmosphere.gas)
		if(gas_data.tile_overlay_color[g])
			colors += gas_data.tile_overlay_color[g]
	if(colors.len)
		return MixColors(colors)

/area/exoplanet
	name = "\improper Planetary surface"
	ambience = list('sound/effects/wind/wind_2_1.ogg','sound/effects/wind/wind_2_2.ogg','sound/effects/wind/wind_3_1.ogg','sound/effects/wind/wind_4_1.ogg','sound/effects/wind/wind_4_2.ogg','sound/effects/wind/wind_5_1.ogg')
	always_unpowered = 1
