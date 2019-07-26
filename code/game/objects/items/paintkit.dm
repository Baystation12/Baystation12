/obj/item/device/kit
	icon_state = "modkit"
	icon = 'icons/obj/device.dmi'
	var/new_name = "exosuit"    //What is the variant called?
	var/new_desc = "An exosuit." //How is the new exosuit described?
	var/new_icon = "ripley"  //What base icon will the new exosuit use?
	var/new_icon_file
	var/uses = 1        // Uses before the kit deletes itself.

/obj/item/device/kit/examine()
	. = ..()
	to_chat(usr, "It has [uses] use\s left.")

/obj/item/device/kit/proc/use(var/amt, var/mob/user)
	uses -= amt
	playsound(get_turf(user), 'sound/items/Screwdriver.ogg', 50, 1)
	if(uses<1)
		qdel(src)

// Root hardsuit kit defines.
// Icons for modified hardsuits need to be in the proper .dmis because suit cyclers may cock them up.
/obj/item/device/kit/suit
	name = "voidsuit modification kit"
	desc = "A kit for modifying a voidsuit."
	uses = 2
	var/new_light_overlay
	var/new_mob_icon_file

/obj/item/clothing/head/helmet/space/void/attackby(var/obj/item/O, var/mob/user)
	if(istype(O,/obj/item/device/kit/suit))
		var/obj/item/device/kit/suit/kit = O
		SetName("[kit.new_name] suit helmet")
		desc = kit.new_desc
		icon_state = "[kit.new_icon]_helmet"
		item_state = "[kit.new_icon]_helmet"
		if(kit.new_icon_file)
			icon = kit.new_icon_file
		if(kit.new_mob_icon_file)
			icon_override = kit.new_mob_icon_file
		if(kit.new_light_overlay)
			light_overlay = kit.new_light_overlay
		to_chat(user, "You set about modifying the helmet into [src].")
		var/mob/living/carbon/human/H = user
		if(istype(H))
			species_restricted = list(H.species.get_bodytype(H))
		kit.use(1,user)
		return 1
	return ..()

/obj/item/clothing/suit/space/void/attackby(var/obj/item/O, var/mob/user)
	if(istype(O,/obj/item/device/kit/suit))
		var/obj/item/device/kit/suit/kit = O
		SetName("[kit.new_name] voidsuit")
		desc = kit.new_desc
		icon_state = "[kit.new_icon]_suit"
		item_state = "[kit.new_icon]_suit"
		if(kit.new_icon_file)
			icon = kit.new_icon_file
		if(kit.new_mob_icon_file)
			icon_override = kit.new_mob_icon_file
		to_chat(user, "You set about modifying the suit into [src].")
		var/mob/living/carbon/human/H = user
		if(istype(H))
			species_restricted = list(H.species.get_bodytype(H))
		kit.use(1,user)
		return 1
	return ..()
//need a seperate path from the voidsuit, cause I don't hardsuit kits used on voidsuits
/obj/item/device/kit/rigsuit //DO NOT USE THIS ONE, THERE IS NO HARDSUIT RESTRICTION
	name = "hardsuit modification kit"
	desc = "A kit for modifying a hardsuit."
	var/new_light_overlay //for the helmet
	var/new_mob_icon_file //icon
	var/new_suit_type //Name of suit stuff (not rigpack name) eg. EVA hardsuit / industrial hardsuit
	var/list/new_hardsuit_restrict = list()//Restriction, type of hardsuit this kit can be used on. have the new_ thingy so it's easier to search and change variable

//add more as you need them?
/obj/item/device/kit/rigsuit/general
	new_hardsuit_restrict = list(/obj/item/weapon/rig/industrial)

/obj/item/device/kit/rigsuit/engineer
	new_hardsuit_restrict = list(/obj/item/weapon/rig/eva,/obj/item/weapon/rig/ce)

/obj/item/device/kit/rigsuit/medical
	new_hardsuit_restrict = list(/obj/item/weapon/rig/medical)

/obj/item/device/kit/rigsuit/nullsuit
	new_hardsuit_restrict = list(/obj/item/weapon/rig/zero)

/obj/item/weapon/rig/attackby(var/obj/item/O, var/mob/user)
	if(istype(O,/obj/item/device/kit/rigsuit))
		var/obj/item/device/kit/rigsuit/kit = O

		if(kit.new_hardsuit_restrict.len)
			var/good_search = FALSE//more vomit spaghetti
			for(var/rig_type in kit.new_hardsuit_restrict)
				if(istype(src, rig_type))
					good_search = TRUE
					break
			if(!good_search)
				to_chat(user, SPAN_WARNING("You can't modify this type of suit."))
				return

		if(!offline)
			to_chat(user, SPAN_WARNING("You can't modify the suit while it is on."))
			return

		SetName(kit.new_name)//name of the backpack rig
		desc = kit.new_desc
		icon_state = "[kit.new_icon]"
		item_state = "[kit.new_icon]"
		if(kit.new_icon_file)
			icon = kit.new_icon_file
		if(kit.new_mob_icon_file)
			icon_override = kit.new_mob_icon_file

		var/mob/living/carbon/human/H = user

		for(var/obj/item/clothing/piece in list(gloves,helmet,boots,chest))
			if(!piece) continue
			piece.SetName("[kit.new_suit_type] [initial(piece.name)]")
			piece.desc = "It seems to be part of a [src.name]."
			piece.icon_state = "[kit.new_icon]_[initial(piece.name)]"
			set_extension(piece, /datum/extension/base_icon_state, /datum/extension/base_icon_state, "[kit.new_icon]_[initial(piece.name)]")
			if(kit.new_icon_file)
				piece.icon = kit.new_icon_file
			if(kit.new_mob_icon_file)
				piece.icon_override = kit.new_mob_icon_file
			if(istype(H))
				piece.species_restricted = list(H.species.get_bodytype(H))

		if(helmet && kit.new_light_overlay)
			helmet.light_overlay = kit.new_light_overlay
		
		to_chat(user, SPAN_NOTICE("You set about modifying the suit into [src]."))
		kit.use(1,user)
		return 1
	return ..()

// Mechs are handled in their attackby (mech_interaction.dm).
/obj/item/device/kit/paint
	name = "exosuit customisation kit"
	desc = "A kit containing all the needed tools and parts to repaint a exosuit."
	var/removable = null

/obj/item/device/kit/paint/examine()
	. = ..()
	to_chat(usr, "This kit will add a '[new_name]' decal to a exosuit'.")

// exosuit kits.
/obj/item/device/kit/paint/powerloader/flames_red
	name = "\"Firestarter\" exosuit customisation kit"
	new_name = "red flames"
	new_icon = "flames_red"

/obj/item/device/kit/paint/powerloader/flames_blue
	name = "\"Burning Chrome\" exosuit customisation kit"
	new_name = "blue flames"
	new_icon = "flames_blue"
