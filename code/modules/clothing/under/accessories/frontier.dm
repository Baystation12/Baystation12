/obj/item/clothing/accessory/medal/fa
	abstract_type = /obj/item/clothing/accessory/medal/fa
	name = "base FFA medal"
	desc = "You should not see this."
	icon = 'icons/obj/clothing/obj_accessories_frontier.dmi'
	accessory_icons = list(
		slot_w_uniform_str = 'icons/mob/onmob/onmob_accessories_frontier.dmi',
		slot_wear_suit_str = 'icons/mob/onmob/onmob_accessories_frontier.dmi'
	)
	on_rolled_down = ACCESSORY_ROLLED_NONE
	w_class = ITEM_SIZE_TINY
	slot = ACCESSORY_SLOT_MEDAL
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_accessories_frontier_unathi.dmi'
	)

/obj/item/clothing/accessory/medal/fa/get_fibers()
	return null

/obj/item/clothing/accessory/medal/fa/guardsman
	name = "guardsman medal"
	desc = "A copper four-pointed star denoting that the wearer is a Guardsman of the Frontier Alliance. Not worth enough in the scrapyard to justify being reprimanded."
	icon_state = "gam"
	overlay_state = "gam_worn"

/obj/item/clothing/accessory/medal/fa/warden
	name = "warden medal"
	desc = "A silver four-pointed star denoting that the wearer is a Warden of the Frontier Alliance. Shinier than necessarily practical, and also clearly made of nickel silver if you bother to stare."
	icon_state = "wam"
	overlay_state = "wam_worn"

/obj/item/clothing/accessory/medal/fa/marshal
	name = "star marshal medal"
	desc = "A golden four-pointed star denoting that the wearer is a Star Marshal of the Frontier Alliance. If you take a real close look at it, you can see that the gold isn't real. It's plated tin."
	icon_state = "sam"
	overlay_state = "sam_worn"

