

//Shoes

/obj/item/clothing/shoes/magboots/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_RESOMI, 'packs/infinity/icons/mob/species/resomi/onmob_feet_resomi.dmi')

/obj/item/clothing/shoes/galoshes/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_RESOMI, 'packs/infinity/icons/mob/species/resomi/onmob_feet_resomi.dmi')

//Gloves

/obj/item/clothing/gloves/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_RESOMI, 'packs/infinity/icons/mob/species/resomi/onmob_hands_resomi.dmi')

//Backpacks & tanks

/obj/item/storage/backpack/satchel/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_RESOMI, 'packs/infinity/icons/mob/species/resomi/onmob_back_resomi.dmi')

//Radsuits (theyre essential?)

/obj/item/clothing/head/radiation/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_RESOMI, 'packs/infinity/icons/mob/species/resomi/onmob_head_resomi.dmi')

/obj/item/clothing/suit/radiation/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_RESOMI, 'packs/infinity/icons/mob/species/resomi/onmob_suit_resomi.dmi')


//ears
/obj/item/clothing/ears/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_RESOMI, 'packs/infinity/icons/mob/species/resomi/onmob_ears_resomi.dmi')


//glasses
/obj/item/clothing/glasses/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_RESOMI, 'packs/infinity/icons/mob/species/resomi/onmob_eyes_resomi.dmi')

//devices and machines
/obj/machinery/suit_cycler/Initialize()
	. = ..()
	species += SPECIES_RESOMI

/obj/item/auto_cpr/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_RESOMI, 'packs/infinity/icons/mob/species/resomi/onmob_suit_resomi.dmi')

/obj/item/device/radio/headset/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_RESOMI, 'packs/infinity/icons/mob/species/resomi/onmob_ears_resomi.dmi')

/obj/item/clothing/mask/plunger/equipped(var/M, var/slot)
	..()
	sprite_sheets[SPECIES_RESOMI] = (slot == slot_head ? 'packs/infinity/icons/mob/species/resomi/onmob_head_resomi.dmi' : 'packs/infinity/icons/mob/species/resomi/onmob_mask_resomi.dmi')

/obj/item/card/id/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_RESOMI, 'packs/infinity/icons/mob/species/resomi/onmob_id_resomi.dmi')

/obj/item/handcuffs/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_RESOMI, 'packs/infinity/icons/mob/species/resomi/misc.dmi')

/obj/item/storage/belt/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_RESOMI, 'packs/infinity/icons/mob/species/resomi/onmob_belt_resomi.dmi')

/obj/item/tank/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_RESOMI, 'packs/infinity/icons/mob/species/resomi/onmob_back_resomi.dmi')

/obj/item/towel/equipped(var/M, var/slot)
	..()
	sprite_sheets = list(SPECIES_RESOMI = (slot == slot_head ? 'packs/infinity/icons/mob/species/resomi/onmob_head_resomi.dmi' : 'packs/infinity/icons/mob/species/resomi/onmob_suit_resomi.dmi'))
