/mob/living/carbon/human/proc/change_appearance(flags, species, mob/user = src, datum/topic_state/state = GLOB.default_state)
	var/datum/nano_module/appearance_changer/changer = new(src, flags, species)
	changer.ui_interact(user, state = state)

/mob/living/carbon/human/proc/change_species(var/new_species)
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

/mob/living/carbon/human/proc/change_gender(var/gender)
	if(src.gender == gender)
		return

	src.gender = gender
	reset_hair()
	update_body()
	update_dna()
	return 1

/mob/living/carbon/human/proc/randomize_gender()
	change_gender(pick(species.genders))

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

	if(valid_hairstyles.len)
		head_hair_style = pick(valid_hairstyles)
	else
		//this shouldn't happen
		head_hair_style = "Bald"

	if(valid_facial_hairstyles.len)
		facial_hair_style = pick(valid_facial_hairstyles)
	else
		//this shouldn't happen
		facial_hair_style = "Shaved"

	update_hair()

/mob/living/carbon/human/proc/change_eye_color(var/red, var/green, var/blue)
	var/new_eye_color = rgb(red, green, blue)
	if (eye_color == new_eye_color)
		return
	eye_color = new_eye_color
	update_eyes()
	update_body()
	return 1

/mob/living/carbon/human/proc/change_hair_color(var/red, var/green, var/blue)
	var/new_head_hair_color = rgb(red, green, blue)
	if (head_hair_color == new_head_hair_color)
		return
	head_hair_color = new_head_hair_color
	force_update_limbs()
	update_body()
	update_hair()
	return 1

/mob/living/carbon/human/proc/change_facial_hair_color(var/red, var/green, var/blue)
	var/new_facial_hair_color = rgb(red, green, blue)
	if (facial_hair_color == new_facial_hair_color)
		return
	facial_hair_color = new_facial_hair_color
	update_hair()
	return 1

/mob/living/carbon/human/proc/change_skin_color(var/red, var/green, var/blue)
	if (!(species.appearance_flags & HAS_SKIN_COLOR))
		return
	var/new_skin_color = rgb(red, green, blue)
	if (skin_color == new_skin_color)
		return
	skin_color = new_skin_color
	force_update_limbs()
	update_body()
	return 1

/mob/living/carbon/human/proc/change_skin_tone(var/new_skin_tone)
	if(skin_tone == new_skin_tone || !(species.appearance_flags & HAS_A_SKIN_TONE))
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
		var/decl/cultural_info/culture = cultural_info[cult_key]
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

/mob/living/carbon/human/proc/generate_valid_species(var/check_whitelist = 1, var/list/whitelist = list(), var/list/blacklist = list())
	var/list/valid_species = new()
	for(var/current_species_name in all_species)
		var/datum/species/current_species = all_species[current_species_name]

		if(check_whitelist) //If we're using the whitelist, make sure to check it!
			if((current_species.spawn_flags & SPECIES_IS_RESTRICTED) && !check_rights(R_ADMIN, 0, src))
				continue
			if(!is_alien_whitelisted(src, current_species))
				continue
		if(whitelist.len && !(current_species_name in whitelist))
			continue
		if(blacklist.len && (current_species_name in blacklist))
			continue

		valid_species += current_species_name

	return valid_species

/mob/living/carbon/human/proc/generate_valid_hairstyles(var/check_gender = 1)
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
