/obj/item/gun/energy/lasertag
	name = "laser tag gun"
	icon = 'icons/obj/guns/lasertag.dmi'
	icon_state = "base"
	item_state = "laser"
	desc = "Standard issue weapon of the Imperial Guard."
	origin_tech = list(TECH_COMBAT = 1, TECH_MAGNET = 2)
	self_recharge = TRUE
	matter = list(MATERIAL_STEEL = 2000)
	projectile_type = /obj/item/projectile/beam/lasertag

	/// String (6 digit HEX code). HEX code for the team color this laser-tag gun is for.
	var/team_color = "#333333"

	/// String. Human readable name of the team color.
	var/team_name


/obj/item/gun/energy/lasertag/Initialize(mapload, _team_name, _team_color)
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


/obj/item/gun/energy/lasertag/examine(mob/user)
	. = ..()

	if (team_name)
		to_chat(user, SPAN_INFO("The team display reads '[team_name].'"))
	else
		to_chat(user, SPAN_WARNING("There is no team set."))


/obj/item/gun/energy/lasertag/on_update_icon()
	..()
	ClearOverlays()
	AddOverlays(emissive_appearance(icon, "emissive"))

	if (team_color)
		var/image/color_overlay = image(icon, src, "color")
		color_overlay.color = team_color
		AddOverlays(color_overlay)


/obj/item/gun/energy/lasertag/special_check(mob/living/carbon/human/user)
	if (!team_name)
		to_chat(user, SPAN_WARNING("\The [src] refuses to fire without a team set."))
		return FALSE

	if (!ishuman(user))
		to_chat(user, SPAN_WARNING("You can't figure out how to work \the [src]."))
		return FALSE

	var/obj/item/clothing/suit/lasertag/armor = user.wear_suit
	if (!istype(armor) || team_name != armor.team_name)
		to_chat(user, SPAN_WARNING("\The [src] refuses to fire unless you wear a matching team vest."))
		return FALSE

	return ..()


/obj/item/gun/energy/lasertag/consume_next_projectile()
	var/obj/item/projectile/beam/lasertag/projectile = ..()
	projectile.team_name = team_name
	projectile.set_color(team_color)
	return projectile


/obj/item/gun/energy/lasertag/set_color(color)
	if (color == team_color)
		return
	team_color = color
	update_icon()


/obj/item/gun/energy/lasertag/get_color()
	return team_color


/// Sets the gun's team name and updates name accordingly.
/obj/item/gun/energy/lasertag/proc/set_team_name(new_name)
	team_name = new_name
	SetName("[initial(name)] ([team_name])")


/obj/item/gun/energy/lasertag/blue
	team_name = "Blue Barricudas"


/obj/item/gun/energy/lasertag/green
	team_name = "Green Monkeys"


/obj/item/gun/energy/lasertag/orange
	team_name = "Orange Iguanas"


/obj/item/gun/energy/lasertag/purple
	team_name = "Purple Parrots"


/obj/item/gun/energy/lasertag/red
	team_name = "Red Jaguars"


/obj/item/gun/energy/lasertag/silver
	team_name = "Silver Snakes"
