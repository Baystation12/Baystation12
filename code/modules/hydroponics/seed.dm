/datum/plantgene
	var/genetype    // Label used when applying trait.
	var/list/values // Values to copy into the target seed datum.

/datum/seed
	//Tracking.
	var/uid                        // Unique identifier.
	var/name                       // Index for global list.
	var/seed_name                  // Plant name for seed packet.
	var/seed_noun = SEED_NOUN_SEEDS// Descriptor for packet.
	var/display_name               // Prettier name.
	var/roundstart                 // If set, seed will not display variety number.
	var/mysterious                 // Only used for the random seed packets.
	var/scanned                    // If it was scanned with a plant analyzer.
	var/can_self_harvest = FALSE   // Mostly used for living mobs.
	var/growth_stages = 0          // Number of stages the plant passes through before it is mature.
	var/list/traits = list()       // Initialized in New()
	var/list/mutants               // Possible predefined mutant varieties, if any.
	var/list/chems                 // Chemicals that plant produces in products/injects into victim.
	var/list/consume_gasses        // The plant will absorb these gasses during its life.
	var/list/exude_gasses          // The plant will exude these gasses during its life.
	var/kitchen_tag                // Used by the reagent grinder.
	var/trash_type                 // Garbage item produced when eaten.
	var/splat_type = /obj/effect/decal/cleanable/fruit_smudge // Graffiti decal.
	var/has_mob_product
	var/force_layer
	var/req_CO2_moles    = 1.0// Moles of CO2 required for photosynthesis.
	var/fruit_size = ITEM_SIZE_SMALL

/datum/seed/New()

	set_trait(TRAIT_IMMUTABLE,            0)            // If set, plant will never mutate. If -1, plant is highly mutable.
	set_trait(TRAIT_HARVEST_REPEAT,       0)            // If 1, this plant will fruit repeatedly.
	set_trait(TRAIT_PRODUCES_POWER,       0)            // Can be used to make a battery.
	set_trait(TRAIT_JUICY,                0)            // When thrown, causes a splatter decal.
	set_trait(TRAIT_EXPLOSIVE,            0)            // When thrown, acts as a grenade.
	set_trait(TRAIT_CARNIVOROUS,          0)            // 0 = none, 1 = eat pests in tray, 2 = eat living things  (when a vine).
	set_trait(TRAIT_PARASITE,             0)            // 0 = no, 1 = gain health from weed level.
	set_trait(TRAIT_STINGS,               0)            // Can cause damage/inject reagents when thrown or handled.
	set_trait(TRAIT_YIELD,                0)            // Amount of product.
	set_trait(TRAIT_SPREAD,               0)            // 0 limits plant to tray, 1 = creepers, 2 = vines.
	set_trait(TRAIT_MATURATION,           0)            // Time taken before the plant is mature.
	set_trait(TRAIT_PRODUCTION,           0)            // Time before harvesting can be undertaken again.
	set_trait(TRAIT_TELEPORTING,          0)            // Uses the bluespace tomato effect.
	set_trait(TRAIT_BIOLUM,               0)            // Plant is bioluminescent.
	set_trait(TRAIT_ALTER_TEMP,           0)            // If set, the plant will periodically alter local temp by this amount.
	set_trait(TRAIT_PRODUCT_ICON,         0)            // Icon to use for fruit coming from this plant.
	set_trait(TRAIT_PLANT_ICON,           0)            // Icon to use for the plant growing in the tray.
	set_trait(TRAIT_PRODUCT_COLOUR,       0)            // Colour to apply to product icon.
	set_trait(TRAIT_BIOLUM_COLOUR,        0)            // The colour of the plant's radiance.
	set_trait(TRAIT_POTENCY,              1)            // General purpose plant strength value.
	set_trait(TRAIT_REQUIRES_NUTRIENTS,   1)            // The plant can starve.
	set_trait(TRAIT_REQUIRES_WATER,       1)            // The plant can become dehydrated.
	set_trait(TRAIT_WATER_CONSUMPTION,    3)            // Plant drinks this much per tick.
	set_trait(TRAIT_LIGHT_TOLERANCE,      3)            // Departure from ideal that is survivable.
	set_trait(TRAIT_TOXINS_TOLERANCE,     5)            // Resistance to poison.
	set_trait(TRAIT_PEST_TOLERANCE,       5)            // Threshold for pests to impact health.
	set_trait(TRAIT_WEED_TOLERANCE,       5)            // Threshold for weeds to impact health.
	set_trait(TRAIT_IDEAL_LIGHT,          5)            // Preferred light level in luminosity.
	set_trait(TRAIT_HEAT_TOLERANCE,       20)           // Departure from ideal that is survivable.
	set_trait(TRAIT_LOWKPA_TOLERANCE,     25)           // Low pressure capacity.
	set_trait(TRAIT_ENDURANCE,            100)          // Maximum plant HP when growing.
	set_trait(TRAIT_HIGHKPA_TOLERANCE,    200)          // High pressure capacity.
	set_trait(TRAIT_IDEAL_HEAT,           293)          // Preferred temperature in Kelvin.
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.25)         // Plant eats this much per tick.
	set_trait(TRAIT_PLANT_COLOUR,         "#46b543")    // Colour of the plant icon.
	set_trait(TRAIT_PHOTOSYNTHESIS,       1)            // If it turns CO2 into oxygen

	update_growth_stages()

	uid = sequential_id(/datum/seed/)

/datum/seed/proc/get_trait(var/trait)
	return traits["[trait]"]

