/obj/item/clothing/accessory/fa_badge
	abstract_type = /obj/item/clothing/accessory/fa_badge
	icon = 'packs/factions/fa/badges.dmi'
	accessory_icons = list(
		slot_w_uniform_str = 'packs/factions/fa/badges.dmi',
		slot_wear_suit_str = 'packs/factions/fa/badges.dmi'
	)
	icon_state = null
	on_rolled_down = ACCESSORY_ROLLED_NONE
	w_class = ITEM_SIZE_TINY
	slot = ACCESSORY_SLOT_INSIGNIA
	sprite_sheets = list(
		SPECIES_UNATHI = 'packs/factions/fa/badges_unathi.dmi'
	)


/obj/item/clothing/accessory/fa_badge/get_fibers()
	return null


/obj/item/clothing/accessory/fa_badge/guardsman
	name = "guardsman medal"
	desc = {"\
		A copper four-pointed star denoting that the wearer is a Guardsman of the \
		Frontier Alliance. Not worth enough in the scrapyard to justify being reprimanded.\
	"}
	icon_state = "gam"
	overlay_state = "gam_worn"


/obj/item/clothing/accessory/fa_badge/warden
	name = "warden medal"
	desc = {"\
		A silver four-pointed star denoting that the wearer is a Warden of the Frontier \
		Alliance. Shinier than necessarily practical, and also clearly made of nickel \
		silver if you bother to stare.\
	"}
	icon_state = "wam"
	overlay_state = "wam_worn"


/obj/item/clothing/accessory/fa_badge/marshal
	name = "star marshal medal"
	desc = {"\
		A golden four-pointed star denoting that the wearer is a Star Marshal of the \
		Frontier Alliance. If you take a real close look at it, you can see that the \
		gold isn't real. It's plated tin.\
	"}
	icon_state = "sam"
	overlay_state = "sam_worn"
