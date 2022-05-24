var/global/list/valid_bloodtypes = list("A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-")

/datum/preferences
	var/species = SPECIES_HUMAN
	var/gender = MALE					//gender of character (well duh)
	var/b_type = "A+"					//blood type (not-chooseable)
	var/head_hair_style = "Bald"				//Hair type
	var/head_hair_color = "#000000"
	var/facial_hair_style = "Shaved"				//Face hair type
	var/facial_hair_color = "#000000"
	var/eye_color = "#000000"
	var/skin_tone = 0
	var/skin_color = "#000000"
	var/base_skin = ""
	var/list/body_markings = list()
	var/list/body_descriptors = list()

	// maps each organ to either null(intact), "cyborg" or "amputated"
	// will probably not be able to do this for head and torso ;)
	var/list/organ_data
	var/list/rlimb_data
	var/disabilities = 0


/datum/category_item/player_setup_item/physical/body
	name = "Body"
	sort_order = 2
	var/hide_species = TRUE

/datum/category_item/player_setup_item/physical/body/load_character(datum/pref_record_reader/R)
	pref.species = R.read("species")
	if(R.get_version() < 2 && pref.species == "booster")
		pref.species = "human"
	pref.age = R.read("age")
	pref.gender = R.read("gender")
	pref.head_hair_color = R.read("head_hair_color")
	if (!pref.head_hair_color)
		pref.head_hair_color = rgb(R.read("hair_red"), R.read("hair_green"), R.read("hair_blue"))
	pref.facial_hair_color = R.read("facial_hair_color")
	if (!pref.facial_hair_color)
		pref.facial_hair_color = rgb(R.read("facial_red"), R.read("facial_green"), R.read("facial_blue"))
	pref.eye_color = R.read("eye_color")
	if (!pref.eye_color)
		pref.eye_color = rgb(R.read("eyes_red"), R.read("eyes_green"), R.read("eyes_blue"))
	pref.skin_tone = R.read("skin_tone")
	pref.skin_color = R.read("skin_color")
	if (!pref.skin_color)
		pref.skin_color = rgb(R.read("skin_red"), R.read("skin_green"), R.read("skin_blue"))
	pref.base_skin = R.read("skin_base")
	pref.head_hair_style = R.read("hair_style_name")
	pref.facial_hair_style = R.read("facial_style_name")
	pref.b_type = R.read("b_type")
	pref.disabilities = R.read("disabilities")
	pref.organ_data = R.read("organ_data")
	pref.rlimb_data = R.read("rlimb_data")
	pref.body_markings = R.read("body_markings")
	pref.body_descriptors = R.read("body_descriptors")


/datum/category_item/player_setup_item/physical/body/save_character(datum/pref_record_writer/W)
	W.write("species", pref.species)
	W.write("gender", pref.gender)
	W.write("age", pref.age)
	W.write("head_hair_color", pref.head_hair_color)
	W.write("facial_hair_color", pref.facial_hair_color)
	W.write("skin_tone", pref.skin_tone)
	W.write("skin_color", pref.skin_color)
	W.write("skin_base", pref.base_skin)
	W.write("hair_style_name", pref.head_hair_style)
	W.write("facial_style_name", pref.facial_hair_style)
	W.write("eye_color", pref.eye_color)
	W.write("b_type", pref.b_type)
	W.write("disabilities", pref.disabilities)
	W.write("organ_data", pref.organ_data)
	W.write("rlimb_data", pref.rlimb_data)
	W.write("body_markings", pref.body_markings)
	W.write("body_descriptors", pref.body_descriptors)


