////// Ripley customisation kit - Butchery Royce - MayeDay
/obj/item/weapon/paintkit/fluff/butcher_royce_1
	name = "Ripley customisation kit"
	desc = "A kit containing all the needed tools and parts to turn an APLU Ripley into a Titan's Fist worker mech."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "royce_kit"

	new_name = "APLU \"Titan's Fist\""
	new_desc = "This ordinary mining Ripley has been customized to look like a unit of the Titans Fist."
	new_icon = "titan"
	allowed_types = list("ripley","firefighter")

////// Ripley customisation kit - Sven Fjeltson - Mordeth221

/obj/item/weapon/paintkit/fluff/sven_fjeltson_1
	name = "Mercenary APLU kit"
	desc = "A kit containing all the needed tools and parts to turn an APLU Ripley into an old Mercenaries APLU."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "sven_kit"

	new_name = "APLU \"Strike the Earth!\""
	new_desc = "Looks like an over worked, under maintained Ripley with some horrific damage."
	new_icon = "earth"
	allowed_types = list("ripley","firefighter")

// Root hardsuit kit defines.
// Icons for modified hardsuits need to be in the proper .dmis because suit cyclers may cock them up.
/obj/item/device/kit/suit/fluff

	name = "hardsuit modification kit"
	desc = "A kit for modifying a hardsuit."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "salvage_kit"

	var/new_name        // Modifier for new item name - '[new_name] hardsuit'.
	var/new_helmet_desc // Sets helmet desc.
	var/new_suit_desc   // Sets suit desc.
	var/helmet_icon     // Sets helmet icon_state and item_state.
	var/suit_icon       // Sets suit icon_state and item_state.
	var/helmet_color    // Sets worn_state.
	var/uses = 2        // Uses before the kit deletes itself.
	var/new_light_overlay

/obj/item/clothing/head/helmet/space/void/attackby(var/obj/item/O as obj, mob/user as mob)
	..()

	if(istype(O,/obj/item/device/kit/suit/fluff))

		var/obj/item/device/kit/suit/fluff/kit = O
		name = "[kit.new_name] suit helmet"
		desc = kit.new_helmet_desc
		icon_state = kit.helmet_icon
		item_state = kit.helmet_icon

		if(kit.new_light_overlay)
			light_overlay = kit.new_light_overlay

		user << "You set about modifying the helmet into [src]."
		playsound(user.loc, 'sound/items/Screwdriver.ogg', 50, 1)

		kit.uses--
		if(kit.uses<1)
			user.drop_item()
			qdel(O)

/obj/item/clothing/suit/space/void/attackby(var/obj/item/O as obj, mob/user as mob)
	..()

	if(istype(O,/obj/item/device/kit/suit/fluff))

		var/obj/item/device/kit/suit/fluff/kit = O
		name = "[kit.new_name] voidsuit"
		desc = kit.new_suit_desc
		icon_state = kit.suit_icon
		item_state = kit.suit_icon

		user << "You set about modifying the suit into [src]."
		playsound(user.loc, 'sound/items/Screwdriver.ogg', 50, 1)

		kit.uses--
		if(kit.uses<1)
			user.drop_item()
			qdel(O)

///////// Salvage crew hardsuit - Cybele Petit - solaruin ///////////////
/obj/item/device/kit/suit/fluff/salvage
	name = "salvage hardsuit modification kit"
	desc = "A kit containing all the needed tools and parts to modify a hardsuit into a salvage hardsuit."

	new_name = "salvage"
	new_suit_desc = "An orange hardsuit used by salvage flotillas. Has reinforced plating."
	new_helmet_desc = "An orange hardsuit helmet used by salvage flotillas. Has reinforced plating."
	helmet_icon = "salvage_helmet"
	suit_icon = "salvage_suit"
	helmet_color = "salvage"

///////// Weathered hardsuit - Callum Leamas - roaper ///////////////
/obj/item/device/kit/suit/fluff/roaper
	name = "Callum's hardsuit modification kit"
	desc = "A kit containing all the needed tools and parts to modify a hardsuit."

	new_name = "weathered"
	new_suit_desc = " A jury-rigged and modified engineering hardsuit. It looks slightly damaged and dinged."
	new_helmet_desc = "A jury-rigged and modified engineering hardsuit helmet. It looks slightly damaged and dinged"
	helmet_icon = "rig0-roaper"
	suit_icon = "rig-roaper"
	helmet_color = "roaper"

///////// Hazard Hardsuit - Ronan Harper - Raptor1628 //////////////////
/obj/item/device/kit/suit/fluff/ronan_harper
	name = "hazard hardsuit modification kit"
	desc = "A kit containing all the needed tools and parts to modify a hardsuit."

	new_name = "hazard"
	new_suit_desc = "An older model of armored NT Hardsuit emblazoned in security colors. The crest of the NAS Rhodes, a copper rose, is painted onto the chestplate."
	new_helmet_desc = "An older NT Hardsuit Helmet with built-in atmospheric filters. The name HARPER has been printed on the back."
	helmet_icon = "rig0-hazardhardsuit"
	suit_icon = "rig-hazardhardsuit"
	helmet_color = "hazardhardsuit"
	new_light_overlay = "helmet_light_dual"
