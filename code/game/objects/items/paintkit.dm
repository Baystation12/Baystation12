/obj/item/device/kit
	icon_state = "modkit"
	icon = 'icons/obj/device.dmi'
	var/new_name = "mech"    //What is the variant called?
	var/new_desc = "A mech." //How is the new mech described?
	var/new_icon = "ripley"  //What base icon will the new mech use?
	var/new_icon_file
	var/uses = 1        // Uses before the kit deletes itself.

/obj/item/device/kit/proc/use(var/amt, var/mob/user)
	uses -= amt
	playsound(get_turf(user), 'sound/items/Screwdriver.ogg', 50, 1)
	if(uses<1)
		user.drop_item()
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
		name = "[kit.new_name] suit helmet"
		desc = kit.new_desc
		icon_state = "[kit.new_icon]_helmet"
		item_state = "[kit.new_icon]_helmet"
		if(kit.new_icon_file)
			icon = kit.new_icon_file
		if(kit.new_mob_icon_file)
			icon_override = kit.new_mob_icon_file
		if(kit.new_light_overlay)
			light_overlay = kit.new_light_overlay
		user << "You set about modifying the helmet into [src]."
		var/mob/living/carbon/human/H = user
		if(istype(H))
			species_restricted = list(H.species.name)
		kit.use(1,user)
		return 1
	return ..()

/obj/item/clothing/suit/space/void/attackby(var/obj/item/O, var/mob/user)
	if(istype(O,/obj/item/device/kit/suit))
		var/obj/item/device/kit/suit/kit = O
		name = "[kit.new_name] voidsuit"
		desc = kit.new_desc
		icon_state = "[kit.new_icon]_suit"
		item_state = "[kit.new_icon]_suit"
		if(kit.new_icon_file)
			icon = kit.new_icon_file
		if(kit.new_mob_icon_file)
			icon_override = kit.new_mob_icon_file
		user << "You set about modifying the suit into [src]."
		var/mob/living/carbon/human/H = user
		if(istype(H))
			species_restricted = list(H.species.name)
		kit.use(1,user)
		return 1
	return ..()

// Actual application of this kit is handled in mecha.dm attackby().
/obj/item/device/kit/paint
	name = "mecha customisation kit"
	desc = "A generic kit containing all the needed tools and parts to turn a mech into another mech."
	var/removable = null
	var/list/allowed_types = list()

/obj/mecha/attackby(var/obj/item/weapon/W, var/mob/user)
	if(istype(W, /obj/item/device/kit/paint))
		if(occupant)
			user << "You can't customize a mech while someone is piloting it - that would be unsafe!"
			return

		var/obj/item/device/kit/paint/P = W
		var/found = null

		for(var/type in P.allowed_types)
			if(type==src.initial_icon)
				found = 1
				break

		if(!found)
			user << "That kit isn't meant for use on this class of exosuit."
			return

		user.visible_message("[user] opens [P] and spends some quality time customising [src].")
		src.name = P.new_name
		src.desc = P.new_desc
		src.initial_icon = P.new_icon
		if(P.new_icon_file)
			src.icon = P.new_icon_file
		src.reset_icon()
		P.use(1, user)
		return 1
	else
		return ..()