/datum/seed/proc/get_trash_type()
	return trash_type

/datum/seed/proc/set_trait(var/trait,var/nval,var/ubound,var/lbound, var/degrade)
	if(!isnull(degrade)) nval *= degrade
	if(!isnull(ubound))  nval = min(nval,ubound)
	if(!isnull(lbound))  nval = max(nval,lbound)
	traits["[trait]"] =  nval

	if(trait == TRAIT_PLANT_ICON)
		update_growth_stages()

/datum/seed/proc/create_spores(var/turf/T)
	if(!T)
		return
	if(!istype(T))
		T = get_turf(T)
	if(!T)
		return

	var/datum/reagents/R = new/datum/reagents(100, GLOB.temp_reagents_holder)
	for(var/rid in chems)
		var/injecting = min(5,max(1,get_trait(TRAIT_POTENCY)/3))
		R.add_reagent(rid,injecting)

	var/datum/effect/effect/system/smoke_spread/chem/spores/S = new(name)
	S.attach(T)
	S.set_up(R, round(get_trait(TRAIT_POTENCY)/4), 0, T)
	S.start()
	qdel(R)

// Does brute damage to a target.
/datum/seed/proc/do_thorns(var/mob/living/carbon/human/target, var/obj/item/fruit, var/target_limb)

	if(!get_trait(TRAIT_CARNIVOROUS))
		return

	if(!istype(target))
		if(istype(target, /mob/living/simple_animal/passive/mouse))
			new /obj/item/remains/mouse(get_turf(target))
			qdel(target)
		else if(istype(target, /mob/living/simple_animal/passive/lizard))
			new /obj/item/remains/lizard(get_turf(target))
			qdel(target)
		return


	if(!target_limb) target_limb = pick(BP_ALL_LIMBS)
	var/obj/item/organ/external/affecting = target.get_organ(target_limb)

	if((target.species && target.species.species_flags & (SPECIES_FLAG_NO_EMBED|SPECIES_FLAG_NO_MINOR_CUT)))
		to_chat(target, "<span class='danger'>\The [fruit]'s thorns scratch against the armour on your [affecting.name]!</span>")
		return

	var/damage = 0
	var/has_edge = 0
	if(get_trait(TRAIT_CARNIVOROUS) >= 2)
		if(affecting)
			to_chat(target, "<span class='danger'>\The [fruit]'s thorns pierce your [affecting.name] greedily!</span>")
		else
			to_chat(target, "<span class='danger'>\The [fruit]'s thorns pierce your flesh greedily!</span>")
		damage = max(5, round(15*get_trait(TRAIT_POTENCY)/100, 1))
		has_edge = prob(get_trait(TRAIT_POTENCY)/2)
	else
		if(affecting)
			to_chat(target, "<span class='danger'>\The [fruit]'s thorns dig deeply into your [affecting.name]!</span>")
		else
			to_chat(target, "<span class='danger'>\The [fruit]'s thorns dig deeply into your flesh!</span>")
		damage = max(1, round(5*get_trait(TRAIT_POTENCY)/100, 1))
		has_edge = prob(get_trait(TRAIT_POTENCY)/5)

	var/damage_flags = DAM_SHARP|(has_edge? DAM_EDGE : 0)
	target.apply_damage(damage, BRUTE, target_limb, damage_flags, used_weapon = "Thorns")

// Adds reagents to a target.
/datum/seed/proc/do_sting(var/mob/living/carbon/human/target, var/obj/item/fruit)
	if(!get_trait(TRAIT_STINGS))
		return

	if(length(chems) && target.reagents && length(target.organs))

		var/obj/item/organ/external/affecting = pick(target.organs)
		if (!affecting)
			return

		for(var/obj/item/clothing/C in list(target.head, target.wear_mask, target.wear_suit, target.w_uniform, target.gloves, target.shoes))
			if(C && (C.body_parts_covered & affecting.body_part) && (C.item_flags & ITEM_FLAG_THICKMATERIAL))
				affecting = null

		if(!(target.species && target.species.species_flags & (SPECIES_FLAG_NO_EMBED|SPECIES_FLAG_NO_MINOR_CUT)))
			affecting = null

		if(affecting)
			to_chat(target, "<span class='danger'>You are stung by \the [fruit] in your [affecting.name]!</span>")
			for(var/rid in chems)
				var/injecting = min(5,max(1,get_trait(TRAIT_POTENCY)/5))
				target.reagents.add_reagent(rid,injecting)
		else
			to_chat(target, "<span class='danger'>Sharp spines scrape against your armour!</span>")

/datum/seed/proc/do_photosynthesis(var/turf/current_turf, var/datum/gas_mixture/environment, var/light_supplied)
	// Photosynthesis - *very* simplified process.
	// For now, only light-dependent reactions are available (no Calvin cycle).
	// It's active only for those plants which doesn't consume nor exude gasses.
	if(!get_trait(TRAIT_PHOTOSYNTHESIS))
		return
	if(!(environment) || !(environment.gas))
		return
	if(LAZYLEN(exude_gasses) || LAZYLEN(consume_gasses ))
		return
	if(!(light_supplied) || !(get_trait(TRAIT_REQUIRES_WATER)))
		return
	if(environment.get_gas(GAS_CO2) >= req_CO2_moles)
		environment.adjust_gas(GAS_CO2, -req_CO2_moles, 1)
		environment.adjust_gas(GAS_OXYGEN, req_CO2_moles, 1)

