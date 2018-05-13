/datum/species/alium
	name = "Humanoid"
	name_plural = "Humanoids"
	blurb = "Some alien humanoid species, unknown to humanity. How exciting."
	rarity_value = 5

	species_flags = SPECIES_FLAG_NO_SCAN

	icobase = 'icons/mob/human_races/r_humanoid.dmi' 
	deform = 'icons/mob/human_races/r_humanoid.dmi'
	appearance_flags = HAS_SKIN_COLOR
	limb_blend = ICON_MULTIPLY

	default_language = LANGUAGE_ALIUM
	language = LANGUAGE_ALIUM
	name_language = LANGUAGE_ALIUM

#define RANDOM_COEF(VAR,LO,HI) ##VAR =  round((##VAR*rand(##LO*100, ##HI*100))/100, 0.1)
/datum/species/alium/New()
	//Coloring
	blood_color = RANDOM_RGB
	flesh_color = RANDOM_RGB
	base_color  = RANDOM_RGB

	//Combat stats
	RANDOM_COEF(total_health, 0.8, 1.2)
	RANDOM_COEF(brute_mod, 0.5, 1.5)
	RANDOM_COEF(burn_mod, 0.8, 1.2)
	RANDOM_COEF(oxy_mod, 0.5, 1.5)
	RANDOM_COEF(toxins_mod, 0, 2)
	RANDOM_COEF(radiation_mod, 0, 2)
	RANDOM_COEF(flash_mod, 0.5, 1.5)

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
#undef RANDOM_COEF

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
		poison_type = pick_n_take(newgases)
	if(newgases.len)
		exhale_type = pick_n_take(newgases)