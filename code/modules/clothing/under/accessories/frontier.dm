/obj/item/clothing/accessory/medal/fa
	abstract_type = /obj/item/clothing/accessory/medal/fa
	name = "base FA medal"
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


/obj/item/clothing/accessory/patch/earhart
	name = "mission patch, COL Earhart"
	desc = "A reproduction of the symbology for the Terran Commonwealth colony ship COL Earhart, a sea-blue airplane over a red cross. This one has a three digit number on it."
	icon = 'icons/obj/clothing/obj_accessories_frontier.dmi'
	accessory_icons = list(
		slot_w_uniform_str = 'icons/mob/onmob/onmob_accessories_frontier.dmi',
		slot_wear_suit_str = 'icons/mob/onmob/onmob_accessories_frontier.dmi'
	)
	icon_state = "fpepatch"
	overlay_state = "fpepatch"
	on_rolled_down = ACCESSORY_ROLLED_NONE
	w_class = ITEM_SIZE_TINY
	slot = ACCESSORY_SLOT_INSIGNIA


/obj/item/clothing/accessory/medal/commonwealthshield
	name = "commonwealth shield"
	desc = "The pin worn by all agents of the Terran Commonwealth to symbolize their service to the blue marble."
	icon = 'icons/obj/clothing/obj_accessories.dmi'
	accessory_icons = list(
		slot_w_uniform_str = 'icons/mob/onmob/onmob_accessories.dmi',
		slot_wear_suit_str = 'icons/mob/onmob/onmob_accessories.dmi'
	)
	icon_state = "commonwealthshield"
	overlay_state = "commonwealthshield"
	on_rolled_down = ACCESSORY_ROLLED_NONE
	w_class = ITEM_SIZE_TINY
	slot = ACCESSORY_SLOT_MEDAL


/obj/item/clothing/accessory/patch/commonwealth
	abstract_type = /obj/item/clothing/accessory/patch/commonwealth
	name = "base Terran Commonwealth Patch"
	desc = "You should not see this."
	icon = 'icons/obj/clothing/obj_accessories_frontier.dmi'
	accessory_icons = list(
		slot_w_uniform_str = 'icons/mob/onmob/onmob_accessories_frontier.dmi',
		slot_wear_suit_str = 'icons/mob/onmob/onmob_accessories_frontier.dmi'
	)
	on_rolled_down = ACCESSORY_ROLLED_NONE
	w_class = ITEM_SIZE_TINY
	slot = ACCESSORY_SLOT_INSIGNIA


/obj/item/clothing/accessory/patch/commonwealth/navy
	name = "commonwealth navy patch"
	desc = "A shield shaped blue and green patch with a red star, signifying service in the now-defunct Terran Commonwealth Navy."
	icon_state = "tc_navy"
	overlay_state = "tc_navy"


/obj/item/clothing/accessory/patch/commonwealth/army
	name = "commonwealth army patch"
	desc = "A shield shaped blue and green patch with a golden sun, signifying service in the now-defunct Terran Commonwealth Army."
	icon_state = "tc_army"
	overlay_state = "tc_army"


/obj/item/clothing/accessory/patch/commonwealth/ec
	name = "ancient Expeditionary Corps patch"
	desc = "A shield shaped blue and green patch with a purple chevron, signifying service in the bygone Expeditionary Corps from before the foundation of the SCG."
	icon_state = "tc_ec"
	overlay_state = "tc_ec"