/datum/category_item/player_setup_item/physical/body/sanitize_character()
	pref.head_hair_color = sanitize_hexcolor(pref.head_hair_color)
	pref.facial_hair_color = sanitize_hexcolor(pref.facial_hair_color)
	pref.eye_color = sanitize_hexcolor(pref.eye_color)
	pref.skin_color = sanitize_hexcolor(pref.skin_color)
	pref.head_hair_style		= sanitize_inlist(pref.head_hair_style, GLOB.hair_styles_list, initial(pref.head_hair_style))
	pref.facial_hair_style		= sanitize_inlist(pref.facial_hair_style, GLOB.facial_hair_styles_list, initial(pref.facial_hair_style))
	pref.b_type			= sanitize_text(pref.b_type, initial(pref.b_type))

	if(!pref.species || !(pref.species in playable_species))
		pref.species = SPECIES_HUMAN
	var/datum/species/mob_species = all_species[pref.species]

	pref.gender			= sanitize_inlist(pref.gender, mob_species.genders, pick(mob_species.genders))
	pref.age = sanitize_integer(pref.age, mob_species.min_age, mob_species.max_age, initial(pref.age))

	var/low_skin_tone = mob_species ? (35 - mob_species.max_skin_tone()) : -185
	sanitize_integer(pref.skin_tone, low_skin_tone, 34, initial(pref.skin_tone))

	if(!mob_species.base_skin_colours || isnull(mob_species.base_skin_colours[pref.base_skin]))
		pref.base_skin = ""

	pref.disabilities	= sanitize_integer(pref.disabilities, 0, 65535, initial(pref.disabilities))
	if(!istype(pref.organ_data)) pref.organ_data = list()
	if(!istype(pref.rlimb_data)) pref.rlimb_data = list()
	if(!istype(pref.body_markings))
		pref.body_markings = list()
	else
		pref.body_markings &= GLOB.body_marking_styles_list

	sanitize_organs()

	var/list/last_descriptors = list()
	if(islist(pref.body_descriptors))
		last_descriptors = pref.body_descriptors.Copy()
	pref.body_descriptors = list()

	if(LAZYLEN(mob_species.descriptors))
		for(var/entry in mob_species.descriptors)
			var/datum/mob_descriptor/descriptor = mob_species.descriptors[entry]
			if(istype(descriptor))
				if(isnull(last_descriptors[entry]))
					pref.body_descriptors[entry] = descriptor.default_value // Species datums have initial default value.
				else
					pref.body_descriptors[entry] = clamp(last_descriptors[entry], 1, LAZYLEN(descriptor.standalone_value_descriptors))


