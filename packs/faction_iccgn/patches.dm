/datum/gear/accessory/iccgn_patch
	display_name = "ICCGN Patch Selection"
	description = "Uniform patches of the confederation navy."
	path = /obj/item/clothing/accessory/iccgn_patch
	flags = GEAR_HAS_SUBTYPE_SELECTION
	allowed_branches = list(
		/datum/mil_branch/iccgn
	)


/obj/item/clothing/accessory/iccgn_patch
	name = "base uniform patch, ICCGN"
	desc = "You should not see this."
	icon = 'packs/faction_iccgn/patches.dmi'
	accessory_icons = list(
		slot_w_uniform_str = 'packs/faction_iccgn/patches.dmi',
		slot_wear_suit_str = 'packs/faction_iccgn/patches.dmi'
	)
	icon_state = "error"
	on_rolled = list(
		"down" = "none"
	)
	w_class = ITEM_SIZE_TINY
	slot = ACCESSORY_SLOT_INSIGNIA
	accessory_flags = ACCESSORY_REMOVABLE | ACCESSORY_HIGH_VISIBILITY


/obj/item/clothing/accessory/iccgn_patch/Initialize()
	. = ..()
	INIT_SKIP_QDELETED
	INIT_DISALLOW_TYPE(/obj/item/clothing/accessory/iccgn_patch)


/obj/item/clothing/accessory/iccgn_patch/get_fibers()
	return null


/obj/item/clothing/accessory/iccgn_patch/gilgamesh
	name = "uniform patch, Gilgamesh Flotilla"
	desc = "An embroidered patch with confederation navy iconography. This one indicates that its wearer is part of the Gilgamesh Flotilla."
	icon_state = "gilgamesh"
	overlay_state = "gilgamesh_worn"


/obj/item/clothing/accessory/iccgn_patch/sestris
	name = "uniform patch, Sestris Flotilla"
	desc = "An embroidered patch with confederation navy iconography. This one indicates that its wearer is part of the Sestris Flotilla."
	icon_state = "sestris"
	overlay_state = "sestris_worn"


/obj/item/clothing/accessory/iccgn_patch/pioneer
	name = "uniform patch, Pioneering Corps"
	desc = "An embroidered patch with confederation navy iconography. This one indicates that its wearer is part of the Pioneering Corps."
	icon_state = "pioneer"
	overlay_state = "pioneer_worn"


/obj/item/clothing/accessory/iccgn_patch/ordnance
	name = "uniform patch, Ordnance Corps"
	desc = "An embroidered patch with confederation navy iconography. This one indicates that its wearer is part of the Ordnance Corps."
	icon_state = "ordnance"
	overlay_state = "ordnance_worn"


/obj/item/clothing/accessory/iccgn_patch/security
	name = "uniform patch, Internal Security"
	desc = "An embroidered patch with confederation navy iconography. This one indicates that its wearer is part of the Office of Internal Security."
	icon_state = "security"
	overlay_state = "security_worn"


/obj/item/clothing/accessory/iccgn_patch/research
	name = "uniform patch, Defense Research"
	desc = "An embroidered patch with confederation navy iconography. This one indicates that its wearer is part of the Office of Defense Research."
	icon_state = "research"
	overlay_state = "research_worn"


/obj/item/clothing/accessory/iccgn_patch/guard
	name = "uniform patch, Colonial Guard"
	desc = "An embroidered patch with confederation navy iconography. This one indicates that its wearer is part of the Colonial Guard."
	icon_state = "guard"
	overlay_state = "guard_worn"
