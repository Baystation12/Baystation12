/datum/category_item/player_setup_item/general/eros
	name = "Erotic"
	sort_order = 7

/datum/category_item/player_setup_item/general/eros/load_character(var/savefile/S)
	S["c_type"]				>> pref.c_type
	S["d_type"]				>> pref.d_type
	S["v_type"]				>> pref.v_type
	S["r_genital"]			>> pref.r_genital
	S["g_genital"]			>> pref.g_genital
	S["b_genital"]			>> pref.b_genital
	S["r_wings"]			>> pref.r_wings
	S["g_wings"]			>> pref.g_wings
	S["b_wings"]			>> pref.b_wings
	S["r_ears"]				>> pref.r_ears
	S["g_ears"]				>> pref.g_ears
	S["b_ears"]				>> pref.b_ears
	S["r_tail"]				>> pref.r_tail
	S["g_tail"]				>> pref.g_tail
	S["b_tail"]				>> pref.b_tail
	S["ears_type"]			>> pref.ears_type
	S["wings_type"]			>> pref.wings_type
	S["tail_type"]			>> pref.tail_type

/datum/category_item/player_setup_item/general/eros/save_character(var/savefile/S)
	S["c_type"]				<< pref.c_type
	S["d_type"]				<< pref.d_type
	S["v_type"]				<< pref.v_type
	S["r_genital"]			<< pref.r_genital
	S["g_genital"]			<< pref.g_genital
	S["b_genital"]			<< pref.b_genital
	S["r_wings"]			<< pref.r_wings
	S["g_wings"]			<< pref.g_wings
	S["b_wings"]			<< pref.b_wings
	S["r_ears"]				<< pref.r_ears
	S["g_ears"]				<< pref.g_ears
	S["b_ears"]				<< pref.b_ears
	S["r_tail"]				<< pref.r_tail
	S["g_tail"]				<< pref.g_tail
	S["b_tail"]				<< pref.b_tail
	S["ears_type"]			<< pref.ears_type
	S["wings_type"]			<< pref.wings_type
	S["tail_type"]			<< pref.tail_type

/datum/category_item/player_setup_item/general/eros/sanitize_character(var/savefile/S)
	pref.c_type			= sanitize_inlist(pref.c_type, body_breast_list, initial(pref.c_type))
	pref.d_type			= sanitize_inlist(pref.d_type, body_dicks_list, initial(pref.d_type))
	pref.v_type			= sanitize_inlist(pref.v_type, body_vaginas_list, initial(pref.v_type))
	pref.r_genital		= sanitize_integer(pref.r_genital, 0, 255, initial(pref.r_genital))
	pref.g_genital		= sanitize_integer(pref.g_genital, 0, 255, initial(pref.g_genital))
	pref.b_genital		= sanitize_integer(pref.b_genital, 0, 255, initial(pref.b_genital))
	pref.ears_type		= sanitize_inlist(pref.ears_type, body_ears_list, initial(pref.ears_type))
	pref.wings_type		= sanitize_inlist(pref.wings_type, body_wings_list, initial(pref.wings_type))
	pref.tail_type		= sanitize_inlist(pref.tail_type, body_tails_list, initial(pref.tail_type))
	pref.r_wings		= sanitize_integer(pref.r_wings, 0, 255, initial(pref.r_wings))
	pref.g_wings		= sanitize_integer(pref.g_wings, 0, 255, initial(pref.g_wings))
	pref.b_wings		= sanitize_integer(pref.b_wings, 0, 255, initial(pref.b_wings))
	pref.r_ears			= sanitize_integer(pref.r_ears, 0, 255, initial(pref.r_ears))
	pref.g_ears			= sanitize_integer(pref.g_ears, 0, 255, initial(pref.g_ears))
	pref.b_ears			= sanitize_integer(pref.b_ears, 0, 255, initial(pref.b_ears))
	pref.r_tail			= sanitize_integer(pref.r_tail, 0, 255, initial(pref.r_tail))
	pref.g_tail			= sanitize_integer(pref.g_tail, 0, 255, initial(pref.g_tail))
	pref.b_tail			= sanitize_integer(pref.b_tail, 0, 255, initial(pref.b_tail))


