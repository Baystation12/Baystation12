// Global stuff that will put us on the map
/datum/category_group/player_setup_category/Mithra
	name = "Genemods"
	sort_order = 9
	category_item_type = /datum/category_item/player_setup_item/vore

// Define a place to save appearance in character setup
/datum/preferences
	var/ear_style		// Type of selected ear style
	var/r_ears = 30		// Ear color.
	var/g_ears = 30		// Ear color
	var/b_ears = 30		// Ear color
	var/r_ears2 = 30	// Ear extra color.
	var/g_ears2 = 30	// Ear extra color
	var/b_ears2 = 30	// Ear extra color
	var/tail_style		// Type of selected tail style
	var/r_tail = 30		// Tail/Taur color
	var/g_tail = 30		// Tail/Taur color
	var/b_tail = 30		// Tail/Taur color
	var/r_tail2 = 30	// For extra overlay.
	var/g_tail2 = 30	// For extra overlay.
	var/b_tail2 = 30	// For extra overlay.
	var/r_tail3 = 30	// For extra overlay.
	var/g_tail3 = 30	// For extra overlay.
	var/b_tail3 = 30	// For extra overlay.
	var/wing_style		// Type of selected wing style
	var/r_wing = 30		// Wing color
	var/g_wing = 30		// Wing color
	var/b_wing = 30		// Wing color
	var/r_wing2 = 30	// For extra overlay.
	var/g_wing2 = 30	// For extra overlay.
	var/b_wing2 = 30	// For extra overlay.
	var/r_wing3 = 30	// For extra overlay.
	var/g_wing3 = 30	// For extra overlay.
	var/b_wing3 = 30	// For extra overlay.
	var/dress_mob = TRUE

// Definition of the stuff for Ears
/datum/category_item/player_setup_item/vore/ears
	name = "Appearance"
	sort_order = 1

/datum/category_item/player_setup_item/vore/ears/load_character(var/savefile/S)
	from_file(S["ear_style"], pref.ear_style)
	from_file(S["r_ears"], pref.r_ears)
	from_file(S["g_ears"], pref.g_ears)
	from_file(S["b_ears"], pref.b_ears)
	from_file(S["r_ears2"], pref.r_ears2)
	from_file(S["g_ears2"], pref.g_ears2)
	from_file(S["b_ears2"], pref.b_ears2)
	from_file(S["tail_style"], pref.tail_style)
	from_file(S["r_tail"], pref.r_tail)
	from_file(S["g_tail"], pref.g_tail)
	from_file(S["b_tail"], pref.b_tail)
	from_file(S["r_tail2"], pref.r_tail2)
	from_file(S["g_tail2"], pref.g_tail2)
	from_file(S["b_tail2"], pref.b_tail2)
	from_file(S["r_tail3"], pref.r_tail3)
	from_file(S["g_tail3"], pref.g_tail3)
	from_file(S["b_tail3"], pref.b_tail3)
	from_file(S["wing_style"], pref.wing_style)
	from_file(S["r_wing"], pref.r_wing)
	from_file(S["g_wing"], pref.g_wing)
	from_file(S["b_wing"], pref.b_wing)
	from_file(S["r_wing2"], pref.r_wing2)
	from_file(S["g_wing2"], pref.g_wing2)
	from_file(S["b_wing2"], pref.b_wing2)
	from_file(S["r_wing3"], pref.r_wing3)
	from_file(S["g_wing3"], pref.g_wing3)
	from_file(S["b_wing3"], pref.b_wing3)