//Splatter a turf.
/datum/seed/proc/splatter(var/turf/T,var/obj/item/thrown)
	if(splat_type && !(locate(/obj/effect/vine) in T))
		var/obj/effect/vine/splat = new splat_type(T, src)
		if(!istype(splat)) // Plants handle their own stuff.
			splat.SetName("[thrown.name] [pick("smear","smudge","splatter")]")
			if(get_trait(TRAIT_BIOLUM))
				var/clr
				if(get_trait(TRAIT_BIOLUM_COLOUR))
					clr = get_trait(TRAIT_BIOLUM_COLOUR)
				splat.set_light(0.5, 0.1, 3, l_color = clr)
			var/flesh_colour = get_trait(TRAIT_FLESH_COLOUR)
			if(!flesh_colour) flesh_colour = get_trait(TRAIT_PRODUCT_COLOUR)
			if(flesh_colour) splat.color = get_trait(TRAIT_PRODUCT_COLOUR)

	if(chems)
		for(var/mob/living/M in T.contents)
			if(!M.reagents)
				continue
			var/body_coverage = HEAD|FACE|EYES|UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
			for(var/obj/item/clothing/clothes in M)
				if(M.l_hand == clothes || M.r_hand == clothes)
					continue
				body_coverage &= ~(clothes.body_parts_covered)
			if(!body_coverage)
				continue
			var/datum/reagents/R = M.reagents
			var/mob/living/carbon/human/H = M
			if(istype(H))
				R = H.touching
			if(istype(R))
				for(var/chem in chems)
					R.add_reagent(chem,min(5,max(1,get_trait(TRAIT_POTENCY)/3)))

//Applies an effect to a target atom.
/datum/seed/proc/thrown_at(var/obj/item/thrown,var/atom/target, var/force_explode)

	var/splatted
	var/turf/origin_turf = get_turf(target)

	if(force_explode || get_trait(TRAIT_EXPLOSIVE))

		create_spores(origin_turf)

		var/flood_dist = min(10,max(1,get_trait(TRAIT_POTENCY)/15))
		var/list/open_turfs = list()
		var/list/closed_turfs = list()
		var/list/valid_turfs = list()
		open_turfs |= origin_turf

		// Flood fill to get affected turfs.
		while(open_turfs.len)
			var/turf/T = pick(open_turfs)
			open_turfs -= T
			closed_turfs |= T
			valid_turfs |= T

			for(var/dir in GLOB.alldirs)
				var/turf/neighbor = get_step(T,dir)
				if(!neighbor || (neighbor in closed_turfs) || (neighbor in open_turfs))
					continue
				if(neighbor.density || get_dist(neighbor,origin_turf) > flood_dist || istype(neighbor,/turf/space))
					closed_turfs |= neighbor
					continue
				// Check for windows.
				var/no_los
				var/turf/last_turf = origin_turf
				for(var/turf/target_turf in getline(origin_turf,neighbor))
					if(!last_turf.Enter(target_turf) || target_turf.density)
						no_los = 1
						break
					last_turf = target_turf
				if(!no_los && !origin_turf.Enter(neighbor))
					no_los = 1
				if(no_los)
					closed_turfs |= neighbor
					continue
				open_turfs |= neighbor

		for(var/turf/T in valid_turfs)
			for(var/mob/living/M in T.contents)
				apply_special_effect(M)
			splatter(T,thrown)
		if(origin_turf)
			origin_turf.visible_message("<span class='danger'>The [thrown.name] explodes!</span>")
		qdel(thrown)
		return

	if(istype(target,/mob/living))
		splatted = apply_special_effect(target,thrown)
	else if(istype(target,/turf))
		splatted = 1
		for(var/mob/living/M in target.contents)
			apply_special_effect(M)

	if(get_trait(TRAIT_JUICY) && splatted)
		splatter(origin_turf,thrown)
		if(origin_turf)
			origin_turf.visible_message("<span class='danger'>The [thrown.name] splatters against [target]!</span>")
		qdel(thrown)

/datum/seed/proc/handle_environment(var/turf/current_turf, var/datum/gas_mixture/environment, var/light_supplied, var/check_only)

	var/health_change = 0
	// Handle gas consumption.
	if(consume_gasses && consume_gasses.len)
		var/missing_gas = 0
		for(var/gas in consume_gasses)
			if(environment && environment.gas && environment.gas[gas] && \
			 environment.gas[gas] >= consume_gasses[gas])
				if(!check_only)
					environment.adjust_gas(gas,-consume_gasses[gas],1)
			else
				missing_gas++

		if(missing_gas > 0)
			health_change += missing_gas * HYDRO_SPEED_MULTIPLIER

	// Process it.
	var/pressure = environment.return_pressure()
	if(pressure < get_trait(TRAIT_LOWKPA_TOLERANCE)|| pressure > get_trait(TRAIT_HIGHKPA_TOLERANCE))
		health_change += rand(1,3) * HYDRO_SPEED_MULTIPLIER

	if(abs(environment.temperature - get_trait(TRAIT_IDEAL_HEAT)) > get_trait(TRAIT_HEAT_TOLERANCE))
		health_change += rand(1,3) * HYDRO_SPEED_MULTIPLIER

	// Handle gas production.
	if(exude_gasses && exude_gasses.len && !check_only)
		for(var/gas in exude_gasses)
			environment.adjust_gas(gas, max(1,round((exude_gasses[gas]*(get_trait(TRAIT_POTENCY)/5))/exude_gasses.len)))

	//Handle temperature change.
	if(get_trait(TRAIT_ALTER_TEMP) != 0 && !check_only)
		var/target_temp = get_trait(TRAIT_ALTER_TEMP) > 0 ? 500 : 80
		if(environment && abs(environment.temperature-target_temp) > 0.1)
			var/datum/gas_mixture/removed = environment.remove(0.25 * environment.total_moles)
			if(removed)
				var/heat_transfer = abs(removed.get_thermal_energy_change(target_temp))
				heat_transfer = min(heat_transfer,abs(get_trait(TRAIT_ALTER_TEMP) * 10000))
				removed.add_thermal_energy((get_trait(TRAIT_ALTER_TEMP) > 0 ? 1 : -1) * heat_transfer)
			environment.merge(removed)

	// Handle light requirements.
	if(!light_supplied)
		light_supplied = current_turf.get_lumcount() * 5
	if(light_supplied)
		if(abs(light_supplied - get_trait(TRAIT_IDEAL_LIGHT)) > get_trait(TRAIT_LIGHT_TOLERANCE))
			health_change += rand(1,3) * HYDRO_SPEED_MULTIPLIER

	for(var/obj/effect/effect/smoke/chem/smoke in range(1, current_turf))
		if(smoke.reagents.has_reagent(/datum/reagent/toxin/plantbgone))
			return 100

	// Pressure and temperature are needed as much as water and light.
	// If any of the previous environment checks has failed
	// the photosynthesis cannot be triggered.
	if(health_change == 0)
		do_photosynthesis(current_turf, environment, light_supplied)

	return health_change