/datum/category_item/player_setup_item/general/eros/content(var/mob/user)


	. += "<table><tr style='vertical-align:top'><td><b>Sexual Organs</b> "
	. += "<br>"
	. += "Chest Type: <a href='?src=\ref[src];chest_type=1'>[pref.c_type]</a><br>"
	. += "Dick Type: <a href='?src=\ref[src];dick_type=1'>[pref.d_type]</a><br>"
	. += "Vagina Type: <a href='?src=\ref[src];vagina_type=1'>[pref.v_type]</a><br>"
	. += "<b>Genitals Color</b><br>"
	. += "<a href='?src=\ref[src];genital_color=1'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_genital, 2)][num2hex(pref.g_genital, 2)][num2hex(pref.b_genital, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_genital, 2)][num2hex(pref.g_genital, 2)][num2hex(pref.b_genital)]'><tr><td>__</td></tr></table></font><br>"
	. += "<br>"
	. += "<table><tr style='vertical-align:top'><td><b>Body Modifications</b> "
	. += "<br>"
	. += "Ears Type: <a href='?src=\ref[src];cears_type=1'>[pref.ears_type]</a><br>"
	. += "<a href='?src=\ref[src];ears_color=1'>Ear Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_ears, 2)][num2hex(pref.g_ears, 2)][num2hex(pref.b_ears, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_ears, 2)][num2hex(pref.g_ears, 2)][num2hex(pref.b_ears)]'><tr><td>__</td></tr></table></font><br>"
	var/datum/species/S = all_species[pref.species]
	var/taur_override = S.taur_override
	. += "<br>"
	if(taur_override)
		. += "Tail Type: <font color='grey'>[taur_override]</font><br>"
	else
		. += "Tail Type: <a href='?src=\ref[src];ctail_type=1'>[pref.tail_type]</a><br>"
	. += "<a href='?src=\ref[src];tail_color=1'>Tail Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_tail, 2)][num2hex(pref.g_tail, 2)][num2hex(pref.b_tail, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_tail, 2)][num2hex(pref.g_tail, 2)][num2hex(pref.b_tail)]'><tr><td>__</td></tr></table></font><br>"
	. += "<br>"
	. += "Wings Type: <a href='?src=\ref[src];cwings_type=1'>[pref.wings_type]</a><br>"
	. += "<a href='?src=\ref[src];wings_color=1'>Wings Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_wings, 2)][num2hex(pref.g_wings, 2)][num2hex(pref.b_wings, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_wings, 2)][num2hex(pref.g_wings, 2)][num2hex(pref.b_wings)]'><tr><td>__</td></tr></table></font><br>"


