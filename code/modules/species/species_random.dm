#define SETUP_RANDOM_COLOR_GETTER(X, Y, Z, W)  \
/datum/species/var/list/random_##Y = W;\
/datum/species/proc/get_random_##X(){\
	if(!(appearance_flags & Z) || !random_##Y.len){\
		return;\
	}\
	var/decl/color_generator/CG = decls_repository.get_decl(pickweight(random_##Y));\
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

SETUP_RANDOM_COLOR_GETTER(skin_color, skin_colors, HAS_SKIN_COLOR, list(
	/decl/color_generator/black,
	/decl/color_generator/grey,
	/decl/color_generator/brown,
	/decl/color_generator/chestnut,
	/decl/color_generator/blue,
	/decl/color_generator/blue_light,
	/decl/color_generator/green,
	/decl/color_generator/white))
SETUP_RANDOM_COLOR_SETTER(skin_color, change_skin_color)

SETUP_RANDOM_COLOR_GETTER(hair_color, hair_colors, HAS_HAIR_COLOR, list(
	/decl/color_generator/black,
	/decl/color_generator/blonde,
	/decl/color_generator/chestnut,
	/decl/color_generator/copper,
	/decl/color_generator/brown,
	/decl/color_generator/wheat,
	/decl/color_generator/old,
	/decl/color_generator/punk))
SETUP_RANDOM_COLOR_SETTER(hair_color, change_hair_color)

SETUP_RANDOM_COLOR_GETTER(eye_color, eye_colors, HAS_EYE_COLOR, list(
	/decl/color_generator/black,
	/decl/color_generator/grey,
	/decl/color_generator/brown,
	/decl/color_generator/chestnut,
	/decl/color_generator/blue,
	/decl/color_generator/blue_light,
	/decl/color_generator/green,
	/decl/color_generator/albino_eye))
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
	change_hair(safepick(generate_valid_hairstyles()))

/mob/living/carbon/human/proc/randomize_facial_hair_style()
	change_facial_hair(safepick(generate_valid_facial_hairstyles()))

#undef SETUP_RANDOM_COLOR_GETTER