/datum/seed/proc/apply_special_effect(var/mob/living/target,var/obj/item/thrown)

	var/impact = 1
	do_sting(target,thrown)
	do_thorns(target,thrown)

	// Bluespace tomato code copied over from grown.dm.
	if(get_trait(TRAIT_TELEPORTING))

		//Plant potency determines radius of teleport.
		var/outer_teleport_radius = get_trait(TRAIT_POTENCY)/5
		var/inner_teleport_radius = get_trait(TRAIT_POTENCY)/15

		var/turf/T = get_random_turf_in_range(target, outer_teleport_radius, inner_teleport_radius)
		if(T)
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(3, 1, get_turf(target))
			s.start()
			new/obj/effect/decal/cleanable/molten_item(get_turf(target)) // Leave a pile of goo behind for dramatic effect...
			target.forceMove(T)                                     // And teleport them to the chosen location.
			impact = 1

	return impact

/datum/seed/proc/generate_name()
	var/prefix = ""
	var/name = ""
	if(prob(50)) //start with a prefix.
		//These are various plant/mushroom genuses.
		//I realize these might not be entirely accurate, but it could facilitate RP.
		var/list/possible_prefixes
		if(seed_noun == SEED_NOUN_CUTTINGS || seed_noun == SEED_NOUN_SEEDS || (seed_noun == SEED_NOUN_NODES && prob(50)))
			possible_prefixes = list("amelanchier", "saskatoon",
										"magnolia", "angiosperma", "osmunda", "scabiosa", "spigelia", "psydrax", "chastetree",
										"strychnos", "treebine", "caper", "justica", "ragwortus", "everlasting", "combretum",
										"loganiaceae", "gelsemium", "logania", "sabadilla", "neuburgia", "canthium", "rytigynia",
										"chaste", "vitex", "cissus", "capparis", "senecio", "curry", "cycad", "liverwort", "charophyta",
										"glaucophyte", "pinidae", "vascular", "embryophyte", "lillopsida")
		else
			possible_prefixes = list("bisporus", "bitorquis", "campestris", "crocodilinus", "agaricus",
									"armillaria", "matsutake", "mellea", "ponderosa", "auricularia", "auricala",
									"polytricha", "boletus", "badius", "edulis", "mirabilis", "zelleri",
									"calvatia", "gigantea", "clitopilis", "prumulus", "entoloma", "abortivum",
									"suillus", "tuber", "aestivum", "volvacea", "delica", "russula", "rozites")

		possible_prefixes |= list("butter", "shad", "sugar", "june", "wild", "rigus", "curry", "hard", "soft", "dark", "brick", "stone", "red", "brown",
								"black", "white", "paper", "slippery", "honey", "bitter")
		prefix = pick(possible_prefixes)

	var/num = rand(2,5)
	var/list/possible_name = list("rhon", "cus", "quam", "met", "eget", "was", "reg", "zor", "fra", "rat", "sho", "ghen", "pa",
								"eir", "lip", "sum", "lor", "em", "tem", "por", "invi", "dunt", "ut", "la", "bore", "mag", "na",
								"al", "i", "qu", "yam", "er", "at", "sed", "di", "am", "vol", "up", "tua", "at", "ve", "ro", "eos",
								"et", "ac", "cus")
	for(var/i in 1 to num)
		var/syl = pick(possible_name)
		possible_name -= syl
		name += syl

	if(prefix)
		name = "[prefix] [name]"
	seed_name = name
	display_name = name