/datum/category_item/player_setup_item/vore/ears/save_character(var/savefile/S)
	to_file(S["ear_style"], pref.ear_style)
	to_file(S["r_ears"], pref.r_ears)
	to_file(S["g_ears"], pref.g_ears)
	to_file(S["b_ears"], pref.b_ears)
	to_file(S["r_ears2"], pref.r_ears2)
	to_file(S["g_ears2"], pref.g_ears2)
	to_file(S["b_ears2"], pref.b_ears2)
	to_file(S["tail_style"], pref.tail_style)
	to_file(S["r_tail"], pref.r_tail)
	to_file(S["g_tail"], pref.g_tail)
	to_file(S["b_tail"], pref.b_tail)
	to_file(S["r_tail2"], pref.r_tail2)
	to_file(S["g_tail2"], pref.g_tail2)
	to_file(S["b_tail2"], pref.b_tail2)
	to_file(S["r_tail3"], pref.r_tail3)
	to_file(S["g_tail3"], pref.g_tail3)
	to_file(S["b_tail3"], pref.b_tail3)
	to_file(S["wing_style"], pref.wing_style)
	to_file(S["r_wing"], pref.r_wing)
	to_file(S["g_wing"], pref.g_wing)
	to_file(S["b_wing"], pref.b_wing)
	to_file(S["r_wing2"], pref.r_wing2)
	to_file(S["g_wing2"], pref.g_wing2)
	to_file(S["b_wing2"], pref.b_wing2)
	to_file(S["r_wing3"], pref.r_wing3)
	to_file(S["g_wing3"], pref.g_wing3)
	to_file(S["b_wing3"], pref.b_wing3)

/datum/category_item/player_setup_item/vore/ears/sanitize_character()
	pref.r_ears		= sanitize_integer(pref.r_ears, 0, 255, initial(pref.r_ears))
	pref.g_ears		= sanitize_integer(pref.g_ears, 0, 255, initial(pref.g_ears))
	pref.b_ears		= sanitize_integer(pref.b_ears, 0, 255, initial(pref.b_ears))
	pref.r_ears2	= sanitize_integer(pref.r_ears2, 0, 255, initial(pref.r_ears2))
	pref.g_ears2	= sanitize_integer(pref.g_ears2, 0, 255, initial(pref.g_ears2))
	pref.b_ears2	= sanitize_integer(pref.b_ears2, 0, 255, initial(pref.b_ears2))
	pref.r_tail		= sanitize_integer(pref.r_tail, 0, 255, initial(pref.r_tail))
	pref.g_tail		= sanitize_integer(pref.g_tail, 0, 255, initial(pref.g_tail))
	pref.b_tail		= sanitize_integer(pref.b_tail, 0, 255, initial(pref.b_tail))
	pref.r_tail2	= sanitize_integer(pref.r_tail2, 0, 255, initial(pref.r_tail2))
	pref.g_tail2	= sanitize_integer(pref.g_tail2, 0, 255, initial(pref.g_tail2))
	pref.b_tail2	= sanitize_integer(pref.b_tail2, 0, 255, initial(pref.b_tail2))
	pref.r_tail3	= sanitize_integer(pref.r_tail3, 0, 255, initial(pref.r_tail3))
	pref.g_tail3	= sanitize_integer(pref.g_tail3, 0, 255, initial(pref.g_tail3))
	pref.b_tail3	= sanitize_integer(pref.b_tail3, 0, 255, initial(pref.b_tail3))
	pref.r_wing		= sanitize_integer(pref.r_wing, 0, 255, initial(pref.r_wing))
	pref.g_wing		= sanitize_integer(pref.g_wing, 0, 255, initial(pref.g_wing))
	pref.b_wing		= sanitize_integer(pref.b_wing, 0, 255, initial(pref.b_wing))
	pref.r_wing2		= sanitize_integer(pref.r_wing2, 0, 255, initial(pref.r_wing2))
	pref.g_wing2		= sanitize_integer(pref.g_wing2, 0, 255, initial(pref.g_wing2))
	pref.b_wing2		= sanitize_integer(pref.b_wing2, 0, 255, initial(pref.b_wing2))
	pref.r_wing3		= sanitize_integer(pref.r_wing3, 0, 255, initial(pref.r_wing3))
	pref.g_wing3		= sanitize_integer(pref.g_wing3, 0, 255, initial(pref.g_wing3))
	pref.b_wing3		= sanitize_integer(pref.b_wing3, 0, 255, initial(pref.b_wing3))
	if(pref.ear_style)
		pref.ear_style	= sanitize_inlist(pref.ear_style, ear_styles_list, initial(pref.ear_style))
	if(pref.tail_style)
		pref.tail_style	= sanitize_inlist(pref.tail_style, tail_styles_list, initial(pref.tail_style))
	if(pref.wing_style)
		pref.wing_style	= sanitize_inlist(pref.wing_style, wing_styles_list, initial(pref.wing_style))

