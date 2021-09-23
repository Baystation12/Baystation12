/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_flora()
	for (var/i = 1 to flora_diversity)
		var/datum/seed/S = new()
		S.randomize()
		var/planticon = "alien[rand(1,4)]"
		S.set_trait(TRAIT_PRODUCT_ICON,planticon)
		S.set_trait(TRAIT_PLANT_ICON,planticon)
		var/color = pick(plant_colors)
		if (color == "RANDOM")
			color = get_random_colour(0,75,190)
		S.set_trait(TRAIT_PLANT_COLOUR,color)
		var/carnivore_prob = rand(100)
		if (carnivore_prob < 10)
			S.set_trait(TRAIT_CARNIVOROUS,2)
			S.set_trait(TRAIT_SPREAD,1)
		else if (carnivore_prob < 20)
			S.set_trait(TRAIT_CARNIVOROUS,1)
		small_flora_types += S
	if (has_trees)
		var/tree_diversity = max(1,flora_diversity/2)
		for (var/i = 1 to tree_diversity)
			var/datum/seed/S = new()
			S.randomize()
			S.set_trait(TRAIT_PRODUCT_ICON,"alien[rand(1,5)]")
			S.set_trait(TRAIT_PLANT_ICON,"tree")
			S.set_trait(TRAIT_SPREAD,0)
			S.set_trait(TRAIT_HARVEST_REPEAT,1)
			S.set_trait(TRAIT_LARGE,1)
			var/color = pick(plant_colors)
			if (color == "RANDOM")
				color = get_random_colour(0,75,190)
			S.set_trait(TRAIT_LEAVES_COLOUR,color)
			S.chems[/datum/reagent/woodpulp] = 1
			big_flora_types += S

/obj/effect/overmap/visitable/sector/exoplanet/proc/adapt_seed(datum/seed/S)
	S.set_trait(TRAIT_IDEAL_HEAT,          atmosphere.temperature + rand(-5,5),800,70)
	S.set_trait(TRAIT_HEAT_TOLERANCE,      S.get_trait(TRAIT_HEAT_TOLERANCE) + rand(-5,5),800,70)
	S.set_trait(TRAIT_LOWKPA_TOLERANCE,    atmosphere.return_pressure() + rand(-5,-50),80,0)
	S.set_trait(TRAIT_HIGHKPA_TOLERANCE,   atmosphere.return_pressure() + rand(5,50),500,110)
	if (S.exude_gasses)
		S.exude_gasses -= badgas
	if (atmosphere)
		if (S.consume_gasses)
			S.consume_gasses = list(pick(atmosphere.gas)) // ensure that if the plant consumes a gas, the atmosphere will have it
		for (var/g in atmosphere.gas)
			if (gas_data.flags[g] & XGM_GAS_CONTAMINANT)
				S.set_trait(TRAIT_TOXINS_TOLERANCE, rand(10,15))
	if (prob(50))
		var/chem_type = SSchemistry.get_random_chem(TRUE, atmosphere ? atmosphere.temperature : T0C)
		if (chem_type)
			var/nutriment = S.chems[/datum/reagent/nutriment]
			S.chems.Cut()
			S.chems[/datum/reagent/nutriment] = nutriment
			S.chems[chem_type] = list(rand(1,10),rand(10,20))

/obj/effect/landmark/exoplanet_spawn/plant
	name = "spawn exoplanet plant"

/obj/effect/landmark/exoplanet_spawn/plant/do_spawn(var/obj/effect/overmap/visitable/sector/exoplanet/planet)
	if (LAZYLEN(planet.small_flora_types))
		new /obj/machinery/portable_atmospherics/hydroponics/soil/invisible(get_turf(src), pick(planet.small_flora_types), 1)

/obj/effect/landmark/exoplanet_spawn/large_plant
	name = "spawn exoplanet large plant"

/obj/effect/landmark/exoplanet_spawn/large_plant/do_spawn(var/obj/effect/overmap/visitable/sector/exoplanet/planet)
	if (LAZYLEN(planet.big_flora_types))
		new /obj/machinery/portable_atmospherics/hydroponics/soil/invisible(get_turf(src), pick(planet.big_flora_types), 1)