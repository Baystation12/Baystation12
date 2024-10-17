/obj/item/clothing/suit/lasertag
	name = "laser tag armor"
	desc = "Colorful, unpadded, and otherwise useless armor meant for a game of laser tag."

	icon = 'icons/obj/clothing/lasertag.dmi'
	icon_state = "base"
	blood_overlay_type = "armor"
	item_flags = EMPTY_BITFIELD
	body_parts_covered = UPPER_TORSO
	allowed = list(/obj/item/gun/energy/lasertag)
	siemens_coefficient = 3

	/// String (6 digit HEX code). HEX code for the team color this laser-tag gun is for.
	var/team_color = "#333333"

	/// String. Human readable name of the team color.
	var/team_name


/obj/item/clothing/suit/lasertag/Initialize(mapload, _team_name, _team_color)
	. = ..()
	if (. == INITIALIZE_HINT_QDEL)
		return

	if (_team_name)
		set_team_name(_team_name)
	else if (team_name)
		set_team_name(team_name)
	else
		name = "[initial(name)] (Unset)"

	if (GLOB.lasertag_prefab_teams[team_name])
		set_color(GLOB.lasertag_prefab_teams[team_name])
	else if (_team_color)
		set_color(_team_color)
	else
		update_icon()


/obj/item/clothing/suit/lasertag/examine(mob/user)
	. = ..()

	if (team_name)
		to_chat(user, SPAN_INFO("The team display reads '[team_name].'"))
	else
		to_chat(user, SPAN_WARNING("There is no team set."))


/obj/item/clothing/suit/lasertag/on_update_icon()
	..()
	ClearOverlays()

	if (team_color)
		var/image/color_overlay = image(icon, src, "base_color")
		color_overlay.color = team_color
		AddOverlays(color_overlay)


/obj/item/clothing/suit/lasertag/set_color(color)
	if (color == team_color)
		return
	team_color = color
	update_icon()


/obj/item/clothing/suit/lasertag/get_color()
	return team_color


/// Sets the armor's team name and updates name accordingly.
/obj/item/clothing/suit/lasertag/proc/set_team_name(new_name)
	team_name = new_name
	SetName("[initial(name)] ([team_name])")


/obj/item/clothing/suit/lasertag/blue
	team_name = "Blue Barricudas"


/obj/item/clothing/suit/lasertag/green
	team_name = "Green Monkeys"


/obj/item/clothing/suit/lasertag/orange
	team_name = "Orange Iguanas"


/obj/item/clothing/suit/lasertag/purple
	team_name = "Purple Parrots"


/obj/item/clothing/suit/lasertag/red
	team_name = "Red Jaguars"


/obj/item/clothing/suit/lasertag/silver
	team_name = "Silver Snakes"
