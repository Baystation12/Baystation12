//Resomi scarf
/obj/item/clothing/accessory/scarf/resomi
	name = "small mantle"
	desc = "A stylish scarf. The perfect winter accessory for those with a keen fashion sense, and those who just can't handle a cold breeze on their necks."
	icon = 'packs/packs/infinity/icons/obj/clothing/species/resomi/obj_accessories_resomi.dmi'
	icon_state = "small_mantle"
	species_restricted = list(SPECIES_RESOMI)

/*
/obj/item/clothing/mask/gas/explorer_resomi
	name = "exploratory mask"
	desc = "It looks like a tracker's mask. Too small for tall humanoids."
	icon = CUSTOM_ITEM_OBJ
	item_icons = list(slot_wear_mask_str = CUSTOM_ITEM_MOB)
	icon_state = "explorer_mask"
	item_state = "explorer_mask"
	species_restricted = list(SPECIES_RESOMI)
	sprite_sheets = list(SPECIES_RESOMI = CUSTOM_ITEM_MOB)
*/

/obj/item/clothing/shoes/workboots/resomi
	icon_state = "resomi_workboots"
	icon = 'packs/infinity/icons/obj/clothing/species/resomi/obj_feet_resomi.dmi'
	item_state = "workboots"
	name = "small workboots"
	desc = "Small and tight shoes with an iron sole for those who work in dangerous area or hate their paws"

	w_class = ITEM_SIZE_SMALL
	species_restricted = list(SPECIES_RESOMI)

/obj/item/clothing/shoes/workboots/resomi/New()
	..()
	slowdown_per_slot[slot_shoes] = 0.3


/obj/item/clothing/shoes/footwraps
	name = "cloth footwraps"
	desc = "A roll of treated canvas used for wrapping paws"
	icon_state = "clothwrap"
	icon = 'packs/infinity/icons/obj/clothing/species/resomi/obj_feet_resomi.dmi'
	item_state = "clothwrap"
	force = 0
	item_flags = ITEM_FLAG_SILENT
	w_class = ITEM_SIZE_SMALL
	species_restricted = list(SPECIES_RESOMI)

/obj/item/clothing/shoes/footwraps/socks_resomi
	name = "koishi"
	desc = "Looks like socks but with toe holes and thick sole."
	icon_state = "socks"
	icon = 'packs/infinity/icons/obj/clothing/species/resomi/obj_feet_resomi.dmi'
	item_state = "socks"


/obj/item/clothing/under/thermal/resomi
	name = "small thermal suit"
	desc = "Looks like very small suit. For children or resomi? This thermal suit is black."
	icon_state = "thermores_1"
	item_state = "thermores_1"
	thermostat = T0C
	species_restricted = list(SPECIES_RESOMI)
	sprite_sheets = list(
		SPECIES_RESOMI = 'infinity/icons/mob/onmob/onmob_under.dmi',
		)

/obj/item/clothing/under/thermal/resomi/white
	desc = "Looks like very small suit. For children or resomi? This thermal suit is white. "
	icon_state = "thermores_2"
	item_state = "thermores_2"