/datum/preferences/copy_to(mob/living/carbon/human/character, is_preview_copy = FALSE)
	..()
	character.ear_style			= ear_styles_list[ear_style]
	character.r_ears			= r_ears
	character.b_ears			= b_ears
	character.g_ears			= g_ears
	character.r_ears2			= r_ears2
	character.b_ears2			= b_ears2
	character.g_ears2			= g_ears2
	character.tail_style		= tail_styles_list[tail_style]
	character.r_tail			= r_tail
	character.b_tail			= b_tail
	character.g_tail			= g_tail
	character.r_tail2			= r_tail2
	character.b_tail2			= b_tail2
	character.g_tail2			= g_tail2
	character.r_tail3			= r_tail3
	character.b_tail3			= b_tail3
	character.g_tail3			= g_tail3
	character.wing_style		= wing_styles_list[wing_style]
	character.r_wing			= r_wing
	character.b_wing			= b_wing
	character.g_wing			= g_wing
	character.r_wing2			= r_wing2
	character.b_wing2			= b_wing2
	character.g_wing2			= g_wing2
	character.r_wing3			= r_wing3
	character.b_wing3			= b_wing3
	character.g_wing3			= g_wing3





/datum/category_item/player_setup_item/vore/ears/content(var/mob/user)
	. += "<h2>Genemod Selection</h2>"

	if(!pref.preview_icon)
		pref.update_preview_icon()
 	user << browse_rsc(pref.preview_icon, "previewicon.png")

	. += "<b>Preview</b><br>"
	. += "<div class='statusDisplay'><center><img src=previewicon.png width=[pref.preview_icon.Width()] height=[pref.preview_icon.Height()]></center></div>"
	. += "<br><a href='?src=\ref[src];toggle_clothing=1'>[pref.dress_mob ? "Hide equipment" : "Show equipment"]</a><br>"

	var/ear_display = "Normal"
	if(pref.ear_style && (pref.ear_style in ear_styles_list))
		var/datum/sprite_accessory/ears/instance = ear_styles_list[pref.ear_style]
		ear_display = instance.name

	else if(pref.ear_style)
		ear_display = "REQUIRES UPDATE"
	. += "<b>Ears</b><br>"
	. += " Style: <a href='?src=\ref[src];ear_style=1'>[ear_display]</a><br>"
	if(ear_styles_list[pref.ear_style])
		var/datum/sprite_accessory/ears/ear = ear_styles_list[pref.ear_style]
		if (ear.do_colouration)
			. += "<a href='?src=\ref[src];ear_color=1'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_ears, 2)][num2hex(pref.g_ears, 2)][num2hex(pref.b_ears, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_ears, 2)][num2hex(pref.g_ears, 2)][num2hex(pref.b_ears, 2)]'><tr><td>__</td></tr></table> </font><br>"
		if (ear.extra_overlay)
			. += "<a href='?src=\ref[src];ear_color2=1'>Change Secondary Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_ears2, 2)][num2hex(pref.g_ears2, 2)][num2hex(pref.b_ears2, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_ears2, 2)][num2hex(pref.g_ears2, 2)][num2hex(pref.b_ears2, 2)]'><tr><td>__</td></tr></table> </font><br>"

	var/tail_display = "Normal"
	if(pref.tail_style && (pref.tail_style in tail_styles_list))
		var/datum/sprite_accessory/tail/instance = tail_styles_list[pref.tail_style]
		tail_display = instance.name
	else if(pref.tail_style)
		tail_display = "REQUIRES UPDATE"
	. += "<b>Tail</b><br>"
	. += " Style: <a href='?src=\ref[src];tail_style=1'>[tail_display]</a><br>"

	if(tail_styles_list[pref.tail_style])
		var/datum/sprite_accessory/tail/T = tail_styles_list[pref.tail_style]
		if (T.do_colouration)
			. += "<a href='?src=\ref[src];tail_color=1'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_tail, 2)][num2hex(pref.g_tail, 2)][num2hex(pref.b_tail, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_tail, 2)][num2hex(pref.g_tail, 2)][num2hex(pref.b_tail, 2)]'><tr><td>__</td></tr></table> </font><br>"
		if (T.extra_overlay)
			. += "<a href='?src=\ref[src];tail_color2=1'>Change Secondary Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_tail2, 2)][num2hex(pref.g_tail2, 2)][num2hex(pref.b_tail2, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_tail2, 2)][num2hex(pref.g_tail2, 2)][num2hex(pref.b_tail2, 2)]'><tr><td>__</td></tr></table> </font><br>"
		if (T.extra_overlay2)
			. += "<a href='?src=\ref[src];tail_color3=1'>Change tertiary Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_tail3, 2)][num2hex(pref.g_tail3, 2)][num2hex(pref.b_tail3, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_tail3, 2)][num2hex(pref.g_tail3, 2)][num2hex(pref.b_tail3, 2)]'><tr><td>__</td></tr></table> </font><br>"

	var/wing_display = "Normal"
	if(pref.wing_style && (pref.wing_style in wing_styles_list))
		var/datum/sprite_accessory/wing/instance = wing_styles_list[pref.wing_style]
		wing_display = instance.name
	else if(pref.wing_style)
		wing_display = "REQUIRES UPDATE"
	. += "<b>Wing</b><br>"
	. += " Style: <a href='?src=\ref[src];wing_style=1'>[wing_display]</a><br>"

	if(wing_styles_list[pref.wing_style])
		var/datum/sprite_accessory/wing/T = wing_styles_list[pref.wing_style]
		if (T.do_colouration)
			. += "<a href='?src=\ref[src];wing_color=1'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_wing, 2)][num2hex(pref.g_wing, 2)][num2hex(pref.b_wing, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_wing, 2)][num2hex(pref.g_wing, 2)][num2hex(pref.b_wing, 2)]'><tr><td>__</td></tr></table> </font><br>"
		if (T.extra_overlay)
			. += "<a href='?src=\ref[src];wing_color2=1'>Change Secondary Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_wing2, 2)][num2hex(pref.g_wing2, 2)][num2hex(pref.b_wing2, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_wing2, 2)][num2hex(pref.g_wing2, 2)][num2hex(pref.b_wing2, 2)]'><tr><td>__</td></tr></table> </font><br>"
		if (T.extra_overlay2)
			. += "<a href='?src=\ref[src];wing_color3=1'>Change tertiary Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_wing3, 2)][num2hex(pref.g_wing3, 2)][num2hex(pref.b_wing3, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_wing3, 2)][num2hex(pref.g_wing3, 2)][num2hex(pref.b_wing3, 2)]'><tr><td>__</td></tr></table> </font><br>"

