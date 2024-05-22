/obj/item/material/ashtray
	name = "ashtray"
	desc = "A thing to keep your butts in."
	icon = 'icons/obj/ashtray.dmi'
	icon_state = "ashtray"
	max_force = 10
	force_multiplier = 0.1
	thrown_force_multiplier = 0.1
	randpixel = 5
	var/max_butts = 10

/obj/item/material/ashtray/examine(mob/user)
	. = ..()
	if(material)
		to_chat(user, "It's made of [material.display_name].")
	if(length(contents) >= max_butts)
		to_chat(user, "It's full.")
	else if(length(contents))
		to_chat(user, "It has [length(contents)] cig butts in it.")

/obj/item/material/ashtray/on_update_icon()
	..()
	ClearOverlays()
	if (length(contents) == max_butts)
		AddOverlays(image('icons/obj/ashtray.dmi',"ashtray_full"))
	else if (length(contents) >= max_butts/2)
		AddOverlays(image('icons/obj/ashtray.dmi',"ashtray_half"))

/obj/item/material/ashtray/use_tool(obj/item/W, mob/living/user, list/click_params)
	if (health_dead())
		USE_FEEDBACK_FAILURE("\The [src] is damaged beyond use!")
		return TRUE

	if (istype(W,/obj/item/trash/cigbutt) || istype(W,/obj/item/clothing/mask/smokable/cigarette) || istype(W, /obj/item/flame/match))
		if (length(contents) >= max_butts)
			to_chat(user, "\The [src] is full.")
			return TRUE

		if (istype(W,/obj/item/clothing/mask/smokable/cigarette))
			var/obj/item/clothing/mask/smokable/cigarette/cig = W
			if (cig.lit == 1)
				visible_message("[user] crushes [cig] in [src], putting it out.")
				W = cig.extinguish(no_message = 1)
			else if (cig.lit == 0)
				to_chat(user, "You place [cig] in [src] without even smoking it. Why would you do that?")

		if(user.unEquip(W, src))
			visible_message("[user] places [W] in [src].")
			set_extension(src, /datum/extension/scent/ashtray)
			update_icon()
		return TRUE

	return ..()

/obj/item/material/ashtray/throw_impact(atom/hit_atom)
	if (get_max_health())
		if (length(contents))
			visible_message(SPAN_DANGER("\The [src] slams into [hit_atom], spilling its contents!"))
			for (var/obj/O in contents)
				O.dropInto(loc)
			remove_extension(src, /datum/extension/scent)
		damage_health(3)
		update_icon()
	return ..()

/obj/item/material/ashtray/plastic/New(newloc)
	..(newloc, MATERIAL_PLASTIC)

/obj/item/material/ashtray/bronze/New(newloc)
	..(newloc, MATERIAL_BRONZE)

/obj/item/material/ashtray/glass/New(newloc)
	..(newloc, MATERIAL_GLASS)
