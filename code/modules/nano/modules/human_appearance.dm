/datum/nano_module/appearance_changer
	name = "Appearance Editor"
	available_to_ai = FALSE
	var/flags
	var/mob/living/carbon/human/owner
	var/list/races
	var/list/heads
	var/list/faces
	var/list/langs


/datum/nano_module/appearance_changer/Destroy()
	owner = null
	races = null
	heads = null
	faces = null
	langs = null
	. = ..()


/datum/nano_module/appearance_changer/New(mob/living/carbon/human/_owner, _flags, _races)
	..(_owner, null)
	owner = _owner
	flags = _flags
	if (flags & APPEARANCE_RACE)
		if (islist(_races))
			races = _races
		else
			races = owner.generate_valid_species(_races)
	generate_data()


/datum/nano_module/appearance_changer/proc/generate_data()
	heads = owner.generate_valid_hairstyles()
	faces = owner.generate_valid_facial_hairstyles()
	if (~flags & APPEARANCE_LANG_ANY_ORIGIN)
		langs = owner.generate_valid_languages()


/datum/nano_module/appearance_changer/Topic(href, list/href_list, datum/topic_state/state = GLOB.default_state)
	. = ..()
	if (.)
		return
	if (QDELETED(owner))
		return

	if (href_list["race"] && (flags & APPEARANCE_RACE) && (!races || (href_list["race"] in races)))
		owner.change_species(href_list["race"])
		generate_data()
		return TRUE

	if (href_list["gender"] && (flags & APPEARANCE_GENDER) && (href_list["gender"] in owner.species.genders))
		owner.change_gender(href_list["gender"])
		generate_data()
		return TRUE

	if (href_list["skin_tone"] && (flags & APPEARANCE_SKIN) && (owner.species.appearance_flags & HAS_A_SKIN_TONE))
		var/high = owner.species.max_skin_tone()
		var/data = input(usr, "Skin Tone:\n1 (pale) ~ [high] (dark)", "Skin Tone", 35 - owner.skin_tone) as null | num
		if (isnull(data) || !can_still_topic(state))
			return
		data = 35 - max(min(round(data), high), 1)
		return owner.change_skin_tone(data)

	if (href_list["skin_color"] && (flags & APPEARANCE_SKIN) && (owner.species.appearance_flags & HAS_SKIN_COLOR))
		var/color = owner.skin_color
		var/data = input(usr, "Skin Color:", "Skin Color", color) as null | color
		if (isnull(data) || !can_still_topic(state))
			return
		color = rgb2num(data)
		if (owner.change_skin_color(arglist(color)))
			if (flags & APPEARANCE_DNA2)
				owner.update_dna()
			return TRUE
		return

	if (href_list["hair"] && (flags & APPEARANCE_HEAD) && (href_list["hair"] in heads))
		if (owner.change_hair(href_list["hair"]))
			if (flags & APPEARANCE_DNA2)
				owner.update_dna()
			return TRUE
		return

	if (href_list["hair_color"] && (flags & APPEARANCE_HEAD_COLOR))
		var/color = owner.head_hair_color
		var/data = input(usr, "Hair Color:", "Hair Color", color) as null | color
		if (isnull(data) || !can_still_topic(state))
			return
		color = rgb2num(data)
		if (owner.change_hair_color(arglist(color)))
			if (flags & APPEARANCE_DNA2)
				owner.update_dna()
			return TRUE
		return

	if (href_list["facial_hair"] && (flags & APPEARANCE_FACE) && (href_list["facial_hair"] in faces))
		if (owner.change_facial_hair(href_list["facial_hair"]))
			if (flags & APPEARANCE_DNA2)
				owner.update_dna()
			return TRUE
		return

	if (href_list["facial_hair_color"] && (flags & APPEARANCE_FACE_COLOR))
		var/color = owner.facial_hair_color
		var/data = input(usr, "Facial Hair Color:", "Facial Hair Color", color) as null | color
		if (isnull(data) || !can_still_topic(state))
			return
		color = rgb2num(data)
		if (owner.change_facial_hair_color(arglist(color)))
			if (flags & APPEARANCE_DNA2)
				owner.update_dna()
			return TRUE
		return

	if (href_list["eye_color"] && (flags & APPEARANCE_EYES))
		var/color = owner.eye_color
		var/data = input(usr, "Eye Color:", "Eye Color", color) as null | color
		if (isnull(data) || !can_still_topic(state))
			return
		color = rgb2num(data)
		if (owner.change_eye_color(arglist(color)))
			if (flags & APPEARANCE_DNA2)
				owner.update_dna()
			return TRUE
		return

	if (href_list["language"] && (flags & APPEARANCE_LANG))
		if (href_list["language_mode"] == "add")
			if ((~flags & APPEARANCE_LANG_ANY_NUMBER) && length(owner.languages) >= MAX_LANGUAGES)
				return
			if ((~flags & APPEARANCE_LANG_ANY_ORIGIN) && !(href_list["language"] in langs))
				return
			if (owner.add_language(href_list["language"]))
				return TRUE
			return
		else
			owner.remove_language(href_list["language"])
			return TRUE


