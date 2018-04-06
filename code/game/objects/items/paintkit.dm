/obj/item/device/kit
	icon_state = "modkit"
	icon = 'icons/obj/device.dmi'
	var/new_name = "custom item"
	var/new_desc = "A custom item."
	var/new_icon
	var/new_icon_file
	var/new_icon_override_file
	var/uses = 1        // Uses before the kit deletes itself.
	var/list/allowed_types = list()

/obj/item/device/kit/examine()
	. = ..()
	to_chat(usr, "It has [uses] use\s left.")

/obj/item/device/kit/proc/use(var/amt, var/mob/user)
	uses -= amt
	playsound(get_turf(user), 'sound/items/Screwdriver.ogg', 50, 1)
	if(uses<1)
		user.drop_item()
		qdel(src)

/obj/item/device/kit/proc/can_customize(var/obj/item/I)
	return is_type_in_list(I, allowed_types)

/obj/item/device/kit/proc/set_info(var/kit_name, var/kit_desc, var/kit_icon, var/kit_icon_file = CUSTOM_ITEM_OBJ, var/kit_icon_override_file = CUSTOM_ITEM_MOB, var/additional_data)
	new_name = kit_name
	new_desc = kit_desc
	new_icon = kit_icon
	new_icon_file = kit_icon_file
	new_icon_override_file = kit_icon_override_file

	for(var/path in splittext(additional_data, ", "))
		allowed_types |= text2path(path)

/obj/item/device/kit/proc/customize(var/obj/item/I, var/mob/user)
	if(can_customize(I))
		I.SetName(new_name ? new_name : I.name)
		I.desc = new_desc ? new_desc : I.desc
		I.icon = new_icon_file ? new_icon_file : I.icon
		I.icon_override = new_icon_override_file ? new_icon_override_file : I.icon_override
		if(new_icon)
			I.set_icon_state(new_icon)
		var/obj/item/clothing/under/U = I
		if(istype(U))
			U.worn_state = I.icon_state
			U.update_rolldown_status()
		use(1, user)

// Generic use
/obj/item/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/device/kit))
		var/obj/item/device/kit/K = W
		K.customize(src, user)
		return

	. = ..()

// Root hardsuit kit defines.
// Icons for modified hardsuits need to be in the proper .dmis because suit cyclers may cock them up.
/obj/item/device/kit/suit
	name = "voidsuit modification kit"
	desc = "A kit for modifying a voidsuit."
	uses = 2
	var/new_light_overlay

/obj/item/device/kit/suit/can_customize(var/obj/item/I)
	return istype(I, /obj/item/clothing/head/helmet/space/void) || istype(I, /obj/item/clothing/suit/space/void)

/obj/item/device/kit/suit/set_info(var/kit_name, var/kit_desc, var/kit_icon, var/kit_icon_file = CUSTOM_ITEM_OBJ, var/kit_icon_override_file = CUSTOM_ITEM_MOB, var/additional_data)
	..()

	new_light_overlay = additional_data


/obj/item/device/kit/suit/customize(var/obj/item/I, var/mob/user)
	if(can_customize(I))
		if(istype(I, /obj/item/clothing/head/helmet/space/void))
			var/obj/item/clothing/head/helmet/space/void/helmet = I
			helmet.SetName("[new_name] suit helmet")
			helmet.desc = new_desc
			helmet.icon_state = "[new_icon]_helmet"
			helmet.item_state = "[new_icon]_helmet"
			if(new_icon_file)
				helmet.icon = new_icon_file
			if(new_icon_override_file)
				helmet.icon_override = new_icon_override_file
			if(new_light_overlay)
				helmet.light_overlay = new_light_overlay
			to_chat(user, "You set about modifying the helmet into [helmet].")
			var/mob/living/carbon/human/H = user
			if(istype(H))
				helmet.species_restricted = list(H.species.get_bodytype(H))
		else
			var/obj/item/clothing/suit/space/void/suit = I
			suit.SetName("[new_name] voidsuit")
			suit.desc = new_desc
			suit.icon_state = "[new_icon]_suit"
			suit.item_state = "[new_icon]_suit"
			if(new_icon_file)
				suit.icon = new_icon_file
			if(new_icon_override_file)
				suit.icon_override = new_icon_override_file
			to_chat(user, "You set about modifying the suit into [suit].")
			var/mob/living/carbon/human/H = user
			if(istype(H))
				suit.species_restricted = list(H.species.get_bodytype(H))
		use(1,user)

/obj/item/clothing/head/helmet/space/void/attackby(var/obj/item/O, var/mob/user)
	if(istype(O,/obj/item/device/kit/suit))
		var/obj/item/device/kit/suit/kit = O
		kit.customize(src, user)
	else
		return ..()

/obj/item/clothing/suit/space/void/attackby(var/obj/item/O, var/mob/user)
	if(istype(O,/obj/item/device/kit/suit))
		var/obj/item/device/kit/suit/kit = O
		kit.customize(src, user)
	else
		return ..()