/datum/category_item/player_setup_item/physical/body/content(mob/user)
	. = list()
	var/datum/species/mob_species = all_species[pref.species]
	. += "<b>Species</b> [BTN("show_species", "Info")]"
	. += "<br />[TBTN("set_species", mob_species.name, "Selected")]"
	. += "<br /><br /><b>Body</b> [BTN("random", "Randomize")]"
	. += "<br />[TBTN("gender", gender2text(pref.gender), "Gender")]"
	. += "<br />[TBTN("age", pref.age, "Age")]"
	. += "<br />[TBTN("blood_type", pref.b_type, "Blood Type")]"
	. += "<br />[VTBTN("disabilities", NEARSIGHTED, pref.disabilities & NEARSIGHTED ? "Yes" : "No", "Glasses")]"

	if (length(pref.body_descriptors))
		for (var/entry in pref.body_descriptors)
			var/datum/mob_descriptor/descriptor = mob_species.descriptors[entry]
			if (!descriptor) //this hides a nabber problem
				continue
			var/description = descriptor.get_standalone_value_descriptor(pref.body_descriptors[entry])
			. += "<br />[VBTN("change_descriptor", entry, capitalize(descriptor.chargen_label))] - [description]"

	if (has_flag(mob_species, HAS_EYE_COLOR))
		var/color = pref.eye_color
		. += "[TBTN("eye_color", "Color", "<br />Eyes")] [COLOR_PREVIEW(color)]"

	var/has_head_hair = length(mob_species.get_hair_styles())
	if (has_head_hair > 1)
		. += "<br />Hair "
		if (has_flag(mob_species, HAS_HAIR_COLOR))
			var/color = pref.head_hair_color
			. += "[BTN("hair_color", "Color")] [COLOR_PREVIEW(color)] "
		. += "[BTN("hair_style=1;dec", "<")][BTN("hair_style=1;inc", ">")][BTN("hair_style", pref.head_hair_style)]"

	var/has_facial_hair = length(mob_species.get_facial_hair_styles(pref.gender))
	if (has_facial_hair > 1)
		. += "<br />Facial Hair "
		if (has_flag(mob_species, HAS_HAIR_COLOR))
			var/color = pref.facial_hair_color
			. += "[BTN("facial_color", "Color")] [COLOR_PREVIEW(color)] "
		. += "[BTN("facial_style=1;dec", "<")][BTN("facial_style=1;inc", ">")][BTN("facial_style", pref.facial_hair_style)]"

	if (has_flag(mob_species, HAS_BASE_SKIN_COLOURS))
		. += TBTN("base_skin", pref.base_skin, "<br />Base Skin")
	if (has_flag(mob_species, HAS_SKIN_COLOR))
		var/color = pref.skin_color
		. += "[TBTN("skin_color", "Color", "<br />Skin Color")] [COLOR_PREVIEW(color)]"
	else if (has_flag(mob_species, HAS_A_SKIN_TONE))
		. += "[TBTN("skin_tone", "[-pref.skin_tone + 35]/[mob_species.max_skin_tone()]", "<br />Skin Tone")]"

	. += "<br />[BTN("marking_style", "+ Body Marking")]"
	for (var/marking in pref.body_markings)
		. += "<br />[VTBTN("marking_remove", marking, "-", marking)] "
		var/datum/sprite_accessory/marking/instance = GLOB.body_marking_styles_list[marking]
		if (instance.do_coloration == DO_COLORATION_USER)
			var/color = pref.body_markings[marking]
			. += "[VBTN("marking_color", marking, "Color")] [COLOR_PREVIEW(color)]"
	if (length(pref.body_markings))
		. += "<br />"

	. += "<br />[TBTN("reset_limbs", "Reset", "Body Parts")] [BTN("limbs", "Adjust Limbs")] [BTN("organs", "Adjust Organs")]"
	var/list/alt_organs = list()
	for (var/name in pref.organ_data)
		var/status = pref.organ_data[name]
		var/organ_name
		switch (name)
			if (BP_L_ARM) organ_name = "left arm"
			if (BP_R_ARM) organ_name = "right arm"
			if (BP_L_LEG) organ_name = "left leg"
			if (BP_R_LEG) organ_name = "right leg"
			if (BP_L_FOOT) organ_name = "left foot"
			if (BP_R_FOOT) organ_name = "right foot"
			if (BP_L_HAND) organ_name = "left hand"
			if (BP_R_HAND) organ_name = "right hand"
			if (BP_HEART) organ_name = BP_HEART
			if (BP_EYES) organ_name = BP_EYES
			if (BP_BRAIN) organ_name = BP_BRAIN
			if (BP_LUNGS) organ_name = BP_LUNGS
			if (BP_LIVER) organ_name = BP_LIVER
			if (BP_KIDNEYS) organ_name = BP_KIDNEYS
			if (BP_STOMACH) organ_name = BP_STOMACH
			if (BP_CHEST) organ_name = "upper body"
			if (BP_GROIN) organ_name = "lower body"
			if (BP_HEAD) organ_name = "head"
		switch (status)
			if ("amputated") alt_organs += "Amputated [organ_name]"
			if ("mechanical")
				alt_organs += "[organ_name == BP_BRAIN ? "Positronic" : "Synthetic"] [organ_name]"
			if ("cyborg")
				var/datum/robolimb/limb = basic_robolimb
				if (pref.rlimb_data[name] && all_robolimbs[pref.rlimb_data[name]])
					limb = all_robolimbs[pref.rlimb_data[name]]
				alt_organs += "[limb.company] [organ_name] prosthesis"
			if ("assisted")
				switch (organ_name)
					if (BP_HEART) alt_organs += "Pacemaker-assisted [organ_name]"
					if ("voicebox") alt_organs += "Surgically altered [organ_name]"
					if (BP_EYES) alt_organs += "Retinal overlayed [organ_name]"
					if (BP_BRAIN) alt_organs += "Machine-interface [organ_name]"
					else alt_organs += "Mechanically assisted [organ_name]"
	if (!length(alt_organs))
		alt_organs += "(No differences from baseline)"
	. += "<br />[alt_organs.Join(", ")]"
	. = jointext(., null)


/datum/category_item/player_setup_item/physical/body/proc/has_flag(var/datum/species/mob_species, var/flag)
	return mob_species && (mob_species.appearance_flags & flag)

