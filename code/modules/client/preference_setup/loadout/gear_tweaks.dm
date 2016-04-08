/datum/gear_tweak/proc/get_contents(var/metadata)
	return

/datum/gear_tweak/proc/get_metadata(var/user, var/metadata)
	return

/datum/gear_tweak/proc/get_default()
	return

/datum/gear_tweak/proc/apply_tweak(var/obj/item/I, var/metadata)
	return

/*
* Color adjustment
*/

var/datum/gear_tweak/color/gear_tweak_free_color_choice = new()

/datum/gear_tweak/color
	var/list/valid_colors

/datum/gear_tweak/color/New(var/list/valid_colors)
	src.valid_colors = valid_colors
	..()

/datum/gear_tweak/color/get_contents(var/metadata)
	return "(Color<font color='[metadata]'>&#9899;</font>)"

/datum/gear_tweak/color/get_default()
	return valid_colors ? valid_colors[1] : COLOR_GRAY

/datum/gear_tweak/color/get_metadata(var/user, var/metadata)
	if(valid_colors)
		return input(user, "Choose an item color.", "Character Preference", metadata) as null|anything in valid_colors
	return input(user, "Choose an item color.", "Global Preference", metadata) as color|null

/datum/gear_tweak/color/apply_tweak(var/obj/item/I, var/metadata)
	if(valid_colors && !(metadata in valid_colors))
		return
	I.color = metadata
