/datum/species/alium
	name = SPECIES_ALIEN
	name_plural = "Humanoids"
	description = "Some alien humanoid species, unknown to humanity. How exciting."
	rarity_value = 5

	species_flags = SPECIES_FLAG_NO_SCAN
	spawn_flags = SPECIES_IS_RESTRICTED

	icobase = 'icons/mob/human_races/species/humanoid/body.dmi'
	deform = 'icons/mob/human_races/species/humanoid/body.dmi'
	bandages_icon = 'icons/mob/bandage.dmi'
	appearance_flags = HAS_SKIN_COLOR
	limb_blend = ICON_MULTIPLY

	force_cultural_info = list(
		TAG_CULTURE = CULTURE_ALIUM
	)

	exertion_effect_chance = 10
	exertion_hydration_scale = 1
	exertion_reagent_scale = 5
	exertion_reagent_path = /datum/reagent/lactate
	exertion_emotes_biological = list(
		/decl/emote/exertion/biological,
		/decl/emote/exertion/biological/breath,
		/decl/emote/exertion/biological/pant
	)

/datum/species/alium/New()
	//Coloring
	blood_color = RANDOM_RGB
	flesh_color = RANDOM_RGB
	base_color  = RANDOM_RGB

	//Combat stats
	MULT_BY_RANDOM_COEF(total_health, 0.8, 1.2)
	MULT_BY_RANDOM_COEF(brute_mod, 0.5, 1.5)
	MULT_BY_RANDOM_COEF(burn_mod, 0.8, 1.2)
	MULT_BY_RANDOM_COEF(oxy_mod, 0.5, 1.5)
	MULT_BY_RANDOM_COEF(toxins_mod, 0, 2)
	MULT_BY_RANDOM_COEF(radiation_mod, 0, 2)
	MULT_BY_RANDOM_COEF(flash_mod, 0.5, 1.5)

	if(brute_mod < 1 && prob(40))
		species_flags |= SPECIES_FLAG_NO_MINOR_CUT
	if(brute_mod < 0.9 && prob(40))
		species_flags |= SPECIES_FLAG_NO_EMBED
	if(toxins_mod < 0.1)
		species_flags |= SPECIES_FLAG_NO_POISON

	//Gastronomic traits
	taste_sensitivity = pick(TASTE_HYPERSENSITIVE, TASTE_SENSITIVE, TASTE_DULL, TASTE_NUMB)
	gluttonous = pick(0, GLUT_TINY, GLUT_SMALLER, GLUT_ANYTHING)
	stomach_capacity = 5 * stomach_capacity
	if(prob(20))
		gluttonous |= pick(GLUT_ITEM_TINY, GLUT_ITEM_NORMAL, GLUT_ITEM_ANYTHING, GLUT_PROJECTILE_VOMIT)
		if(gluttonous & GLUT_ITEM_ANYTHING)
			stomach_capacity += ITEM_SIZE_HUGE

	//Environment
	var/temp_comfort_shift = rand(-50,50)
	cold_level_1 += temp_comfort_shift
	cold_level_2 += temp_comfort_shift
	cold_level_3 += temp_comfort_shift

	heat_level_1 += temp_comfort_shift
	heat_level_2 += temp_comfort_shift
	heat_level_3 += temp_comfort_shift

	heat_discomfort_level += temp_comfort_shift
	cold_discomfort_level += temp_comfort_shift

	body_temperature += temp_comfort_shift

	var/pressure_comfort_shift = rand(-50,50)
	hazard_high_pressure += pressure_comfort_shift
	warning_high_pressure += pressure_comfort_shift
	warning_low_pressure += pressure_comfort_shift
	hazard_low_pressure += pressure_comfort_shift

	//Misc traits
	darksight_range = rand(1,8)
	darksight_tint = pick(DARKTINT_NONE,DARKTINT_MODERATE,DARKTINT_GOOD)
	if(prob(40))
		genders = list(PLURAL)
	if(prob(10))
		slowdown += pick(-1,1)
	if(prob(10))
		species_flags |= SPECIES_FLAG_NO_SLIP
	if(prob(10))
		species_flags |= SPECIES_FLAG_NO_TANGLE
	if(prob(5))
		species_flags |= SPECIES_FLAG_NO_PAIN

	..()

/datum/species/alium/get_bodytype(var/mob/living/carbon/human/H)
	return SPECIES_HUMAN

/datum/species/alium/proc/adapt_to_atmosphere(var/datum/gas_mixture/atmosphere)
	var/temp_comfort_shift = atmosphere.temperature - body_temperature

	cold_level_1 += temp_comfort_shift
	cold_level_2 += temp_comfort_shift
	cold_level_3 += temp_comfort_shift

	heat_level_1 += temp_comfort_shift
	heat_level_2 += temp_comfort_shift
	heat_level_3 += temp_comfort_shift

	heat_discomfort_level += temp_comfort_shift
	cold_discomfort_level += temp_comfort_shift

	body_temperature += temp_comfort_shift

	var/normal_pressure = atmosphere.return_pressure()
	hazard_high_pressure = 5 * normal_pressure
	warning_high_pressure = 0.7 * hazard_high_pressure

	hazard_low_pressure = 0.2 * normal_pressure
	warning_low_pressure = 2.5 * hazard_low_pressure

	breath_type = pick(atmosphere.gas)
	breath_pressure = 0.8*(atmosphere.gas[breath_type]/atmosphere.total_moles)*normal_pressure

	var/list/newgases = gas_data.gases.Copy()
	newgases ^= atmosphere.gas
	for(var/gas in newgases)
		if(gas_data.flags[gas] & (XGM_GAS_OXIDIZER|XGM_GAS_FUEL))
			newgases -= gas
	if(newgases.len)
		poison_types = list(pick_n_take(newgases))
	if(newgases.len)
		exhale_type = pick_n_take(newgases)

/obj/structure/aliumizer
	name = "alien monolith"
	desc = "Your true form is calling. Use this to become an alien humanoid."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "ano51"
	anchored = TRUE

/obj/structure/aliumizer/attack_hand(mob/living/carbon/human/user)
	if(!istype(user))
		to_chat(user, "You got no business touching this.")
		return
	if(user.species.name == SPECIES_ALIEN)
		to_chat(user, "You're already a [SPECIES_ALIEN].")
		return
	if(alert("Are you sure you want to be an alien?", "Mom Look I'm An Alien!", "Yes", "No") == "No")
		to_chat(user, "Okie dokie.")
		return
	if(user && user.species.name == SPECIES_ALIEN) //no spamming it to get free implants
		return
	to_chat(user, "You're now an alien humanoid of some undiscovered species. Make up what lore you want, no one knows a thing about your species! You can check info about your traits with Check Species Info verb in IC tab.")
	to_chat(user, "You can't speak GalCom or any other languages by default. You can use translator implant that spawns on top of this monolith - it will give you knowledge of any language if you hear it enough times.")
	new/obj/item/implanter/translator(get_turf(src))
	user.set_species(SPECIES_ALIEN)
	var/decl/cultural_info/culture = user.get_cultural_value(TAG_CULTURE)
	user.fully_replace_character_name(culture.get_random_name(user.gender))
	user.rename_self("Humanoid Alien", 1)