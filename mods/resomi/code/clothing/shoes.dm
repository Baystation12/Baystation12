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
	// SIERRA TODO: port to Bay12 drop sounds
	//drop_sound = 'sound/items/drop/cloth.ogg'
	//pickup_sound = 'sound/items/pickup/cloth.ogg'

/obj/item/clothing/shoes/footwraps/socks_resomi
	name = "koishi"
	desc = "Looks like socks but with toe holes and thick sole."
	icon_state = "socks"
	icon = 'packs/infinity/icons/obj/clothing/species/resomi/obj_feet_resomi.dmi'
	item_state = "socks"