/datum/category_item/player_setup_item/vore/ears/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(!CanUseTopic(user))
		return TOPIC_NOACTION

	else if(href_list["ear_style"])
		// Construct the list of names allowed for this user.
		var/list/pretty_ear_styles = list("Normal" = null)
		for(var/path in ear_styles_list)
			var/datum/sprite_accessory/ears/instance = ear_styles_list[path]
			if((!instance.ckeys_allowed) || (usr.ckey in instance.ckeys_allowed))
				pretty_ear_styles[instance.name] = path

		// Present choice to user
		var/new_ear_style = input(user, "Pick ears", "Character Preference", pref.ear_style) as null|anything in pretty_ear_styles
		if(new_ear_style)
			pref.ear_style = pretty_ear_styles[new_ear_style]

		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["ear_color"])
		var/new_earc = input(user, "Choose your character's ear colour:", "Character Preference",
			rgb(pref.r_ears, pref.g_ears, pref.b_ears)) as color|null
		if(new_earc)
			pref.r_ears = hex2num(copytext(new_earc, 2, 4))
			pref.g_ears = hex2num(copytext(new_earc, 4, 6))
			pref.b_ears = hex2num(copytext(new_earc, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["ear_color2"])
		var/new_earc2 = input(user, "Choose your character's ear colour:", "Character Preference",
			rgb(pref.r_ears2, pref.g_ears2, pref.b_ears2)) as color|null
		if(new_earc2)
			pref.r_ears2 = hex2num(copytext(new_earc2, 2, 4))
			pref.g_ears2 = hex2num(copytext(new_earc2, 4, 6))
			pref.b_ears2 = hex2num(copytext(new_earc2, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["tail_style"])
		// Construct the list of names allowed for this user.
		var/list/pretty_tail_styles = list("Normal" = null)
		for(var/path in tail_styles_list)
			var/datum/sprite_accessory/tail/instance = tail_styles_list[path]
			if((!instance.ckeys_allowed) || (user.ckey in instance.ckeys_allowed))
				pretty_tail_styles[instance.name] = path

		// Present choice to user
		var/new_tail_style = input(user, "Pick tails", "Character Preference", pref.tail_style) as null|anything in pretty_tail_styles
		if(new_tail_style)
			pref.tail_style = pretty_tail_styles[new_tail_style]

		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["tail_color"])
		var/new_tailc = input(user, "Choose your character's tail colour:", "Character Preference",
			rgb(pref.r_tail, pref.g_tail, pref.b_tail)) as color|null
		if(new_tailc)
			pref.r_tail = hex2num(copytext(new_tailc, 2, 4))
			pref.g_tail = hex2num(copytext(new_tailc, 4, 6))
			pref.b_tail = hex2num(copytext(new_tailc, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["tail_color2"])
		var/new_tailc2 = input(user, "Choose your character's secondary tail colour:", "Character Preference",
			rgb(pref.r_tail2, pref.g_tail2, pref.b_tail2)) as color|null
		if(new_tailc2)
			pref.r_tail2 = hex2num(copytext(new_tailc2, 2, 4))
			pref.g_tail2 = hex2num(copytext(new_tailc2, 4, 6))
			pref.b_tail2 = hex2num(copytext(new_tailc2, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["tail_color3"])
		var/new_tailc3 = input(user, "Choose your character's tertiary tail colour:", "Character Preference",
			rgb(pref.r_tail3, pref.g_tail3, pref.b_tail3)) as color|null
		if(new_tailc3)
			pref.r_tail3 = hex2num(copytext(new_tailc3, 2, 4))
			pref.g_tail3 = hex2num(copytext(new_tailc3, 4, 6))
			pref.b_tail3 = hex2num(copytext(new_tailc3, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["wing_style"])
		// Construct the list of names allowed for this user.
		var/list/pretty_wing_styles = list("Normal" = null)
		for(var/path in wing_styles_list)
			var/datum/sprite_accessory/wing/instance = wing_styles_list[path]
			if((!instance.ckeys_allowed) || (user.ckey in instance.ckeys_allowed))
				pretty_wing_styles[instance.name] = path

		// Present choice to user
		var/new_wing_style = input(user, "Pick wings", "Character Preference", pref.wing_style) as null|anything in pretty_wing_styles
		if(new_wing_style)
			pref.wing_style = pretty_wing_styles[new_wing_style]

		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["wing_color"])
		var/new_wingc = input(user, "Choose your character's wing colour:", "Character Preference",
			rgb(pref.r_wing, pref.g_wing, pref.b_wing)) as color|null
		if(new_wingc)
			pref.r_wing = hex2num(copytext(new_wingc, 2, 4))
			pref.g_wing = hex2num(copytext(new_wingc, 4, 6))
			pref.b_wing = hex2num(copytext(new_wingc, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["wing_color2"])
		var/new_wingc2 = input(user, "Choose your character's secondary wing colour:", "Character Preference",
			rgb(pref.r_wing2, pref.g_wing2, pref.b_wing2)) as color|null
		if(new_wingc2)
			pref.r_wing2 = hex2num(copytext(new_wingc2, 2, 4))
			pref.g_wing2 = hex2num(copytext(new_wingc2, 4, 6))
			pref.b_wing2 = hex2num(copytext(new_wingc2, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["wing_color3"])
		var/new_wingc3 = input(user, "Choose your character's tertiary wing colour:", "Character Preference",
			rgb(pref.r_wing3, pref.g_wing3, pref.b_wing3)) as color|null
		if(new_wingc3)
			pref.r_wing3 = hex2num(copytext(new_wingc3, 2, 4))
			pref.g_wing3 = hex2num(copytext(new_wingc3, 4, 6))
			pref.b_wing3 = hex2num(copytext(new_wingc3, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["toggle_clothing"])
		pref.dress_mob = !pref.dress_mob
		return TOPIC_REFRESH_UPDATE_PREVIEW

	return ..()