//Creates a random seed. MAKE SURE THE LINE HAS DIVERGED BEFORE THIS IS CALLED.
/datum/seed/proc/randomize()

	roundstart = 0
	mysterious = 1
	seed_noun = pick(SEED_NOUN_SEEDS, SEED_NOUN_PITS, SEED_NOUN_NODES, SEED_NOUN_CUTTINGS)

	set_trait(TRAIT_POTENCY,rand(5,30),200,0)
	set_trait(TRAIT_PRODUCT_ICON,pick(SSplants.plant_product_sprites))
	set_trait(TRAIT_PLANT_ICON,pick(SSplants.plant_sprites))
	set_trait(TRAIT_PLANT_COLOUR,get_random_colour(0,75,190))
	set_trait(TRAIT_PRODUCT_COLOUR,get_random_colour(0,75,190))
	update_growth_stages()

	if(prob(20))
		set_trait(TRAIT_HARVEST_REPEAT,1)

	if(prob(15))
		if(prob(15))
			set_trait(TRAIT_JUICY,2)
		else
			set_trait(TRAIT_JUICY,1)

	if(prob(5))
		set_trait(TRAIT_STINGS,1)

	if(prob(5))
		set_trait(TRAIT_PRODUCES_POWER,1)

	if(prob(1))
		set_trait(TRAIT_EXPLOSIVE,1)
	else if(prob(1))
		set_trait(TRAIT_TELEPORTING,1)

	if(prob(5))
		consume_gasses = list()
		var/gas = pick(GAS_OXYGEN,GAS_NITROGEN,GAS_PHORON,GAS_CO2)
		consume_gasses[gas] = rand(3,9)

	if(prob(5))
		exude_gasses = list()
		var/gas = pick(GAS_OXYGEN,GAS_NITROGEN,GAS_PHORON,GAS_CO2)
		exude_gasses[gas] = rand(3,9)

	chems = list()
	if(prob(80))
		chems[/datum/reagent/nutriment] = list(rand(1,10),rand(10,20))

	var/additional_chems = rand(0,5)

	if(additional_chems)
		var/list/banned_chems = list(
			/datum/reagent/adminordrazine,
			/datum/reagent/nutriment,
			/datum/reagent/nanites,
			/datum/reagent/water/holywater,
			/datum/reagent/toxin/plantbgone,
			/datum/reagent/chloralhydrate/beer2,
			/datum/reagent/zombie
			)
		banned_chems += subtypesof(/datum/reagent/ethanol)
		banned_chems += subtypesof(/datum/reagent/zombie)
		banned_chems += subtypesof(/datum/reagent/tobacco)
		banned_chems += typesof(/datum/reagent/drink)
		banned_chems += typesof(/datum/reagent/nutriment)
		banned_chems += typesof(/datum/reagent/toxin/fertilizer)
		banned_chems += typesof(/datum/reagent/crayon_dust)

		if(prob(30))	banned_chems |= typesof(/datum/reagent/toxin)

		for(var/x=1;x<=additional_chems;x++)
			var/new_chem = pick(subtypesof(/datum/reagent))
			if(new_chem in banned_chems)
				x--
				continue
			banned_chems += new_chem
			chems[new_chem] = list(rand(1,10),rand(10,20))

	if(prob(90))
		set_trait(TRAIT_REQUIRES_NUTRIENTS,1)
		set_trait(TRAIT_NUTRIENT_CONSUMPTION,rand(25)/25)
	else
		set_trait(TRAIT_REQUIRES_NUTRIENTS,0)

	if(prob(90))
		set_trait(TRAIT_REQUIRES_WATER,1)
		set_trait(TRAIT_WATER_CONSUMPTION,rand(10))
	else
		set_trait(TRAIT_REQUIRES_WATER,0)

	set_trait(TRAIT_IDEAL_HEAT,       rand(100,400))
	set_trait(TRAIT_HEAT_TOLERANCE,   rand(10,30))
	set_trait(TRAIT_IDEAL_LIGHT,      rand(2,10))
	set_trait(TRAIT_LIGHT_TOLERANCE,  rand(2,7))
	set_trait(TRAIT_TOXINS_TOLERANCE, rand(2,7))
	set_trait(TRAIT_PEST_TOLERANCE,   rand(2,7))
	set_trait(TRAIT_WEED_TOLERANCE,   rand(2,7))
	set_trait(TRAIT_LOWKPA_TOLERANCE, rand(10,50))
	set_trait(TRAIT_HIGHKPA_TOLERANCE,rand(100,300))

	if(prob(5))
		set_trait(TRAIT_ALTER_TEMP,rand(-5,5))

	if(prob(1))
		set_trait(TRAIT_IMMUTABLE,-1)

	var/carnivore_prob = rand(100)
	if(carnivore_prob < 5)
		set_trait(TRAIT_CARNIVOROUS,2)
	else if(carnivore_prob < 10)
		set_trait(TRAIT_CARNIVOROUS,1)

	if(prob(10))
		set_trait(TRAIT_PARASITE,1)

	var/vine_prob = rand(100)
	if(vine_prob < 5)
		set_trait(TRAIT_SPREAD,2)
	else if(vine_prob < 10)
		set_trait(TRAIT_SPREAD,1)

	if(prob(5))
		set_trait(TRAIT_BIOLUM,1)
		set_trait(TRAIT_BIOLUM_COLOUR,get_random_colour(0,75,190))

	set_trait(TRAIT_ENDURANCE,rand(60,100))
	set_trait(TRAIT_YIELD,rand(3,15))
	set_trait(TRAIT_MATURATION,rand(5,15))
	set_trait(TRAIT_PRODUCTION,rand(1,10))

	generate_name()

//Returns a key corresponding to an entry in the global seed list.
/datum/seed/proc/get_mutant_variant()
	if(!mutants || !mutants.len || get_trait(TRAIT_IMMUTABLE) > 0) return 0
	return pick(mutants)

