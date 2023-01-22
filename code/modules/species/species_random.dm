#define SETUP_RANDOM_COLOR_GETTER(X, Y, Z, W)  \
/datum/species/var/list/random_##Y = W;\
/datum/species/proc/get_random_##X(){\
	if(!(appearance_flags & Z) || !length(random_##Y)){\
		return;\
	}\
	var/selection = pickweight(random_##Y);\
	var/singleton/color_generator/CG = GET_SINGLETON(selection);\
	return CG && CG.GenerateRGB();\
}

#define SETUP_RANDOM_COLOR_SETTER(X, Y)\
/mob/living/carbon/human/proc/randomize_##X(){\
	if(!species){\
		return;\
	}\
	var/colors = species.get_random_##X();\
	if(colors){\
		Y(colors[1], colors[2], colors[3]);\
	}\
}

SETUP_RANDOM_COLOR_GETTER(skin_color, skin_colors, SPECIES_APPEARANCE_HAS_SKIN_COLOR, list(
	/singleton/color_generator/black,
	/singleton/color_generator/grey,
	/singleton/color_generator/brown,
	/singleton/color_generator/chestnut,
	/singleton/color_generator/blue,
	/singleton/color_generator/blue_light,
	/singleton/color_generator/green,
	/singleton/color_generator/white))
SETUP_RANDOM_COLOR_SETTER(skin_color, change_skin_color)

SETUP_RANDOM_COLOR_GETTER(hair_color, hair_colors, SPECIES_APPEARANCE_HAS_HAIR_COLOR, list(
	/singleton/color_generator/black,
	/singleton/color_generator/blonde,
	/singleton/color_generator/chestnut,
	/singleton/color_generator/copper,
	/singleton/color_generator/brown,
	/singleton/color_generator/wheat,
	/singleton/color_generator/old,
	/singleton/color_generator/punk))
SETUP_RANDOM_COLOR_SETTER(hair_color, change_hair_color)

SETUP_RANDOM_COLOR_GETTER(eye_color, eye_colors, SPECIES_APPEARANCE_HAS_EYE_COLOR, list(
	/singleton/color_generator/black,
	/singleton/color_generator/grey,
	/singleton/color_generator/brown,
	/singleton/color_generator/chestnut,
	/singleton/color_generator/blue,
	/singleton/color_generator/blue_light,
	/singleton/color_generator/green,
	/singleton/color_generator/albino_eye))
SETUP_RANDOM_COLOR_SETTER(eye_color, change_eye_color)

/datum/species/proc/get_random_facial_hair_color()
	return get_random_hair_color()

SETUP_RANDOM_COLOR_SETTER(facial_hair_color, change_facial_hair_color)

/datum/species/proc/get_random_skin_tone()
	return random_skin_tone(src)

/mob/living/carbon/human/proc/randomize_skin_tone()
	if(!species)
		return
	var/new_tone = species.get_random_skin_tone()
	if(!isnull(new_tone))
		change_skin_tone(new_tone)

/mob/living/carbon/human/proc/randomize_hair_style()
	change_hair(DEFAULTPICK(generate_valid_hairstyles(), null))

/mob/living/carbon/human/proc/randomize_facial_hair_style()
	change_facial_hair(DEFAULTPICK(generate_valid_facial_hairstyles(), null))

#undef SETUP_RANDOM_COLOR_GETTER
