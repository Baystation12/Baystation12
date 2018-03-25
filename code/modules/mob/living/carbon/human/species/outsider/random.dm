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
	if(prob(20))
		gluttonous |= pick(GLUT_ITEM_TINY, GLUT_ITEM_NORMAL, GLUT_ITEM_ANYTHING, GLUT_PROJECTILE_VOMIT)

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
	darksight = rand(0,8)
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