//Mutates the plant overall (randomly).
/datum/seed/proc/mutate(var/degree,var/turf/source_turf)

	if(!degree || get_trait(TRAIT_IMMUTABLE) > 0) return

	source_turf.visible_message("<span class='notice'>\The [display_name] quivers!</span>")

	//This looks like shit, but it's a lot easier to read/change this way.
	var/total_mutations = rand(1,1+degree)
	for(var/i = 0;i<total_mutations;i++)
		switch(rand(0,11))
			if(0) //Plant cancer!
				set_trait(TRAIT_ENDURANCE,get_trait(TRAIT_ENDURANCE)-rand(10,20),null,0)
				source_turf.visible_message("<span class='danger'>\The [display_name] withers rapidly!</span>")
			if(1)
				set_trait(TRAIT_NUTRIENT_CONSUMPTION,get_trait(TRAIT_NUTRIENT_CONSUMPTION)+rand(-(degree*0.1),(degree*0.1)),5,0)
				set_trait(TRAIT_WATER_CONSUMPTION,   get_trait(TRAIT_WATER_CONSUMPTION)   +rand(-degree,degree),50,0)
				set_trait(TRAIT_JUICY,              !get_trait(TRAIT_JUICY))
				set_trait(TRAIT_STINGS,             !get_trait(TRAIT_STINGS))
			if(2)
				set_trait(TRAIT_IDEAL_HEAT,          get_trait(TRAIT_IDEAL_HEAT) +      (rand(-5,5)*degree),800,70)
				set_trait(TRAIT_HEAT_TOLERANCE,      get_trait(TRAIT_HEAT_TOLERANCE) +  (rand(-5,5)*degree),800,70)
				set_trait(TRAIT_LOWKPA_TOLERANCE,    get_trait(TRAIT_LOWKPA_TOLERANCE)+ (rand(-5,5)*degree),80,0)
				set_trait(TRAIT_HIGHKPA_TOLERANCE,   get_trait(TRAIT_HIGHKPA_TOLERANCE)+(rand(-5,5)*degree),500,110)
				set_trait(TRAIT_EXPLOSIVE,1)
			if(3)
				set_trait(TRAIT_IDEAL_LIGHT,         get_trait(TRAIT_IDEAL_LIGHT)+(rand(-1,1)*degree),30,0)
				set_trait(TRAIT_LIGHT_TOLERANCE,     get_trait(TRAIT_LIGHT_TOLERANCE)+(rand(-2,2)*degree),10,0)
			if(4)
				set_trait(TRAIT_TOXINS_TOLERANCE,    get_trait(TRAIT_TOXINS_TOLERANCE)+(rand(-2,2)*degree),10,0)
			if(5)
				set_trait(TRAIT_WEED_TOLERANCE,      get_trait(TRAIT_WEED_TOLERANCE)+(rand(-2,2)*degree),10, 0)
				if(prob(degree*5))
					set_trait(TRAIT_CARNIVOROUS,     get_trait(TRAIT_CARNIVOROUS)+rand(-degree,degree),2, 0)
					if(get_trait(TRAIT_CARNIVOROUS))
						source_turf.visible_message("<span class='notice'>\The [display_name] shudders hungrily.</span>")
			if(6)
				set_trait(TRAIT_WEED_TOLERANCE,      get_trait(TRAIT_WEED_TOLERANCE)+(rand(-2,2)*degree),10, 0)
				if(prob(degree*5))
					set_trait(TRAIT_PARASITE,!get_trait(TRAIT_PARASITE))
			if(7)
				if(get_trait(TRAIT_YIELD) != -1)
					set_trait(TRAIT_YIELD,           get_trait(TRAIT_YIELD)+(rand(-2,2)*degree),10,0)
			if(8)
				set_trait(TRAIT_ENDURANCE,           get_trait(TRAIT_ENDURANCE)+(rand(-5,5)*degree),100,10)
				set_trait(TRAIT_PRODUCTION,          get_trait(TRAIT_PRODUCTION)+(rand(-1,1)*degree),10, 1)
				set_trait(TRAIT_POTENCY,             get_trait(TRAIT_POTENCY)+(rand(-20,20)*degree),200, 0)
				if(prob(degree*5))
					set_trait(TRAIT_SPREAD,          get_trait(TRAIT_SPREAD)+rand(-1,1),2, 0)
					source_turf.visible_message("<span class='notice'>\The [display_name] spasms visibly, shifting in the tray.</span>")
			if(9)
				set_trait(TRAIT_MATURATION,          get_trait(TRAIT_MATURATION)+(rand(-1,1)*degree),30, 0)
				if(prob(degree*5))
					set_trait(TRAIT_HARVEST_REPEAT, !get_trait(TRAIT_HARVEST_REPEAT))
			if(10)
				if(prob(degree*2))
					set_trait(TRAIT_BIOLUM,         !get_trait(TRAIT_BIOLUM))
					if(get_trait(TRAIT_BIOLUM))
						source_turf.visible_message("<span class='notice'>\The [display_name] begins to glow!</span>")
						if(prob(degree*2))
							set_trait(TRAIT_BIOLUM_COLOUR,get_random_colour(0,75,190))
							source_turf.visible_message("<span class='notice'>\The [display_name]'s glow </span><font color='[get_trait(TRAIT_BIOLUM_COLOUR)]'>changes colour</font>!")
					else
						source_turf.visible_message("<span class='notice'>\The [display_name]'s glow dims...</span>")
			if(11)
				set_trait(TRAIT_TELEPORTING,1)

	return

