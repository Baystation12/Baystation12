datum/preferences/proc/contentGeneral()
	var/user = usr
	var/data = {"
		<html><body>

		<nav class='vNav'>
		<ul>
		<li><a class='active' href='?src=\ref[src];page=1'>Character</a>
		<li><a href='?src=\ref[src];page=2'>Occupation</a>
		<li><a href='?src=\ref[src];page=3'>Loadout</a>
		<li><a href='?src=\ref[src];page=4'>Local Preferences</a>
		<li><hr>
		<li><a href='?src=\ref[src];page=9'>Records</a>
		<li><hr>
		<li><a href='?src=\ref[src];page=8'>Global Preferences</a>
		</ul>
		</nav>

		<nav class='hNav'>
		<ul>
		<li><a href='?src=\ref[src];save=1'>Save</a>
		<li><a href='?src=\ref[src];load=1'>Load</a>
		<li><a href='?src=\ref[src];delete=1'>Reset</a>
		<li><a href='?src=\ref[src];lock=1'>Lock</a>
		</ul>
		</nav>

		<div class='main'>"}
	if(char_lock)
		data += {"

			<b>Name:</b>
			<b>[real_name]</b><br>
			<br>
			<b>Gender: [gender2text(gender)]</b><br>
			<b>Age:</b> [age]<br>
			<b>Spawn Point</b>: <a href='?src=\ref[src];spawnpoint=1'>[spawnpoint]</a><br>

			"}
	else
		data += {"

			<b>Name:</b>
			<a href='?src=\ref[src];rename=1'><b>[real_name]</b></a> (<a href='?src=\ref[src];random_name=1'>Random</a>)<br>
			<br>
			<b>Gender:</b> <a href='?src=\ref[src];gender=1'><b>[gender2text(gender)]</b></a><br>
			<b>Age:</b> <a href='?src=\ref[src];age=1'>[age]</a><br>
			<b>Spawn Point</b>: <a href='?src=\ref[src];spawnpoint=1'>[spawnpoint]</a><br>

			"}

	data += "<br><b>Languages</b><br>"
	var/datum/species/S = all_species[species]
	if(S.language)
		data += "- [S.language]<br>"
	if(S.default_language && S.default_language != S.language)
		data += "- [S.default_language]<br>"
	if(S.num_alternate_languages)
		if(alternate_languages.len)
			for(var/i = 1 to alternate_languages.len)
				var/lang = alternate_languages[i]
				if(char_lock)
					data +="- [lang]<br>"
				else
					data += "- [lang] - <a href='?src=\ref[src];remove_language=[i]'>remove</a><br>"

		if(alternate_languages.len < S.num_alternate_languages)
			if(!char_lock)
				data += "- <a href='?src=\ref[src];add_language=1'>add</a> ([S.num_alternate_languages - alternate_languages.len] remaining)<br>"
	else
		data += "- [species] cannot choose secondary languages.<br>"

	update_preview_icon()
	user << browse_rsc(preview_icon, "previewicon.png")

	var/mob_species = all_species[species]

	if(char_lock)
		data += "<br><b>Body</b> "
		data += "<br>"

		if(config.use_cortical_stacks)
			data += "Neural lace: "
			data += has_cortical_stack ? "Present." : "<b>Not present.</b>"
			data += "<br>"

		data += "Species: [species]<br>"
		data += "Blood Type: [b_type]<br>"

		if(has_flag(mob_species, HAS_SKIN_TONE))
			data += "Skin Tone: [-s_tone + 35]<br>"
		data += "Needs Glasses: <b>[disabilities & NEARSIGHTED ? "Yes" : "No"]</b><br>"
		data += "Limbs and Internal Organs:<br>"

	else
		data += "<br><b>Body</b> (<a href='?src=\ref[src];random=1'>Random</A>)<br>"

		if(config.use_cortical_stacks)
			data += "Neural lace: "
			data += has_cortical_stack ? "Present." : "<b>Not present.</b>"
			data += " \[<a href='byond://?src=\ref[src];toggle_stack=1'>Toggle</a>\]<br>"

		data += "Species: <a href='?src=\ref[src];show_species=1'>[species]</a><br>"
		data += "Blood Type: Lock character to generate.<br>"

		if(has_flag(mob_species, HAS_SKIN_TONE))
			data += "Skin Tone: <a href='?src=\ref[src];skin_tone=1'>[-s_tone + 35]/220</a><br>"
		data += "Needs Glasses: <a href='?src=\ref[src];disabilities=[NEARSIGHTED]'><b>[disabilities & NEARSIGHTED ? "Yes" : "No"]</b></a><br>"
		data += "Limbs: <a href='?src=\ref[src];limbs=1'>Adjust</a> <a href='?src=\ref[src];reset_limbs=1'>Reset</a><br>"
		data += "Internal Organs: <a href='?src=\ref[src];organs=1'>Adjust</a><br>"

	//display limbs below
	var/ind = 0
	for(var/name in organ_data)
		var/status = organ_data[name]
		var/organ_name = null
		switch(name)
			if(BP_L_ARM)
				organ_name = "left arm"
			if(BP_R_ARM)
				organ_name = "right arm"
			if(BP_L_LEG)
				organ_name = "left leg"
			if(BP_R_LEG)
				organ_name = "right leg"
			if(BP_L_FOOT)
				organ_name = "left foot"
			if(BP_R_FOOT)
				organ_name = "right foot"
			if(BP_L_HAND)
				organ_name = "left hand"
			if(BP_R_HAND)
				organ_name = "right hand"
			if(BP_HEART)
				organ_name = BP_HEART
			if(BP_EYES)
				organ_name = BP_EYES
			if(BP_BRAIN)
				organ_name = BP_BRAIN
			if(BP_CHEST)
				organ_name = "upper body"
			if(BP_GROIN)
				organ_name = "lower body"
			if(BP_HEAD)
				organ_name = "head"

		if(status == "cyborg")
			++ind
			if(ind > 1)
				data += "<br>"
			var/datum/robolimb/R
			if(rlimb_data[name] && all_robolimbs[rlimb_data[name]])
				R = all_robolimbs[rlimb_data[name]]
			else
				R = basic_robolimb
			data += "\t[R.company] [organ_name] prosthesis"
		else if(status == "amputated")
			++ind
			if(ind > 1)
				data += "<br>"
			data += "\tAmputated [organ_name]"
		else if(status == "mechanical")
			++ind
			if(ind > 1)
				data += "<br>"
			if(organ_name == BP_BRAIN)
				data += "\tPositronic [organ_name]"
			else
				data += "\tSynthetic [organ_name]"
		else if(status == "assisted")
			++ind
			if(ind > 1)
				data += "<br>"
			switch(organ_name)
				if(BP_HEART)
					data += "\tPacemaker-assisted [organ_name]"
				if("voicebox") //on adding voiceboxes for speaking skrell/similar replacements
					data += "\tSurgically altered [organ_name]"
				if(BP_EYES)
					data += "\tRetinal overlayed [organ_name]"
				if(BP_BRAIN)
					data += "\tMachine-interface [organ_name]"
				else
					data += "\tMechanically assisted [organ_name]"
	if(!ind)
		data += "\[...\]"
	data += "<br><br>"


	data += "<b>Hair: </b>"
	if(has_flag(mob_species, HAS_HAIR_COLOR))
		data += "<font face='fixedsys' size='3' color='#[num2hex(r_hair, 2)][num2hex(g_hair, 2)][num2hex(b_hair, 2)]'><table style='display:inline;' bgcolor='#[num2hex(r_hair, 2)][num2hex(g_hair, 2)][num2hex(b_hair)]'><tr><td>__</td></tr></table></font> "
		data += "<a href='?src=\ref[src];hair_color=1'>Change Color</a> | "
	data += " Style: <a href='?src=\ref[src];hair_style=1'>[h_style]</a><br>"

	data += "<br><b>Facial: </b>"
	if(has_flag(mob_species, HAS_HAIR_COLOR))
		data += "<font face='fixedsys' size='3' color='#[num2hex(r_facial, 2)][num2hex(g_facial, 2)][num2hex(b_facial, 2)]'><table  style='display:inline;' bgcolor='#[num2hex(r_facial, 2)][num2hex(g_facial, 2)][num2hex(b_facial)]'><tr><td>__</td></tr></table></font> "
		data += "<a href='?src=\ref[src];facial_color=1'>Change Color</a> | "
	data += " Style: <a href='?src=\ref[src];facial_style=1'>[f_style]</a><br>"

	if(has_flag(mob_species, HAS_EYE_COLOR))
		data += "<br><b>Eyes: </b>"
		if(char_lock)
			data += "<font face='fixedsys' size='3' color='#[num2hex(r_eyes, 2)][num2hex(g_eyes, 2)][num2hex(b_eyes, 2)]'><table  style='display:inline;' bgcolor='#[num2hex(r_eyes, 2)][num2hex(g_eyes, 2)][num2hex(b_eyes)]'><tr><td>__</td></tr></table></font><br>"
		else
			data += "<font face='fixedsys' size='3' color='#[num2hex(r_eyes, 2)][num2hex(g_eyes, 2)][num2hex(b_eyes, 2)]'><table  style='display:inline;' bgcolor='#[num2hex(r_eyes, 2)][num2hex(g_eyes, 2)][num2hex(b_eyes)]'><tr><td>__</td></tr></table></font>"
			data += "<a href='?src=\ref[src];eye_color=1'> Change Color</a><br>"

	if(has_flag(mob_species, HAS_SKIN_COLOR))
		data += "<br><b>Body Color: </b>"
		if(char_lock)
			data += "<font face='fixedsys' size='3' color='#[num2hex(r_skin, 2)][num2hex(g_skin, 2)][num2hex(b_skin, 2)]'><table style='display:inline;' bgcolor='#[num2hex(r_skin, 2)][num2hex(g_skin, 2)][num2hex(b_skin)]'><tr><td>__</td></tr></table></font><br>"
		else
			data += "<font face='fixedsys' size='3' color='#[num2hex(r_skin, 2)][num2hex(g_skin, 2)][num2hex(b_skin, 2)]'><table style='display:inline;' bgcolor='#[num2hex(r_skin, 2)][num2hex(g_skin, 2)][num2hex(b_skin)]'><tr><td>__</td></tr></table></font>"
			data += "<a href='?src=\ref[src];skin_color=1'> Change Color</a> <br>"

	data += {"

		</div>

		<div class='secondary'>
		<div class='statusDisplay'><center><img src=previewicon.png width=[preview_icon.Width()] height=[preview_icon.Height()]></center></div>
		<br><a href='?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_LOADOUT]'>[equip_preview_mob & EQUIP_PREVIEW_LOADOUT ? "Hide loadout" : "Show loadout"]</a>
		<br><a href='?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_JOB]'>[equip_preview_mob & EQUIP_PREVIEW_JOB ? "Hide job gear" : "Show job gear"]</a>

		<br><br><b>Equipment:</b><br><br>

		"}
	for(var/datum/category_group/underwear/UWC in global_underwear.categories)
		var/item_name = (all_underwear && all_underwear[UWC.name]) ? all_underwear[UWC.name] : "None"
		data += "[UWC.name]: <a href='?src=\ref[src];change_underwear=[UWC.name]'><b>[item_name]</b></a>"

		var/datum/category_item/underwear/UWI = UWC.items_by_name[item_name]
		if(UWI)
			for(var/datum/gear_tweak/gt in UWI.tweaks)
				data += " <a href='?src=\ref[src];underwear=[UWC.name];tweak=\ref[gt]'>[gt.get_contents(get_metadata(UWC.name, gt))]</a><br>"

		data += "<br>"
	data += {"

		Backpack Type: <a href='?src=\ref[src];change_backpack=1'><b>[backbaglist[backbag]]</b></a><br>

		<br><b>Flavor:</b><br><br>
		<a href='?src=\ref[src];flavor_text=open'>Set Flavor Text</a><br>
		<a href='?src=\ref[src];flavour_text_robot=open'>Set Robot Flavor Text</a>
		</div>

		<div class='background'></div>

		</body></div></html>

		"}

	return data

/datum/preferences/Topic(href, list/href_list)
	user = usr
	var/datum/species/spec = all_species[species]
	if(..())
		return 1
	if(href_list["page"])
		selected_menu = text2num(href_list["page"])

	else if(href_list["save"])
		save_preferences()
		save_character()
	else if(href_list["load"])
		if(!IsGuestKey(usr.key))
			open_load_dialog(usr)
			return 1
	else if(href_list["changeslot"])
		load_character(text2num(href_list["changeslot"]))
		sanitize_preferences()
		close_load_dialog(usr)
	else if(href_list["delete"])
		if("No" == alert("This will reset the current slot. Continue?", "Reset current slot?", "No", "Yes"))
			return 0
		char_lock = 0
		load_character(SAVE_RESET)
		save_character()
		sanitize_preferences()
	else if(href_list["lock"])
		if("No" == alert("This will lock the current slot. You will no longer be able to edit it. Continue?", "Lock current slot?", "No", "Yes"))
			return 0
		char_lock = 1
		b_type = RANDOM_BLOOD_TYPE
		save_character()
		load_character()

	else if(selected_menu > 1 && href_list.len > 1)
		switch(selected_menu)
			if(2) Topic2(href, href_list)
			if(3) Topic3(href, href_list)
			if(4) Topic4(href, href_list)
			if(5) Topic5(href, href_list)
			if(6) Topic6(href, href_list)
			if(7) Topic7(href, href_list)
			if(8) Topic8(href, href_list)
			if(9) Topic9(href, href_list)

	else if(href_list["rename"])
		var/raw_name = input(user, "Choose your character's name:", "Character Name")  as text|null
		if (!isnull(raw_name) && CanUseTopic(user))
			var/new_name = sanitize_name(raw_name, spec)
			if(new_name)
				real_name = new_name
			else
				to_chat(user, "<span class='warning'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</span>")

	else if(href_list["random_name"])
		real_name = random_name(gender, spec)

	else if(href_list["gender"])
		var/new_gender = input(user, "Choose your character's gender:", "Character Preference", gender) as null|anything in spec.genders
		if(new_gender && CanUseTopic(user))
			gender = new_gender

	else if(href_list["age"])
		var/new_age = input(user, "Choose your character's age:\n([spec.min_age]-[spec.max_age])", "Character Preference", age) as num|null
		if(new_age && CanUseTopic(user))
			age = max(min(round(text2num(new_age)), spec.max_age), spec.min_age)

	else if(href_list["spawnpoint"])
		var/list/spawnkeys = list()
		for(var/spawntype in spawntypes)
			spawnkeys += spawntype
		var/choice = input(user, "Where would you like to spawn when late-joining?") as null|anything in spawnkeys
		if(!choice || !spawntypes[choice] || !CanUseTopic(user))	return
		spawnpoint = choice

	else if(href_list["metadata"])
		var/new_metadata = sanitize(input(user, "Enter any information you'd like others to see, such as Roleplay-preferences:", "Game Preference" , metadata)) as message|null
		if(new_metadata && CanUseTopic(user))
			metadata = new_metadata

	else if(href_list["remove_language"])
		var/index = text2num(href_list["remove_language"])
		alternate_languages.Cut(index, index+1)

	else if(href_list["add_language"])
		if(alternate_languages.len >= spec.num_alternate_languages)
			alert(user, "You have already selected the maximum number of alternate languages for this species!")
		else
			var/preference_mob = preference_mob()
			var/list/available_languages = spec.secondary_langs.Copy()
			for(var/L in all_languages)
				var/datum/language/lang = all_languages[L]
				if(is_allowed_language(preference_mob, lang))
					available_languages |= L

			// make sure we don't let them waste slots on the default languages
			available_languages -= spec.language
			available_languages -= spec.default_language
			available_languages -= alternate_languages

			if(!available_languages.len)
				alert(user, "There are no additional languages available to select.")
			else
				var/new_lang = input(user, "Select an additional language", "Character Generation", null) as null|anything in available_languages
				if(new_lang)
					alternate_languages |= new_lang
					sanitize_alt_languages()
	else if(href_list["random"])
		randomize_appearance_and_body_for()

	else if(href_list["toggle_stack"])
		has_cortical_stack = !has_cortical_stack

	else if(href_list["show_species"])
		SetSpecies(preference_mob())
		alternate_languages.Cut() // Reset their alternate languages. Todo: attempt to just fix it instead?

	else if(href_list["set_species"])
		user << browse(null, "window=species")
		if(!species_preview || !(species_preview in all_species))
			return

		var/prev_species = species
		species = href_list["set_species"]
		if(prev_species != species)
			species = all_species[species]
			if(!(gender in spec.genders))
				gender = spec.genders[1]

			//grab one of the valid hair styles for the newly chosen species
			var/list/valid_hairstyles = list()
			for(var/hairstyle in hair_styles_list)
				var/datum/sprite_accessory/S = hair_styles_list[hairstyle]
				if(gender == MALE && S.gender == FEMALE)
					continue
				if(gender == FEMALE && S.gender == MALE)
					continue
				if(!(spec.get_bodytype() in S.species_allowed))
					continue
				valid_hairstyles[hairstyle] = hair_styles_list[hairstyle]

			if(valid_hairstyles.len)
				h_style = pick(valid_hairstyles)
			else
				//this shouldn't happen
				h_style = hair_styles_list["Bald"]

			//grab one of the valid facial hair styles for the newly chosen species
			var/list/valid_facialhairstyles = list()
			for(var/facialhairstyle in facial_hair_styles_list)
				var/datum/sprite_accessory/S = facial_hair_styles_list[facialhairstyle]
				if(gender == MALE && S.gender == FEMALE)
					continue
				if(gender == FEMALE && S.gender == MALE)
					continue
				if(!(spec.get_bodytype() in S.species_allowed))
					continue

				valid_facialhairstyles[facialhairstyle] = facial_hair_styles_list[facialhairstyle]

			if(valid_facialhairstyles.len)
				f_style = pick(valid_facialhairstyles)
			else
				//this shouldn't happen
				f_style = facial_hair_styles_list["Shaved"]

			//reset hair colour and skin colour
			r_hair = 0//hex2num(copytext(new_hair, 2, 4))
			g_hair = 0//hex2num(copytext(new_hair, 4, 6))
			b_hair = 0//hex2num(copytext(new_hair, 6, 8))
			s_tone = 0
			age = max(min(age, spec.max_age), spec.min_age)

			reset_limbs() // Safety for species with incompatible manufacturers; easier than trying to do it case by case.

	else if(href_list["hair_color"])
		if(!has_flag(spec, HAS_HAIR_COLOR))
			return
		var/new_hair = input(user, "Choose your character's hair colour:", "Character Preference", rgb(r_hair, g_hair, b_hair)) as color|null
		if(new_hair && has_flag(spec, HAS_HAIR_COLOR) && CanUseTopic(user))
			r_hair = hex2num(copytext(new_hair, 2, 4))
			g_hair = hex2num(copytext(new_hair, 4, 6))
			b_hair = hex2num(copytext(new_hair, 6, 8))

	else if(href_list["hair_style"])
		var/list/valid_hairstyles = list()
		for(var/hairstyle in hair_styles_list)
			var/datum/sprite_accessory/S = hair_styles_list[hairstyle]
			if(!(spec.get_bodytype() in S.species_allowed))
				continue

			valid_hairstyles[hairstyle] = hair_styles_list[hairstyle]

		var/new_h_style = input(user, "Choose your character's hair style:", "Character Preference", h_style)  as null|anything in valid_hairstyles
		if(new_h_style && CanUseTopic(user))
			h_style = new_h_style

	else if(href_list["facial_color"])
		if(!has_flag(spec, HAS_HAIR_COLOR))
			return
		var/new_facial = input(user, "Choose your character's facial-hair colour:", "Character Preference", rgb(r_facial, g_facial, b_facial)) as color|null
		if(new_facial && has_flag(spec, HAS_HAIR_COLOR) && CanUseTopic(user))
			r_facial = hex2num(copytext(new_facial, 2, 4))
			g_facial = hex2num(copytext(new_facial, 4, 6))
			b_facial = hex2num(copytext(new_facial, 6, 8))

	else if(href_list["eye_color"])
		if(!has_flag(spec, HAS_EYE_COLOR))
			return
		var/new_eyes = input(user, "Choose your character's eye colour:", "Character Preference", rgb(r_eyes, g_eyes, b_eyes)) as color|null
		if(new_eyes && has_flag(spec, HAS_EYE_COLOR) && CanUseTopic(user))
			r_eyes = hex2num(copytext(new_eyes, 2, 4))
			g_eyes = hex2num(copytext(new_eyes, 4, 6))
			b_eyes = hex2num(copytext(new_eyes, 6, 8))

	else if(href_list["skin_tone"])
		if(!has_flag(spec, HAS_SKIN_TONE))
			return
		var/new_s_tone = input(user, "Choose your character's skin-tone:\n(Light 1 - 220 Dark)", "Character Preference", (-s_tone) + 35)  as num|null
		if(new_s_tone && has_flag(spec, HAS_SKIN_TONE) && CanUseTopic(user))
			s_tone = 35 - max(min( round(new_s_tone), 220),1)

	else if(href_list["skin_color"])
		if(!has_flag(spec, HAS_SKIN_COLOR))
			return
		var/new_skin = input(user, "Choose your character's skin colour: ", "Character Preference", rgb(r_skin, g_skin, b_skin)) as color|null
		if(new_skin && has_flag(spec, HAS_SKIN_COLOR) && CanUseTopic(user))
			r_skin = hex2num(copytext(new_skin, 2, 4))
			g_skin = hex2num(copytext(new_skin, 4, 6))
			b_skin = hex2num(copytext(new_skin, 6, 8))

	else if(href_list["facial_style"])
		var/list/valid_facialhairstyles = list()
		for(var/facialhairstyle in facial_hair_styles_list)
			var/datum/sprite_accessory/S = facial_hair_styles_list[facialhairstyle]
			if(gender == MALE && S.gender == FEMALE)
				continue
			if(gender == FEMALE && S.gender == MALE)
				continue
			if(!(spec.get_bodytype() in S.species_allowed))
				continue

			valid_facialhairstyles[facialhairstyle] = facial_hair_styles_list[facialhairstyle]

		var/new_f_style = input(user, "Choose your character's facial-hair style:", "Character Preference", f_style)  as null|anything in valid_facialhairstyles
		if(new_f_style && has_flag(spec, HAS_HAIR_COLOR) && CanUseTopic(user))
			f_style = new_f_style

	else if(href_list["reset_limbs"])
		reset_limbs()

	else if(href_list["limbs"])

		var/list/limb_selection_list = list("Left Leg","Right Leg","Left Arm","Right Arm","Left Foot","Right Foot","Left Hand","Right Hand","Full Body")

		// Full prosthetic bodies without a brain are borderline unkillable so make sure they have a brain to remove/destroy.
		var/datum/species/current_species = all_species[species]
		if(current_species.spawn_flags & SPECIES_NO_FBP_CHARGEN)
			limb_selection_list -= "Full Body"
		else if(organ_data[BP_CHEST] == "cyborg")
			limb_selection_list |= "Head"

		var/organ_tag = input(user, "Which limb do you want to change?") as null|anything in limb_selection_list

		if(!organ_tag || !CanUseTopic(user)) return

		var/limb = null
		var/second_limb = null // if you try to change the arm, the hand should also change
		var/third_limb = null  // if you try to unchange the hand, the arm should also change

		// Do not let them amputate their entire body, ty.
		var/list/choice_options = list("Normal","Amputated","Prosthesis")

		//Dare ye who decides to one day make fbps be able to have fleshy bits. Heed my warning, recursion is a bitch. - Snapshot
		if(organ_data[BP_CHEST] == "cyborg")
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
		if(!new_state || !CanUseTopic(user)) return

		switch(new_state)
			if("Normal")
				if(limb == BP_CHEST)
					for(var/other_limb in (BP_ALL_LIMBS - BP_CHEST))
						organ_data[other_limb] = null
						rlimb_data[other_limb] = null
						for(var/internal_organ in list(BP_HEART,BP_EYES))
							organ_data[internal_organ] = null
				organ_data[limb] = null
				rlimb_data[limb] = null
				if(third_limb)
					organ_data[third_limb] = null
					rlimb_data[third_limb] = null
			if("Amputated")
				if(limb == BP_CHEST)
					return
				organ_data[limb] = "amputated"
				rlimb_data[limb] = null
				if(second_limb)
					organ_data[second_limb] = "amputated"
					rlimb_data[second_limb] = null

			if("Prosthesis")
				var/tmp_species = species ? species : SPECIES_HUMAN
				var/list/usable_manufacturers = list()
				for(var/company in chargen_robolimbs)
					var/datum/robolimb/M = chargen_robolimbs[company]
					if(tmp_species in M.species_cannot_use)
						continue
					if(M.restricted_to.len && !(tmp_species in M.restricted_to))
						continue
					if(M.applies_to_part.len && !(limb in M.applies_to_part))
						continue
					usable_manufacturers[company] = M
				if(!usable_manufacturers.len)
					return
				var/choice = input(user, "Which manufacturer do you wish to use for this limb?") as null|anything in usable_manufacturers
				if(!choice)
					return
				rlimb_data[limb] = choice
				organ_data[limb] = "cyborg"
				if(second_limb)
					rlimb_data[second_limb] = choice
					organ_data[second_limb] = "cyborg"
				if(third_limb && organ_data[third_limb] == "amputated")
					organ_data[third_limb] = null

				if(limb == BP_CHEST)
					for(var/other_limb in BP_ALL_LIMBS - BP_CHEST)
						organ_data[other_limb] = "cyborg"
						rlimb_data[other_limb] = choice
					if(!organ_data[BP_BRAIN])
						organ_data[BP_BRAIN] = "assisted"
					for(var/internal_organ in list(BP_HEART,BP_EYES))
						organ_data[internal_organ] = "mechanical"


	else if(href_list["organs"])
		var/organ_name = input(user, "Which internal function do you want to change?") as null|anything in list("Heart", "Eyes")
		if(!organ_name) return

		var/organ = null
		switch(organ_name)
			if("Heart")
				organ = BP_HEART
			if("Eyes")
				organ = BP_EYES

		var/list/organ_choices = list("Normal","Assisted","Synthetic")
		if(organ_data[BP_CHEST] == "cyborg")
			organ_choices -= "Normal"
			organ_choices += "Synthetic"

		var/new_state = input(user, "What state do you wish the organ to be in?") as null|anything in organ_choices
		if(!new_state) return

		switch(new_state)
			if("Normal")
				organ_data[organ] = null
			if("Assisted")
				organ_data[organ] = "assisted"
			if("Synthetic")
				organ_data[organ] = "mechanical"

	else if(href_list["disabilities"])
		var/disability_flag = text2num(href_list["disabilities"])
		disabilities ^= disability_flag

	else if(href_list["toggle_preview_value"])
		equip_preview_mob ^= text2num(href_list["toggle_preview_value"])

	else if(href_list["flavor_text"])
		switch(href_list["flavor_text"])
			if("open")
			if("general")
				var/msg = sanitize(input(usr,"Give a general description of your character. This will be shown regardless of clothing, and may include OOC notes and preferences.","Flavor Text",html_decode(flavor_texts[href_list["flavor_text"]])) as message, extra = 0)
				if(CanUseTopic(user))
					flavor_texts[href_list["flavor_text"]] = msg
			else
				var/msg = sanitize(input(usr,"Set the flavor text for your [href_list["flavor_text"]].","Flavor Text",html_decode(flavor_texts[href_list["flavor_text"]])) as message, extra = 0)
				if(CanUseTopic(user))
					flavor_texts[href_list["flavor_text"]] = msg
		SetFlavorText(user)


	else if(href_list["flavour_text_robot"])
		switch(href_list["flavour_text_robot"])
			if("open")
			if("Default")
				var/msg = sanitize(input(usr,"Set the default flavour text for your robot. It will be used for any module without individual setting.","Flavour Text",html_decode(flavour_texts_robot["Default"])) as message, extra = 0)
				if(CanUseTopic(user))
					flavour_texts_robot[href_list["flavour_text_robot"]] = msg
			else
				var/msg = sanitize(input(usr,"Set the flavour text for your robot with [href_list["flavour_text_robot"]] module. If you leave this empty, default flavour text will be used for this module.","Flavour Text",html_decode(flavour_texts_robot[href_list["flavour_text_robot"]])) as message, extra = 0)
				if(CanUseTopic(user))
					flavour_texts_robot[href_list["flavour_text_robot"]] = msg
		SetFlavourTextRobot(user)

	else if(href_list["change_backpack"])
		var/new_backbag = input(user, "Choose your character's style of bag:", "Character Preference", backbaglist[backbag]) as null|anything in backbaglist
		if(!isnull(new_backbag) && CanUseTopic(user))
			backbag = backbaglist.Find(new_backbag)

	else if(href_list["change_underwear"])
		var/datum/category_group/underwear/UWC = global_underwear.categories_by_name[href_list["change_underwear"]]
		if(!UWC)
			return
		var/datum/category_item/underwear/selected_underwear = input(user, "Choose underwear:", "Character Preference", all_underwear[UWC.name]) as null|anything in UWC.items
		if(selected_underwear && CanUseTopic(user))
			all_underwear[UWC.name] = selected_underwear.name

	else if(href_list["underwear"] && href_list["tweak"])
		var/underwear = href_list["underwear"]
		if(!(underwear in all_underwear))
			return
		var/datum/gear_tweak/gt = locate(href_list["tweak"])
		if(!gt)
			return
		var/new_metadata = gt.get_metadata(usr, get_metadata(underwear, gt))
		if(new_metadata)
			set_metadata(underwear, gt, new_metadata)

	else
		return 0

	ShowChoices(usr)
	return 1





/datum/preferences/proc/is_allowed_language(var/mob/user, var/datum/language/lang)
	if(!user)
		return TRUE
	var/datum/species/S = all_species[species]
	if(lang.name in S.secondary_langs)
		return TRUE
	if(!(lang.flags & RESTRICTED) && is_alien_whitelisted(user, lang))
		return TRUE
	return FALSE

/datum/preferences/proc/has_flag(var/datum/species/species, var/flag)
	return species && (species.appearance_flags & flag)

/datum/preferences/proc/sanitize_alt_languages()
	var/preference_mob = preference_mob()
	for(var/L in alternate_languages)
		var/datum/language/lang = all_languages[L]
		if(!lang || !is_allowed_language(preference_mob, lang))
			alternate_languages -= L

	var/datum/species/S = all_species[species] || all_species[SPECIES_HUMAN]
	if(alternate_languages.len > S.num_alternate_languages)
		alternate_languages.Cut(S.num_alternate_languages + 1)

	alternate_languages = uniquelist(alternate_languages)

/datum/preferences/proc/reset_limbs()
	organ_data.Cut()
	rlimb_data.Cut()

/datum/preferences/proc/SetSpecies(mob/user)
	if(!species_preview || !(species_preview in all_species))
		species_preview = SPECIES_HUMAN
	var/datum/species/current_species = all_species[species_preview]
	var/dat = "<body>"
	dat += "<center><h2>[current_species.name] \[<a href='?src=\ref[src];show_species=1'>change</a>\]</h2></center><hr/>"
	dat += "<table padding='8px'>"
	dat += "<tr>"
	dat += "<td width = 400>[current_species.blurb]</td>"
	dat += "<td width = 200 align='center'>"
	if("preview" in icon_states(current_species.get_icobase()))
		usr << browse_rsc(icon(current_species.get_icobase(),"preview"), "species_preview_[current_species.name].png")
		dat += "<img src='species_preview_[current_species.name].png' width='64px' height='64px'><br/><br/>"
	dat += "<b>Language:</b> [current_species.language]<br/>"
	dat += "<small>"
	if(current_species.spawn_flags & SPECIES_CAN_JOIN)
		dat += "</br><b>Often present among humans.</b>"
	if(current_species.spawn_flags & SPECIES_IS_WHITELISTED)
		dat += "</br><b>Whitelist restricted.</b>"
	if(!current_species.has_organ[BP_HEART])
		dat += "</br><b>Does not have blood.</b>"
	if(!current_species.has_organ[BP_LUNGS])
		dat += "</br><b>Does not breathe.</b>"
	if(current_species.flags & NO_SCAN)
		dat += "</br><b>Does not have DNA.</b>"
	if(current_species.flags & NO_PAIN)
		dat += "</br><b>Does not feel pain.</b>"
	if(current_species.flags & NO_SLIP)
		dat += "</br><b>Has excellent traction.</b>"
	if(current_species.flags & NO_POISON)
		dat += "</br><b>Immune to most poisons.</b>"
	if(current_species.appearance_flags & HAS_SKIN_TONE)
		dat += "</br><b>Has a variety of skin tones.</b>"
	if(current_species.appearance_flags & HAS_SKIN_COLOR)
		dat += "</br><b>Has a variety of skin colours.</b>"
	if(current_species.appearance_flags & HAS_EYE_COLOR)
		dat += "</br><b>Has a variety of eye colours.</b>"
	if(current_species.flags & IS_PLANT)
		dat += "</br><b>Has a plantlike physiology.</b>"
	dat += "</small></td>"
	dat += "</tr>"
	dat += "</table><center><hr/>"

	var/restricted = 0
	if(config.usealienwhitelist) //If we're using the whitelist, make sure to check it!
		if(!(current_species.spawn_flags & SPECIES_CAN_JOIN))
			restricted = 2
		else if((current_species.spawn_flags & SPECIES_IS_WHITELISTED) && !is_alien_whitelisted(preference_mob(),current_species))
			restricted = 1

	if(restricted)
		if(restricted == 1)
			dat += "<font color='red'><b>You cannot play as this species.</br><small>If you wish to be whitelisted, you can make an application post on <a href='?src=\ref[user];preference=open_whitelist_forum'>the forums</a>.</small></b></font></br>"
		else if(restricted == 2)
			dat += "<font color='red'><b>You cannot play as this species.</br><small>This species is not available as a player race.</small></b></font></br>"
	if(!restricted || check_rights(R_ADMIN, 0))
		dat += "\[<a href='?src=\ref[src];set_species=[species_preview]'>select</a>\]"
	dat += "</center></body>"

	user << browse(dat, "window=species;size=700x400")

/datum/preferences/proc/preference_mob()
	if(!client)
		for(var/client/C)
			if(C.ckey == client_ckey)
				client = C
				break

	if(client)
		return client.mob