/datum/category_item/player_setup_item/physical/body/OnTopic(var/href,var/list/href_list, var/mob/user)
	var/datum/species/mob_species = all_species[pref.species]

	if(href_list["toggle_species_verbose"])
		hide_species = !hide_species
		return TOPIC_REFRESH

	else if(href_list["gender"])
		var/new_gender = input(user, "Choose your character's gender:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.gender) as null|anything in mob_species.genders
		mob_species = all_species[pref.species]
		if(new_gender && CanUseTopic(user) && (new_gender in mob_species.genders))
			pref.gender = new_gender
			if(!(pref.facial_hair_style in mob_species.get_facial_hair_styles(pref.gender)))
				ResetFacialHair()
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["age"])
		var/new_age = input(user, "Choose your character's age:\n([mob_species.min_age]-[mob_species.max_age])", CHARACTER_PREFERENCE_INPUT_TITLE, pref.age) as num|null
		if(new_age && CanUseTopic(user))
			pref.age = max(min(round(text2num(new_age)), mob_species.max_age), mob_species.min_age)
			pref.skills_allocated = pref.sanitize_skills(pref.skills_allocated)		// The age may invalidate skill loadouts
			return TOPIC_REFRESH

	else if(href_list["random"])
		pref.randomize_appearance_and_body_for()
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["change_descriptor"])
		if(mob_species.descriptors)
			var/desc_id = href_list["change_descriptor"]
			if(pref.body_descriptors[desc_id])
				var/datum/mob_descriptor/descriptor = mob_species.descriptors[desc_id]
				var/choice = input("Please select a descriptor.", "Descriptor") as null|anything in descriptor.chargen_value_descriptors
				if(choice && mob_species.descriptors[desc_id]) // Check in case they sneakily changed species.
					pref.body_descriptors[desc_id] = descriptor.chargen_value_descriptors[choice]
					return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["blood_type"])
		var/new_b_type = input(user, "Choose your character's blood-type:", CHARACTER_PREFERENCE_INPUT_TITLE) as null|anything in valid_bloodtypes
		if(new_b_type && CanUseTopic(user))
			pref.b_type = new_b_type
			return TOPIC_REFRESH

	else if(href_list["show_species"])
		var/choice = input("Which species would you like to look at?") as null|anything in playable_species
		if(choice)
			var/datum/species/current_species = all_species[choice]
			show_browser(user, current_species.get_description(), "window=species;size=700x400")
			return TOPIC_HANDLED

	else if(href_list["set_species"])

		var/list/species_to_pick = list()
		for(var/species in playable_species)
			if(!GLOB.skip_allow_lists && !check_rights(R_ADMIN, 0) && config.usealienwhitelist)
				var/datum/species/current_species = all_species[species]
				if(!(current_species.spawn_flags & SPECIES_CAN_JOIN))
					continue
				else if((current_species.spawn_flags & SPECIES_IS_WHITELISTED) && !is_alien_whitelisted(preference_mob(),current_species))
					continue
			species_to_pick += species

		var/choice = input("Select a species to play as.") as null|anything in species_to_pick
		if(!choice || !(choice in all_species))
			return

		var/prev_species = pref.species
		pref.species = choice
		if(prev_species != pref.species)
			mob_species = all_species[pref.species]
			if(!(pref.gender in mob_species.genders))
				pref.gender = mob_species.genders[1]

			ResetAllHair()

			//reset hair colour and skin colour
			pref.head_hair_color = "#000000"
			pref.skin_tone = 0
			pref.age = max(min(pref.age, mob_species.max_age), mob_species.min_age)

			reset_limbs() // Safety for species with incompatible manufacturers; easier than trying to do it case by case.
			pref.body_markings.Cut() // Basically same as above.

			prune_occupation_prefs()
			pref.skills_allocated = pref.sanitize_skills(pref.skills_allocated)

			pref.cultural_info = mob_species.default_cultural_info.Copy()

			sanitize_organs()

			if(!has_flag(all_species[pref.species], HAS_UNDERWEAR))
				pref.all_underwear.Cut()

			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_hair = input(user, "Choose your character's hair colour:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.head_hair_color) as color|null
		if(new_hair && has_flag(all_species[pref.species], HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.head_hair_color = new_hair
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_style"])
		var/list/valid_hairstyles = mob_species.get_hair_styles()
		var/new_h_style
		var/hair_index = list_find(valid_hairstyles, pref.head_hair_style)

		if (href_list["inc"])
			if (hair_index < valid_hairstyles.len && valid_hairstyles[hair_index + 1])
				new_h_style = valid_hairstyles[hair_index + 1]
		else if (href_list["dec"])
			if (hair_index > 1 && valid_hairstyles[hair_index - 1])
				new_h_style = valid_hairstyles[hair_index - 1]
		else
			new_h_style = input(user, "Choose your character's hair style:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.head_hair_style)  as null|anything in valid_hairstyles

		mob_species = all_species[pref.species]
		if(new_h_style && CanUseTopic(user) && (new_h_style in mob_species.get_hair_styles()))
			pref.head_hair_style = new_h_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_facial = input(user, "Choose your character's facial-hair colour:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.facial_hair_color) as color|null
		if(new_facial && has_flag(all_species[pref.species], HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.facial_hair_color = new_facial
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["eye_color"])
		if(!has_flag(mob_species, HAS_EYE_COLOR))
			return TOPIC_NOACTION
		var/new_eyes = input(user, "Choose your character's eye colour:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.eye_color) as color|null
		if(new_eyes && has_flag(all_species[pref.species], HAS_EYE_COLOR) && CanUseTopic(user))
			pref.eye_color = new_eyes
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["base_skin"])
		if(!has_flag(mob_species, HAS_BASE_SKIN_COLOURS))
			return TOPIC_NOACTION
		var/new_s_base = input(user, "Choose your character's base colour:", CHARACTER_PREFERENCE_INPUT_TITLE) as null|anything in mob_species.base_skin_colours
		if(new_s_base && CanUseTopic(user))
			pref.base_skin = new_s_base
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["skin_tone"])
		if(!has_flag(mob_species, HAS_A_SKIN_TONE))
			return TOPIC_NOACTION
		var/new_s_tone = input(user, "Choose your character's skin-tone. Lower numbers are lighter, higher are darker. Range: 1 to [mob_species.max_skin_tone()]", CHARACTER_PREFERENCE_INPUT_TITLE, (-pref.skin_tone) + 35) as num|null
		mob_species = all_species[pref.species]
		if(new_s_tone && has_flag(mob_species, HAS_A_SKIN_TONE) && CanUseTopic(user))
			pref.skin_tone = 35 - max(min(round(new_s_tone), mob_species.max_skin_tone()), 1)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["skin_color"])
		if(!has_flag(mob_species, HAS_SKIN_COLOR))
			return TOPIC_NOACTION
		var/new_skin = input(user, "Choose your character's skin colour: ", CHARACTER_PREFERENCE_INPUT_TITLE, pref.skin_color) as color|null
		if(new_skin && has_flag(all_species[pref.species], HAS_SKIN_COLOR) && CanUseTopic(user))
			pref.skin_color = new_skin
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_style"])
		var/list/valid_facialhairstyles = mob_species.get_facial_hair_styles(pref.gender)
		var/new_f_style
		var/hair_index = list_find(valid_facialhairstyles, pref.facial_hair_style)

		if (href_list["inc"])
			if (hair_index < valid_facialhairstyles.len && valid_facialhairstyles[hair_index + 1])
				new_f_style = valid_facialhairstyles[hair_index + 1]
		else if (href_list["dec"])
			if (hair_index > 1 && valid_facialhairstyles[hair_index - 1])
				new_f_style = valid_facialhairstyles[hair_index - 1]
		else
			new_f_style = input(user, "Choose your character's facial-hair style:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.facial_hair_style)  as null|anything in valid_facialhairstyles

		mob_species = all_species[pref.species]
		if(new_f_style && CanUseTopic(user) && (new_f_style in mob_species.get_facial_hair_styles(pref.gender)))
			pref.facial_hair_style = new_f_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_style"])
		var/list/disallowed_markings = list()
		for (var/M in pref.body_markings)
			var/datum/sprite_accessory/marking/mark_style = GLOB.body_marking_styles_list[M]
			disallowed_markings |= mark_style.disallows
		var/list/usable_markings = pref.body_markings.Copy() ^ GLOB.body_marking_styles_list.Copy()
		for(var/M in usable_markings)
			var/datum/sprite_accessory/S = usable_markings[M]
			if(is_type_in_list(S, disallowed_markings) || (S.species_allowed && !(mob_species.get_bodytype() in S.species_allowed)) || (S.subspecies_allowed && !(mob_species.name in S.subspecies_allowed)))
				usable_markings -= M

		var/new_marking = input(user, "Choose a body marking:", CHARACTER_PREFERENCE_INPUT_TITLE)  as null|anything in usable_markings
		if(new_marking && CanUseTopic(user))
			pref.body_markings[new_marking] = "#000000" //New markings start black
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_remove"])
		var/M = href_list["marking_remove"]
		pref.body_markings -= M
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_color"])
		var/M = href_list["marking_color"]
		var/mark_color = input(user, "Choose the [M] color: ", CHARACTER_PREFERENCE_INPUT_TITLE, pref.body_markings[M]) as color|null
		if(mark_color && CanUseTopic(user))
			pref.body_markings[M] = "[mark_color]"
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["reset_limbs"])
		reset_limbs()
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["limbs"])

		var/list/limb_selection_list = list("Left Leg","Right Leg","Left Arm","Right Arm","Left Foot","Right Foot","Left Hand","Right Hand","Full Body")

		// Full prosthetic bodies without a brain are borderline unkillable so make sure they have a brain to remove/destroy.
		var/datum/species/current_species = all_species[pref.species]
		if(current_species.spawn_flags & SPECIES_NO_FBP_CHARGEN)
			limb_selection_list -= "Full Body"
		else if(pref.organ_data[BP_CHEST] == "cyborg")
			limb_selection_list |= "Head"

		var/organ_tag = input(user, "Which limb do you want to change?") as null|anything in limb_selection_list

		if(!organ_tag || !CanUseTopic(user)) return TOPIC_NOACTION

		var/limb = null
		var/second_limb = null // if you try to change the arm, the hand should also change
		var/third_limb = null  // if you try to unchange the hand, the arm should also change

		// Do not let them amputate their entire body, ty.
		var/list/choice_options = list("Normal","Amputated","Prosthesis")

		//Dare ye who decides to one day make fbps be able to have fleshy bits. Heed my warning, recursion is a bitch. - Snapshot
		if(pref.organ_data[BP_CHEST] == "cyborg")
			choice_options = list("Amputated", "Prosthesis")

		switch(organ_tag)
			if("Left Leg")
				limb = BP_L_LEG
				second_limb = BP_L_FOOT
			if("Right Leg")
				limb = BP_R_LEG
				second_limb = BP_R_FOOT
			if("Left Arm")
				limb = BP_L_ARM
				second_limb = BP_L_HAND
			if("Right Arm")
				limb = BP_R_ARM
				second_limb = BP_R_HAND
			if("Left Foot")
				limb = BP_L_FOOT
				third_limb = BP_L_LEG
			if("Right Foot")
				limb = BP_R_FOOT
				third_limb = BP_R_LEG
			if("Left Hand")
				limb = BP_L_HAND
				third_limb = BP_L_ARM
			if("Right Hand")
				limb = BP_R_HAND
				third_limb = BP_R_ARM
			if("Head")
				limb =        BP_HEAD
				choice_options = list("Prosthesis")
			if("Full Body")
				limb =        BP_CHEST
				third_limb =  BP_GROIN
				choice_options = list("Normal","Prosthesis")

		var/new_state = input(user, "What state do you wish the limb to be in?") as null|anything in choice_options
		if(!new_state || !CanUseTopic(user)) return TOPIC_NOACTION

		switch(new_state)
			if("Normal")
				if(limb == BP_CHEST)
					for(var/other_limb in (BP_ALL_LIMBS - BP_CHEST))
						pref.organ_data[other_limb] = null
						pref.rlimb_data[other_limb] = null
						for(var/internal_organ in list(BP_HEART,BP_EYES,BP_LUNGS,BP_LIVER,BP_KIDNEYS,BP_STOMACH,BP_BRAIN))
							pref.organ_data[internal_organ] = null
				pref.organ_data[limb] = null
				pref.rlimb_data[limb] = null
				if(third_limb)
					pref.organ_data[third_limb] = null
					pref.rlimb_data[third_limb] = null
			if("Amputated")
				if(limb == BP_CHEST)
					return
				pref.organ_data[limb] = "amputated"
				pref.rlimb_data[limb] = null
				if(second_limb)
					pref.organ_data[second_limb] = "amputated"
					pref.rlimb_data[second_limb] = null

			if("Prosthesis")
				var/datum/species/temp_species = pref.species ? all_species[pref.species] : all_species[SPECIES_HUMAN]
				var/tmp_species = temp_species.get_bodytype(user)
				var/list/usable_manufacturers = list()
				for(var/company in chargen_robolimbs)
					var/datum/robolimb/M = chargen_robolimbs[company]
					if(tmp_species in M.species_cannot_use)
						continue
					if(M.restricted_to.len && !(tmp_species in M.restricted_to))
						continue
					if(M.applies_to_part.len && !(limb in M.applies_to_part))
						continue
					if(M.allowed_bodytypes && !(tmp_species in M.allowed_bodytypes))
						continue
					usable_manufacturers[company] = M
				if(!usable_manufacturers.len)
					return
				var/choice = input(user, "Which manufacturer do you wish to use for this limb?") as null|anything in usable_manufacturers
				if(!choice)
					return
				pref.rlimb_data[limb] = choice
				pref.organ_data[limb] = "cyborg"
				if(second_limb)
					pref.rlimb_data[second_limb] = choice
					pref.organ_data[second_limb] = "cyborg"
				if(third_limb && pref.organ_data[third_limb] == "amputated")
					pref.organ_data[third_limb] = null

				if(limb == BP_CHEST)
					for(var/other_limb in BP_ALL_LIMBS - BP_CHEST)
						pref.organ_data[other_limb] = "cyborg"
						pref.rlimb_data[other_limb] = choice
					if(!pref.organ_data[BP_BRAIN])
						pref.organ_data[BP_BRAIN] = "assisted"
					for(var/internal_organ in list(BP_HEART,BP_EYES,BP_LUNGS,BP_LIVER,BP_KIDNEYS))
						pref.organ_data[internal_organ] = "mechanical"

		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["organs"])
		var/organ_name = input(user, "Which internal function do you want to change?") as null|anything in list("Heart", "Eyes", "Lungs", "Liver", "Kidneys", "Stomach")
		if(!organ_name) return

		var/organ = null
		switch(organ_name)
			if("Heart")
				organ = BP_HEART
			if("Eyes")
				organ = BP_EYES
			if("Lungs")
				organ = BP_LUNGS
			if("Liver")
				organ = BP_LIVER
			if("Kidneys")
				organ = BP_KIDNEYS
			if("Stomach")
				organ = BP_STOMACH

		var/list/organ_choices = list("Normal","Assisted","Synthetic")

		if(mob_species && mob_species.spawn_flags & SPECIES_NO_ROBOTIC_INTERNAL_ORGANS)
			organ_choices -= "Assisted"
			organ_choices -= "Synthetic"

		if(pref.organ_data[BP_CHEST] == "cyborg")
			organ_choices -= "Normal"
			organ_choices += "Synthetic"

		var/new_state = input(user, "What state do you wish the organ to be in?") as null|anything in organ_choices
		if(!new_state) return

		switch(new_state)
			if("Normal")
				pref.organ_data[organ] = null
			if("Assisted")
				pref.organ_data[organ] = "assisted"
			if("Synthetic")
				pref.organ_data[organ] = "mechanical"

		sanitize_organs()
		return TOPIC_REFRESH

	else if(href_list["disabilities"])
		var/disability_flag = text2num(href_list["disabilities"])
		pref.disabilities ^= disability_flag
		return TOPIC_REFRESH_UPDATE_PREVIEW

	return ..()


/datum/category_item/player_setup_item/physical/body/proc/reset_limbs()
	pref.organ_data.Cut()
	pref.rlimb_data.Cut()

/datum/category_item/player_setup_item/proc/ResetAllHair()
	ResetHair()
	ResetFacialHair()

/datum/category_item/player_setup_item/proc/ResetHair()
	var/datum/species/mob_species = all_species[pref.species]
	var/list/valid_hairstyles = mob_species.get_hair_styles()

	if(valid_hairstyles.len)
		pref.head_hair_style = pick(valid_hairstyles)
	else
		//this shouldn't happen
		pref.head_hair_style = GLOB.hair_styles_list["Bald"]

/datum/category_item/player_setup_item/proc/ResetFacialHair()
	var/datum/species/mob_species = all_species[pref.species]
	var/list/valid_facialhairstyles = mob_species.get_facial_hair_styles(pref.gender)

	if(valid_facialhairstyles.len)
		pref.facial_hair_style = pick(valid_facialhairstyles)
	else
		//this shouldn't happen
		pref.facial_hair_style = GLOB.facial_hair_styles_list["Shaved"]

/datum/category_item/player_setup_item/physical/body/proc/sanitize_organs()
	var/datum/species/mob_species = all_species[pref.species]
	if(mob_species && mob_species.spawn_flags & SPECIES_NO_ROBOTIC_INTERNAL_ORGANS)
		for(var/name in pref.organ_data)
			var/status = pref.organ_data[name]
			if(status in list("assisted","mechanical"))
				pref.organ_data[name] = null