//Mutates a specific trait/set of traits.
/datum/seed/proc/apply_gene(var/datum/plantgene/gene)

	if(!gene || !gene.values || get_trait(TRAIT_IMMUTABLE) > 0) return

	// Splicing products has some detrimental effects on yield and lifespan.
	// We handle this before we do the rest of the looping, as normal traits don't really include lists.
	switch(gene.genetype)
		if(GENE_BIOCHEMISTRY)
			for(var/trait in list(TRAIT_YIELD, TRAIT_ENDURANCE))
				if(get_trait(trait) > 0) set_trait(trait,get_trait(trait),null,1,0.85)

			LAZYINITLIST(chems)

			var/list/gene_value = gene.values["[TRAIT_CHEMS]"]
			for(var/rid in gene_value)

				var/list/gene_chem = gene_value[rid]

				if(!chems[rid])
					chems[rid] = gene_chem.Copy()
					continue

				for(var/i=1;i<=gene_chem.len;i++)

					if(isnull(gene_chem[i])) gene_chem[i] = 0

					if(chems[rid][i])
						chems[rid][i] = max(1,round((gene_chem[i] + chems[rid][i])/2))
					else
						chems[rid][i] = gene_chem[i]

			var/list/new_gasses = gene.values["[TRAIT_EXUDE_GASSES]"]
			if(islist(new_gasses))
				if(!exude_gasses) exude_gasses = list()
				exude_gasses |= new_gasses
				for(var/gas in exude_gasses)
					exude_gasses[gas] = max(1,round(exude_gasses[gas]*0.8))

			gene.values["[TRAIT_EXUDE_GASSES]"] = null
			gene.values["[TRAIT_CHEMS]"] = null

		if(GENE_DIET)
			var/list/new_gasses = gene.values["[TRAIT_CONSUME_GASSES]"]
			consume_gasses |= new_gasses
			gene.values["[TRAIT_CONSUME_GASSES]"] = null
		if(GENE_METABOLISM)
			has_mob_product = gene.values["mob_product"]
			gene.values["mob_product"] = null

	for(var/trait in gene.values)
		set_trait(trait,gene.values["[trait]"])

	update_growth_stages()

//Returns a list of the desired trait values.
/datum/seed/proc/get_gene(var/genetype)

	if(!genetype) return 0

	var/list/traits_to_copy
	var/datum/plantgene/P = new()
	P.genetype = genetype
	P.values = list()

	switch(genetype)
		if(GENE_BIOCHEMISTRY)
			P.values["[TRAIT_CHEMS]"] =        chems
			P.values["[TRAIT_EXUDE_GASSES]"] = exude_gasses
			traits_to_copy = list(TRAIT_POTENCY)
		if(GENE_OUTPUT)
			traits_to_copy = list(TRAIT_PRODUCES_POWER,TRAIT_BIOLUM)
		if(GENE_ATMOSPHERE)
			traits_to_copy = list(TRAIT_HEAT_TOLERANCE,TRAIT_LOWKPA_TOLERANCE,TRAIT_HIGHKPA_TOLERANCE)
		if(GENE_HARDINESS)
			traits_to_copy = list(TRAIT_TOXINS_TOLERANCE,TRAIT_PEST_TOLERANCE,TRAIT_WEED_TOLERANCE,TRAIT_ENDURANCE)
		if(GENE_METABOLISM)
			P.values["mob_product"] = has_mob_product
			traits_to_copy = list(TRAIT_REQUIRES_NUTRIENTS,TRAIT_REQUIRES_WATER,TRAIT_ALTER_TEMP)
		if(GENE_VIGOUR)
			traits_to_copy = list(TRAIT_PRODUCTION,TRAIT_MATURATION,TRAIT_YIELD,TRAIT_SPREAD)
		if(GENE_DIET)
			P.values["[TRAIT_CONSUME_GASSES]"] = consume_gasses
			traits_to_copy = list(TRAIT_CARNIVOROUS,TRAIT_PARASITE,TRAIT_NUTRIENT_CONSUMPTION,TRAIT_WATER_CONSUMPTION)
		if(GENE_ENVIRONMENT)
			traits_to_copy = list(TRAIT_IDEAL_HEAT,TRAIT_IDEAL_LIGHT,TRAIT_LIGHT_TOLERANCE)
		if(GENE_PIGMENT)
			traits_to_copy = list(TRAIT_PLANT_COLOUR,TRAIT_PRODUCT_COLOUR,TRAIT_BIOLUM_COLOUR,TRAIT_LEAVES_COLOUR)
		if(GENE_STRUCTURE)
			traits_to_copy = list(TRAIT_PLANT_ICON,TRAIT_PRODUCT_ICON,TRAIT_HARVEST_REPEAT,TRAIT_LARGE)
		if(GENE_FRUIT)
			traits_to_copy = list(TRAIT_STINGS,TRAIT_EXPLOSIVE,TRAIT_FLESH_COLOUR,TRAIT_JUICY)
		if(GENE_SPECIAL)
			traits_to_copy = list(TRAIT_TELEPORTING)

	for(var/trait in traits_to_copy)
		P.values["[trait]"] = get_trait(trait)
	return (P ? P : 0)

