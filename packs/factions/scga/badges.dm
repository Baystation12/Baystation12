/obj/item/clothing/accessory/scga_badge
	abstract_type = /obj/item/clothing/accessory/scga_badge
	name = "base badge, SCGA"
	desc = "You should not see this."
	icon = 'packs/factions/scga/badges.dmi'
	accessory_icons = list(
		slot_w_uniform_str = 'packs/factions/scga/badges.dmi',
		slot_wear_suit_str = 'packs/factions/scga/badges.dmi'
	)
	icon_state = null
	on_rolled_down = ACCESSORY_ROLLED_NONE
	w_class = ITEM_SIZE_TINY
	slot = ACCESSORY_SLOT_INSIGNIA
	sprite_sheets = list(
		SPECIES_UNATHI = 'packs/factions/scga/species/badges_unathi.dmi'
	)

/obj/item/clothing/accessory/scga_badge/get_fibers()
	return null


/obj/item/clothing/accessory/scga_badge/enlisted
	name = "pin badge, SCGA Enlisted"
	desc = "A shiny little pin badge denoting qualification as a solar army enlistedman."
	icon_state = "enlisted"
	overlay_state = "enlisted_worn"


/obj/item/clothing/accessory/scga_badge/officer
	name = "pin badge, SCGA Officer"
	desc = "A shiny little pin badge denoting qualification as a solar army officer."
	icon_state = "officer"
	overlay_state = "officer_worn"
