/obj/item/clothing/head/helmet/space/rig/industrial/New()
	. = ..()
	species_restricted |= list(SPECIES_RESOMI)
	sprite_sheets[SPECIES_RESOMI] = 'mods/resomi/icons/clothing/onmob_head_resomi.dmi'

/obj/item/clothing/suit/space/rig/industrial/New()
	. = ..()
	species_restricted |= list(SPECIES_RESOMI)
	sprite_sheets[SPECIES_RESOMI] = 'mods/resomi/icons/clothing/onmob_suit_resomi.dmi'

/obj/item/clothing/shoes/magboots/rig/industrial/New()
	. = ..()
	species_restricted |= list(SPECIES_RESOMI)
	sprite_sheets[SPECIES_RESOMI] = 'mods/resomi/icons/clothing/onmob_feet_resomi.dmi'

/obj/item/clothing/gloves/rig/industrial/New()
	. = ..()
	species_restricted |= list(SPECIES_RESOMI)
	sprite_sheets[SPECIES_RESOMI] = 'mods/resomi/icons/clothing/onmob_hands_resomi.dmi'
	
/obj/item/rig/industrial/New()
	. = ..()
	sprite_sheets[SPECIES_RESOMI] = 'mods/resomi/icons/clothing/onmob_rig_back_resomi.dmi'
