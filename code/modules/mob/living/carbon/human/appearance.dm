/mob/living/carbon/human/proc/change_appearance(flags, mob/user = src, datum/topic_state/state = GLOB.default_state)
	var/datum/nano_module/appearance_changer/changer = new(src, flags)
	changer.ui_interact(user, state = state)

/mob/living/carbon/human/proc/change_species(new_species)
	if(!new_species)
		return

	if(species == new_species)
		return

	if(!(new_species in all_species))
		return

	set_species(new_species)
	var/datum/antagonist/antag = mind && player_is_antag(mind)
	if (antag && antag.required_language)
		add_language(antag.required_language)
		set_default_language(all_languages[antag.required_language])
	reset_hair()
	return 1

/mob/living/carbon/human/proc/change_gender(gender)
	if(src.gender == gender)
		return
	src.gender = gender

	reset_hair()
	force_update_limbs()
	update_body()
	update_dna()
	src.sync_organ_dna()
	if(src.gender == MALE)
		src.UpdateAppearance()
	return 1

/mob/living/carbon/human/proc/randomize_gender()
	change_gender(pick(species.genders))

/mob/living/carbon/human/proc/change_pronouns(pronouns)
	if(src.pronouns == pronouns)
		return
	src.pronouns = pronouns
	return 1

/mob/living/carbon/human/proc/randomize_pronouns()
	change_pronouns(pick(species.pronouns))

/mob/living/carbon/human/proc/change_hair(new_head_hair_style)
	if(!new_head_hair_style)
		return

	if(head_hair_style == new_head_hair_style)
		return

	if(!(new_head_hair_style in GLOB.hair_styles_list))
		return

	head_hair_style = new_head_hair_style

	update_hair()
	return 1

/mob/living/carbon/human/proc/change_facial_hair(new_facial_hair_style)
	if(!new_facial_hair_style)
		return

	if(facial_hair_style == new_facial_hair_style)
		return

	if(!(new_facial_hair_style in GLOB.facial_hair_styles_list))
		return

	facial_hair_style = new_facial_hair_style

	update_hair()
	return 1

/mob/living/carbon/human/proc/reset_hair()
	var/list/valid_hairstyles = generate_valid_hairstyles()
	var/list/valid_facial_hairstyles = generate_valid_facial_hairstyles()

	if(length(valid_hairstyles))
		head_hair_style = pick(valid_hairstyles)
	else
		//this shouldn't happen
		head_hair_style = "Bald"

	if(length(valid_facial_hairstyles))
		facial_hair_style = pick(valid_facial_hairstyles)
	else
		//this shouldn't happen
		facial_hair_style = "Shaved"

	update_hair()

/mob/living/carbon/human/proc/change_eye_color(red, green, blue)
	var/new_eye_color = rgb(red, green, blue)
	if (eye_color == new_eye_color)
		return
	eye_color = new_eye_color
	update_eyes()
	update_body()
	return 1

/mob/living/carbon/human/proc/change_hair_color(red, green, blue)
	var/new_head_hair_color = rgb(red, green, blue)
	if (head_hair_color == new_head_hair_color)
		return
	head_hair_color = new_head_hair_color
	force_update_limbs()
	update_body()
	update_hair()
	return 1

/mob/living/carbon/human/proc/change_facial_hair_color(red, green, blue)
	var/new_facial_hair_color = rgb(red, green, blue)
	if (facial_hair_color == new_facial_hair_color)
		return
	facial_hair_color = new_facial_hair_color
	update_hair()
	return 1

/mob/living/carbon/human/proc/change_skin_color(red, green, blue)
	if (!(species.appearance_flags & SPECIES_APPEARANCE_HAS_SKIN_COLOR))
		return
	var/new_skin_color = rgb(red, green, blue)
	if (skin_color == new_skin_color)
		return
	skin_color = new_skin_color
	force_update_limbs()
	update_body()
	return 1

/mob/living/carbon/human/proc/change_skin_tone(new_skin_tone)
	if(skin_tone == new_skin_tone || !(species.appearance_flags & SPECIES_APPEARANCE_HAS_A_SKIN_TONE))
		return
	skin_tone = new_skin_tone
	force_update_limbs()
	update_body()
	return 1

/mob/living/carbon/human/proc/update_dna()
	check_dna()
	dna.ready_dna(src)

/mob/living/carbon/human/proc/generate_valid_languages()
	var/list/result = list()
	for (var/cult_key in cultural_info)
		var/singleton/cultural_info/culture = cultural_info[cult_key]
		if (!istype(culture))
			continue
		if (culture.language)
			result[culture.language] = all_languages[culture.language]
		if (culture.name_language)
			result[culture.name_language] = all_languages[culture.name_language]
		if (culture.default_language)
			result[culture.default_language] = all_languages[culture.default_language]
		for (var/lang_key in culture.secondary_langs)
			result[lang_key] = all_languages[lang_key]
		for (var/lang_key in culture.additional_langs)
			result[lang_key] = all_languages[lang_key]
	return result


/mob/living/carbon/human/proc/generate_valid_species(appearance_flags, list/allow, list/deny)
	var/list/result = list()
	for (var/name in all_species)
		if (name in deny)
			continue
		if (!appearance_flags)
			result += name
			continue
		if (name in allow)
			result += name
			continue
		var/datum/species/species = all_species[name]
		if (!(appearance_flags & APPEARANCE_SKIP_RESTRICTED_CHECK))
			if (species.spawn_flags & SPECIES_IS_RESTRICTED)
				continue
		if (!(appearance_flags & APPEARANCE_SKIP_ALLOW_LIST_CHECK))
			if (!is_alien_whitelisted(src, species))
				continue
		result += name
	return result


/mob/living/carbon/human/proc/generate_valid_hairstyles(check_gender = 1)
	. = list()
	var/list/hair_styles = species.get_hair_styles()
	for(var/hair_style in hair_styles)
		var/datum/sprite_accessory/S = hair_styles[hair_style]
		if(check_gender)
			if(gender == MALE && S.gender == FEMALE)
				continue
			if(gender == FEMALE && S.gender == MALE)
				continue
		.[hair_style] = S

/mob/living/carbon/human/proc/generate_valid_facial_hairstyles()
	return species.get_facial_hair_styles(gender)

/mob/living/carbon/human/proc/force_update_limbs()
	for(var/obj/item/organ/external/O in organs)
		O.sync_colour_to_human(src)
	update_body(0)