/obj/item/device/kit/paint
	name = "mecha customisation kit"
	desc = "A kit containing all the needed tools and parts to repaint a mech."
	var/removable = null

/obj/item/device/kit/paint/can_customize(var/obj/mecha/M)
	if(!istype(M))
		return 0

	for(var/type in allowed_types)
		if(type == M.initial_icon)
			return 1

/obj/item/device/kit/paint/set_info(var/kit_name, var/kit_desc, var/kit_icon, var/kit_icon_file = CUSTOM_ITEM_OBJ, var/kit_icon_override_file = CUSTOM_ITEM_MOB, var/additional_data)
	..()

	allowed_types = splittext(additional_data, ", ")


/obj/item/device/kit/paint/examine()
	. = ..()
	to_chat(usr, "This kit will convert an exosuit into: [new_name].")
	to_chat(usr, "This kit can be used on the following exosuit models:")
	for(var/exotype in allowed_types)
		to_chat(usr, "- [capitalize(exotype)]")

/obj/item/device/kit/paint/customize(var/obj/mecha/M, var/mob/user)
	if(!can_customize(M))
		to_chat(user, "That kit isn't meant for use on this class of exosuit.")
		return

	if(M.occupant)
		to_chat(user, "You can't customize a mech while someone is piloting it - that would be unsafe!")
		return

	user.visible_message("[user] opens [src] and spends some quality time customising [M].")
	M.SetName(new_name)
	M.desc = new_desc
	M.initial_icon = new_icon
	if(new_icon_file)
		M.icon = new_icon_file
	M.reset_icon()
	use(1, user)

/obj/mecha/attackby(var/obj/item/weapon/W, var/mob/user)
	if(istype(W, /obj/item/device/kit/paint))
		var/obj/item/device/kit/paint/P = W
		P.customize(src, user)
	else
		return ..()

//Ripley APLU kits.
/obj/item/device/kit/paint/ripley
	name = "\"Classic\" APLU customisation kit"
	new_name = "APLU \"Classic\""
	new_desc = "A very retro APLU unit; didn't they retire these back in 2543?"
	new_icon = "ripley-old"
	allowed_types = list("ripley")

/obj/item/device/kit/paint/ripley/death
	name = "\"Reaper\" APLU customisation kit"
	new_name = "APLU \"Reaper\""
	new_desc = "A terrifying, grim power loader. Why do those clamps have spikes?"
	new_icon = "deathripley"
	allowed_types = list("ripley","firefighter")

/obj/item/device/kit/paint/ripley/flames_red
	name = "\"Firestarter\" APLU customisation kit"
	new_name = "APLU \"Firestarter\""
	new_desc = "A standard APLU exosuit with stylish orange flame decals."
	new_icon = "ripley_flames_red"

/obj/item/device/kit/paint/ripley/flames_blue
	name = "\"Burning Chrome\" APLU customisation kit"
	new_name = "APLU \"Burning Chrome\""
	new_desc = "A standard APLU exosuit with stylish blue flame decals."
	new_icon = "ripley_flames_blue"

// Durand kits.
/obj/item/device/kit/paint/durand
	name = "\"Classic\" Durand customisation kit"
	new_name = "Durand \"Classic\""
	new_desc = "An older model of Durand combat exosuit. This model was retired for rotating a pilot's torso 180 degrees."
	new_icon = "old_durand"
	allowed_types = list("durand")

/obj/item/device/kit/paint/durand/seraph
	name = "\"Cherubim\" Durand customisation kit"
	new_name = "Durand \"Cherubim\""
	new_desc = "A Durand combat exosuit modelled after ancient Earth entertainment. Your heart goes doki-doki just looking at it."
	new_icon = "old_durand"

/obj/item/device/kit/paint/durand/phazon
	name = "\"Sypher\" Durand customisation kit"
	new_name = "Durand \"Sypher\""
	new_desc = "A Durand combat exosuit with some very stylish neons and decals. Seems to blur slightly at the edges; probably an optical illusion."
	new_icon = "phazon"

// Gygax kits.
/obj/item/device/kit/paint/gygax
	name = "\"Jester\" Gygax customisation kit"
	new_name = "Gygax \"Jester\""
	new_desc = "A Gygax exosuit modelled after the infamous combat-troubadors of Earth's distant past. Terrifying to behold."
	new_icon = "honker"
	allowed_types = list("gygax")

/obj/item/device/kit/paint/gygax/darkgygax
	name = "\"Silhouette\" Gygax customisation kit"
	new_name = "Gygax \"Silhouette\""
	new_desc = "An ominous Gygax exosuit modelled after the fictional corporate 'death squads' that were popular in pulp action-thrillers back in 2554."
	new_icon = "darkgygax"

/obj/item/device/kit/paint/gygax/recitence
	name = "\"Gaoler\" Gygax customisation kit"
	new_name = "Durand \"Gaoler\""
	new_desc = "A bulky silver Gygax exosuit. The extra armour appears to be painted on, but it's very shiny."
	new_icon = "recitence"