//Place the plant products at the feet of the user.
/datum/seed/proc/harvest(var/mob/user,var/yield_mod,var/harvest_sample,var/force_amount)

	if(!user)
		return

	if(!force_amount && get_trait(TRAIT_YIELD) == 0 && !harvest_sample)
		if(istype(user)) to_chat(user, "<span class='danger'>You fail to harvest anything useful.</span>")
	else
		if(istype(user)) to_chat(user, "You [harvest_sample ? "take a sample" : "harvest"] from the [display_name].")
		//This may be a new line. Update the global if it is.
		if(name == "new line" || !(name in SSplants.seeds))
			uid = SSplants.seeds.len + 1
			name = "[uid]"
			SSplants.seeds[name] = src

		if(harvest_sample)
			var/obj/item/seeds/seeds = new(get_turf(user))
			seeds.seed_type = name
			seeds.update_seed()
			return

		var/total_yield = 0
		if(!isnull(force_amount))
			total_yield = force_amount
		else
			if(get_trait(TRAIT_YIELD) > -1)
				if(isnull(yield_mod) || yield_mod < 1)
					yield_mod = 0
					total_yield = get_trait(TRAIT_YIELD)
				else
					total_yield = get_trait(TRAIT_YIELD) + rand(yield_mod)
				total_yield = max(1,total_yield)

		. = list()
		for(var/i = 0;i<total_yield;i++)
			var/obj/item/product
			if(has_mob_product)
				product = new has_mob_product(get_turf(user),name)
			else
				product = new /obj/item/reagent_containers/food/snacks/grown(get_turf(user),name)
				product.w_class = fruit_size
			. += product

			if(get_trait(TRAIT_PRODUCT_COLOUR))
				if(!istype(product, /mob))
					product.color = get_trait(TRAIT_PRODUCT_COLOUR)
					if(istype(product,/obj/item/reagent_containers/food))
						var/obj/item/reagent_containers/food/food = product
						food.filling_color = get_trait(TRAIT_PRODUCT_COLOUR)

			if(mysterious)
				product.name += "?"
				product.desc += " On second thought, something about this one looks strange."

			if(get_trait(TRAIT_BIOLUM))
				var/clr
				if(get_trait(TRAIT_BIOLUM_COLOUR))
					clr = get_trait(TRAIT_BIOLUM_COLOUR)
				product.set_light(0.5, 0.1, 3, l_color = clr)

			//Handle spawning in living, mobile products (like dionaea).
			if(istype(product,/mob/living))
				product.visible_message("<span class='notice'>The pod disgorges [product]!</span>")
				handle_living_product(product)
				if(istype(product,/mob/living/simple_animal/passive/mushroom)) // Gross.
					var/mob/living/simple_animal/passive/mushroom/mush = product
					mush.seed = src

// When the seed in this machine mutates/is modified, the tray seed value
// is set to a new datum copied from the original. This datum won't actually
// be put into the global datum list until the product is harvested, though.
/datum/seed/proc/diverge(var/modified)

	if(get_trait(TRAIT_IMMUTABLE) > 0) return

	//Set up some basic information.
	var/datum/seed/new_seed = new
	new_seed.name =            "new line"
	new_seed.uid =              0
	new_seed.roundstart =       0
	new_seed.can_self_harvest = can_self_harvest
	new_seed.kitchen_tag =      kitchen_tag
	new_seed.trash_type =       trash_type
	new_seed.has_mob_product =  has_mob_product
	//Copy over everything else.
	if(mutants)        new_seed.mutants = mutants.Copy()
	if(chems)          new_seed.chems = chems.Copy()
	if(consume_gasses) new_seed.consume_gasses = consume_gasses.Copy()
	if(exude_gasses)   new_seed.exude_gasses = exude_gasses.Copy()

	new_seed.seed_name =            "[(roundstart ? "[(modified ? "modified" : "mutant")] " : "")][seed_name]"
	new_seed.display_name =         "[(roundstart ? "[(modified ? "modified" : "mutant")] " : "")][display_name]"
	new_seed.seed_noun =            seed_noun
	new_seed.traits = traits.Copy()
	new_seed.update_growth_stages()
	return new_seed

/datum/seed/proc/update_growth_stages()
	if(get_trait(TRAIT_PLANT_ICON))
		growth_stages = SSplants.plant_sprites[get_trait(TRAIT_PLANT_ICON)]
	else
		growth_stages = 0

/datum/seed/proc/get_growth_type()
	if(get_trait(TRAIT_SPREAD) == 2)
		switch(seed_noun)
			if(SEED_NOUN_CUTTINGS)
				return GROWTH_WORMS
			if(SEED_NOUN_NODES)
				return GROWTH_BIOMASS
			if(SEED_NOUN_SPORES)
				return GROWTH_MOLD
			else
				return GROWTH_VINES
	return 0

/datum/seed/proc/get_icon(growth_stage)
	var/plant_icon = get_trait(TRAIT_PLANT_ICON)
	var/image/res = image('icons/obj/hydroponics_growing.dmi', "[plant_icon]-[growth_stage]")
	if(get_growth_type())
		res.icon_state = "[get_growth_type()]-[growth_stage]"
	else
		res.icon_state = "[plant_icon]-[growth_stage]"

	if(get_growth_type())
		res.icon = 'icons/obj/hydroponics_vines.dmi'

	res.color = get_trait(TRAIT_PLANT_COLOUR)

	if(get_trait(TRAIT_LARGE))
		res.icon = 'icons/obj/hydroponics_large.dmi'
		res.pixel_x = -8
		res.pixel_y = -16

	var/leaves = get_trait(TRAIT_LEAVES_COLOUR)
	if(leaves)
		var/image/I = image(res.icon, "[plant_icon]-[growth_stage]-leaves")
		I.color = leaves
		I.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
		res.overlays += I

	return res