/datum/nano_module/appearance_changer/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui, force_open = TRUE, datum/topic_state/state = GLOB.default_state)
	if (QDELETED(owner) || !owner.species)
		return

	var/list/data = host.initial_data()

	data["specimen"] = owner.species.name
	data["gender"] = owner.gender

	data["change_skin_tone"] = (flags & APPEARANCE_SKIN) && (owner.species.appearance_flags & HAS_A_SKIN_TONE)
	data["change_skin_color"] = (flags & APPEARANCE_SKIN) && (owner.species.appearance_flags & HAS_SKIN_COLOR)
	data["change_eye_color"] = !!(flags & APPEARANCE_EYES)
	data["change_hair_color"] = !!(flags & APPEARANCE_HEAD_COLOR)
	data["change_facial_hair_color"] = !!(flags & APPEARANCE_FACE_COLOR)

	data["change_race"] = !!(flags & APPEARANCE_RACE)
	if (data["change_race"])
		var/list/entries = (data["species"] = list())
		for (var/race_key in races)
			entries += list(list("specimen" = race_key))

	data["change_gender"] = !!(flags & APPEARANCE_GENDER)
	if (data["change_gender"])
		var/list/entries = (data["genders"] = list())
		for (var/gender_key in owner.species.genders)
			entries += list(list("gender_name" = gender2text(gender_key), "gender_key" = gender_key))

	data["change_hair"] = !!(flags & APPEARANCE_HEAD)
	if (data["change_hair"])
		var/list/entries = (data["hair_styles"] = list())
		for (var/head_key in heads)
			entries += list(list("hairstyle" = head_key))
		data["hair_style"] = owner.head_hair_style

	data["change_facial_hair"] = !!(flags & APPEARANCE_FACE)
	if (data["change_facial_hair"])
		var/list/entries = (data["facial_hair_styles"] = list())
		for (var/face_key in faces)
			entries += list(list("facialhairstyle" = face_key))
		data["facial_hair_style"] = owner.facial_hair_style

	data["change_languages"] = !!(flags & APPEARANCE_LANG)
	if (data["change_languages"])
		var/list/entries = (data["languages"] = list())
		var/lang_list = (flags & APPEARANCE_LANG_ANY_ORIGIN) ? all_languages : langs
		for (var/lang_key in lang_list)
			entries += list(list("language" = lang_key, "selected" = (lang_list[lang_key] in owner.languages)))

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (ui)
		return
	ui = new(user, src, ui_key, "appearance_changer.tmpl", "[src]", 800, 450, state = state)
	ui.set_initial_data(data)
	ui.open()
	ui.set_auto_update(TRUE)
