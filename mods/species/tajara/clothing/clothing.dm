
//Helmets

/obj/item/clothing/head/helmet/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/helmet.dmi')

/obj/item/clothing/head/welding/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/helmet.dmi')

//MASKS
/obj/item/clothing/mask/balaclava/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/helmet.dmi')

/obj/item/clothing/mask/breath/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/mask.dmi')

/obj/item/clothing/mask/gas/aquabreather/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/mask.dmi')

/obj/item/clothing/mask/surgical/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/mask.dmi')

//suit
/obj/item/clothing/suit/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/suit.dmi')

//RIG
/obj/item/clothing/suit/space/rig/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/suit.dmi')

// RIG PARTS
/obj/item/clothing/head/helmet/space/rig/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/helmet.dmi')

/obj/item/clothing/head/helmet/space/rig/ert/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/helmet.dmi')

/obj/item/clothing/suit/space/rig/light/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/suit.dmi')

/obj/item/clothing/head/helmet/space/rig/light/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/helmet.dmi')

/obj/item/clothing/head/helmet/space/rig/industrial/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/helmet.dmi')

/obj/item/clothing/suit/space/rig/industrial/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/suit.dmi')

/obj/item/clothing/head/helmet/space/rig/eva/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/helmet.dmi')

/obj/item/clothing/suit/space/rig/eva/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/suit.dmi')

/obj/item/clothing/head/helmet/space/rig/hazmat/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/helmet.dmi')

/obj/item/clothing/suit/space/rig/hazmat/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/suit.dmi')

/obj/item/clothing/head/helmet/space/rig/medical/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/helmet.dmi')

/obj/item/clothing/suit/space/rig/medical/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/suit.dmi')

/obj/item/clothing/shoes/magboots/rig/medical/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/feet.dmi')

/obj/item/clothing/gloves/rig/medical/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/hands.dmi')

/obj/item/clothing/head/helmet/space/rig/hazard/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/helmet.dmi')

/obj/item/clothing/suit/space/rig/hazard/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/suit.dmi')

/obj/item/clothing/shoes/magboots/rig/hazard/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/feet.dmi')

/obj/item/clothing/gloves/rig/hazard/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/hands.dmi')


/obj/item/clothing/head/helmet/space/void/engineering/alt/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/helmet.dmi')

/obj/item/clothing/suit/space/void/engineering/alt/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/suit.dmi')


/obj/item/clothing/head/helmet/space/void/security/alt/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/helmet.dmi')

/obj/item/clothing/suit/space/void/security/alt/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/suit.dmi')

/obj/item/clothing/head/helmet/space/void/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/helmet.dmi')
	LAZYSET(sprite_sheets_obj, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/obj/hats.dmi')
	LAZYADD(species_restricted, list(SPECIES_TAJARA))

/obj/item/clothing/suit/space/void/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/suit.dmi')
	LAZYSET(sprite_sheets_obj, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/obj/suits.dmi')
	LAZYADD(species_restricted, list(SPECIES_TAJARA))

/obj/item/clothing/suit/space/rig/Initialize()
	. = ..()
	LAZYADD(species_restricted, list(SPECIES_TAJARA))

/obj/item/clothing/head/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, SPECIES_TAJARA, 'mods/species/tajara/icons/sprite_sheets/helmet.dmi')


/obj/machinery/suit_cycler/Initialize()
	. = ..()
	LAZYADD(species, list(SPECIES_TAJARA))


/obj/item/clothing/shoes/taj_old_shoes
	desc = "An old pattern shoes made of blackened leather with greenish protector. Built to keep moisture out and prevent \"trench paw\". This ones are for cold winter periods and cover the whole feet."
	name = "vintage boots"
	icon_state = "taj_old_shoes"
	item_state = "taj_old_shoes"
	icon = 'mods/species/tajara/icons/shoes.dmi'
	item_icons = list(slot_shoes_str = 'mods/species/tajara/icons/onmob_feet.dmi')
	species_restricted = list(SPECIES_TAJARA)

/obj/item/clothing/shoes/taj_new_shoes
	desc = "A new pattern boots made of black leather with a slighly blueish tint. This ones quite ergonomic and not as encumbering as the old boots. Built to keep moisture out and prevent \"trench paw\". This ones are for cold winter periods and cover the whole feet."
	name = "military boots"
	icon_state = "taj_new_shoes"
	item_state = "taj_new_shoes"
	icon = 'mods/species/tajara/icons/shoes.dmi'
	item_icons = list(slot_shoes_str = 'mods/species/tajara/icons/onmob_feet.dmi')
	species_restricted = list(SPECIES_TAJARA)

/obj/item/clothing/shoes/taj_new_shoes_cut
	desc = "A new pattern boots made of black leather with a slighly blueish tint. This ones quite ergonomic and not as encumbering as the old boots. Light and toeless version for long distance marches!"
	name = "toeless military  boots"
	icon_state = "taj_new_shoes"
	item_state = "taj_new_shoes_cut"
	icon = 'mods/species/tajara/icons/shoes.dmi'
	item_icons = list(slot_shoes_str = 'mods/species/tajara/icons/onmob_feet.dmi')
	species_restricted = list(SPECIES_TAJARA)

/obj/item/clothing/shoes/taj_old_shoes_cut
	desc = "An old pattern shoes made of blackened leather with greenish protector. Built to withstand a lot of abuse during travel. This ones are for \"warmer\" and dry periods, good for hiking, good for toes."
	name = "toeless vintage boots"
	icon_state = "taj_old_shoes"
	item_state = "taj_old_shoes_cut"
	icon = 'mods/species/tajara/icons/shoes.dmi'
	item_icons = list(slot_shoes_str = 'mods/species/tajara/icons/onmob_feet.dmi')
	species_restricted = list(SPECIES_TAJARA)
