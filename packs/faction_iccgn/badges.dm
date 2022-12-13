/obj/item/clothing/accessory/iccgn_badge
	abstract_type = /obj/item/clothing/accessory/iccgn_badge
	name = "base badge, ICCGN"
	desc = "You should not see this."
	icon = 'packs/faction_iccgn/badges.dmi'
	accessory_icons = list(
		slot_w_uniform_str = 'packs/faction_iccgn/badges.dmi',
		slot_wear_suit_str = 'packs/faction_iccgn/badges.dmi'
	)
	on_rolled_down = ACCESSORY_ROLLED_NONE
	w_class = ITEM_SIZE_TINY
	slot = ACCESSORY_SLOT_INSIGNIA


/obj/item/clothing/accessory/iccgn_badge/get_fibers()
	return null


/obj/item/clothing/accessory/iccgn_badge/enlisted
	name = "pin badge, ICCGN Enlisted"
	desc = "A shiny little pin badge denoting that the holder is Confederation Navy enlisted personnel."
	icon_state = "enlisted"
	overlay_state = "enlisted_worn"


/obj/item/clothing/accessory/iccgn_badge/officer
	name = "pin badge, ICCGN Officer"
	desc = "A shiny little pin badge denoting that the holder is a Confederation Navy officer."
	icon_state = "officer"
	overlay_state = "officer_worn"