/datum/category_item/player_setup_item/general/eros/OnTopic(var/href,var/list/href_list, var/mob/user)

	var/datum/species/mob_species = all_species[pref.species]

	if(href_list["chest_type"])
		var/list/valid_chest_types = list()
		for (var/boobs in body_breast_list)
			var/datum/sprite_accessory/S = body_breast_list[boobs]
			if(!(mob_species.get_bodytype() in S.species_allowed))
				continue
			valid_chest_types[boobs] = body_breast_list[boobs]
			if (valid_chest_types.len)
				pref.c_type = pick(valid_chest_types)
			else
				pref.c_type = body_breast_list["None"]
		var/new_c_type = input(user, "Choose your character's Chest Type:", "Character Preference") as null|anything in valid_chest_types
		if(new_c_type && CanUseTopic(user))
			pref.c_type = new_c_type
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["dick_type"])
		var/list/valid_dick_types = list()
		for (var/dicks in body_dicks_list)
			var/datum/sprite_accessory/S = body_dicks_list[dicks]
			if(!(mob_species.get_bodytype() in S.species_allowed))
				continue
			valid_dick_types[dicks] = body_dicks_list[dicks]
			if (valid_dick_types.len)
				pref.d_type = pick(valid_dick_types)
			else
				pref.d_type = body_dicks_list["None"]
		var/new_d_type = input(user, "Choose your character's Dick:", "Character Preference") as null|anything in valid_dick_types
		if(new_d_type && CanUseTopic(user))
			pref.d_type = new_d_type
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["vagina_type"])
		var/list/valid_vagina_types = list()
		for (var/vaginas in body_vaginas_list)
			var/datum/sprite_accessory/S = body_vaginas_list[vaginas]
			if(!(mob_species.get_bodytype() in S.species_allowed))
				continue
			valid_vagina_types[vaginas] = body_vaginas_list[vaginas]
			if (valid_vagina_types.len)
				pref.v_type = pick(valid_vagina_types)
			else
				pref.v_type = body_vaginas_list["None"]
		var/new_v_type = input(user, "Choose your character's Vagina:", "Character Preference") as null|anything in valid_vagina_types
		if(new_v_type && CanUseTopic(user))
			pref.v_type = new_v_type
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["genital_color"])
		var/new_genital = input(user, "Choose your character's Genitals colour: ", "Character Preference", rgb(pref.r_genital, pref.g_genital, pref.b_genital)) as color|null
		pref.r_genital = hex2num(copytext(new_genital, 2, 4))
		pref.g_genital = hex2num(copytext(new_genital, 4, 6))
		pref.b_genital = hex2num(copytext(new_genital, 6, 8))
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["cears_type"])
		var/list/valid_ears_types = list()
		for (var/ears in body_ears_list)
			var/datum/sprite_accessory/S = body_ears_list[ears]
			if(!(mob_species.get_bodytype() in S.species_allowed))
				continue
			valid_ears_types[ears] = body_ears_list[ears]
			if (valid_ears_types.len)
				pref.ears_type = pick(valid_ears_types)
			else
				pref.ears_type = body_ears_list["None"]
		var/new_ears_type = input(user, "Choose your character's Ears:", "Character Preference") as null|anything in valid_ears_types
		if(new_ears_type && CanUseTopic(user))
			pref.ears_type = new_ears_type
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["cwings_type"])
		var/list/valid_wings_types = list()
		for (var/wings in body_wings_list)
			var/datum/sprite_accessory/S = body_wings_list[wings]
			if(!(mob_species.get_bodytype() in S.species_allowed))
				continue
			valid_wings_types[wings] = body_wings_list[wings]
			if (valid_wings_types.len)
				pref.wings_type = pick(valid_wings_types)
			else
				pref.wings_type = body_wings_list["None"]
		var/new_wings_type = input(user, "Choose your character's Wings:", "Character Preference") as null|anything in valid_wings_types
		if(new_wings_type && CanUseTopic(user))
			pref.wings_type = new_wings_type
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["ctail_type"])
		var/list/valid_tails_types = list()
		for (var/tails in body_tails_list)
			var/datum/sprite_accessory/S = body_tails_list[tails]
			if(!(mob_species.get_bodytype() in S.species_allowed))
				continue
			valid_tails_types[tails] = body_tails_list[tails]
			if (valid_tails_types.len)
				pref.tail_type = pick(valid_tails_types)
			else
				pref.tail_type = body_tails_list["None"]
		var/new_tail_type = input(user, "Choose your character's Tail:", "Character Preference") as null|anything in valid_tails_types
		if(new_tail_type && CanUseTopic(user))
			pref.tail_type = new_tail_type
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["wings_color"])
		var/new_wings = input(user, "Choose your character's Wings colour: ", "Character Preference", rgb(pref.r_wings, pref.g_wings, pref.b_wings)) as color|null
		pref.r_wings = hex2num(copytext(new_wings, 2, 4))
		pref.g_wings = hex2num(copytext(new_wings, 4, 6))
		pref.b_wings = hex2num(copytext(new_wings, 6, 8))
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["ears_color"])
		var/new_ears = input(user, "Choose your character's Ears colour: ", "Character Preference", rgb(pref.r_ears, pref.g_ears, pref.b_ears)) as color|null
		pref.r_ears = hex2num(copytext(new_ears, 2, 4))
		pref.g_ears = hex2num(copytext(new_ears, 4, 6))
		pref.b_ears = hex2num(copytext(new_ears, 6, 8))
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["tail_color"])
		var/new_tail = input(user, "Choose your character's Tail colour: ", "Character Preference", rgb(pref.r_tail, pref.g_tail, pref.b_tail)) as color|null
		pref.r_tail = hex2num(copytext(new_tail, 2, 4))
		pref.g_tail = hex2num(copytext(new_tail, 4, 6))
		pref.b_tail = hex2num(copytext(new_tail, 6, 8))
		return TOPIC_REFRESH_UPDATE_PREVIEW