/decl/hierarchy/outfit/job/ascent
	name = "Ascent - Gyne"
	mask =     /obj/item/clothing/mask/gas/ascent
	uniform =  /obj/item/clothing/under/ascent
	id_type =  /obj/item/weapon/card/id/ascent
	shoes =    /obj/item/clothing/shoes/magboots/ascent
	l_ear =    null
	pda_type = null
	pda_slot = 0
	flags =    0
	
/decl/hierarchy/outfit/job/ascent/attendant
	name = "Ascent - Attendant"
	back = /obj/item/weapon/rig/mantid

/decl/hierarchy/outfit/job/ascent/tech
	name = "Ascent - Technician"
	suit = /obj/item/clothing/suit/storage/ascent

/obj/item/clothing/mask/gas/ascent
	name = "mantid facemask"
	desc = "An alien facemask with chunky gas filters and a breathing valve."
	filter_water = TRUE
	icon_state = "ascent_mask"
	item_state = "ascent_mask"
	sprite_sheets = list(
		SPECIES_NABBER =       'icons/mob/species/nabber/onmob_mask_gas.dmi',
		SPECIES_MANTID_GYNE =  'icons/mob/species/mantid/onmob_mask_gyne.dmi',
		SPECIES_MANTID_ALATE = 'icons/mob/species/mantid/onmob_mask_alate.dmi'
	)
	species_restricted = list(SPECIES_MANTID_ALATE, SPECIES_MANTID_GYNE)
	filtered_gases = list(GAS_PHORON,GAS_N2O,GAS_CHLORINE,GAS_AMMONIA,GAS_CO,GAS_METHANE)
	flags_inv = 0

/obj/item/clothing/mask/gas/ascent/monarch
	name = "serpentid facemask"
	desc = "An alien facemask with chunky gas filters and a breathing valve."
	filtered_gases = list(GAS_PHORON,GAS_N2O,GAS_CHLORINE,GAS_AMMONIA,GAS_CO,GAS_METHYL_BROMIDE,GAS_METHANE)
	species_restricted = list(SPECIES_NABBER, SPECIES_MONARCH_QUEEN)

/obj/item/clothing/shoes/magboots/ascent
	name = "mantid mag-claws"
	desc = "A set of powerful gripping claws."
	icon_state = "ascent_boots0"
	icon_base = "ascent_boots"
	species_restricted = list(SPECIES_MANTID_ALATE, SPECIES_MANTID_GYNE)
	sprite_sheets = list(
		SPECIES_MANTID_GYNE =  'icons/mob/species/mantid/onmob_shoes_gyne.dmi',
		SPECIES_MANTID_ALATE = 'icons/mob/species/mantid/onmob_shoes_alate.dmi'
	)

/obj/item/clothing/under/ascent
	name = "mantid undersuit"
	desc = "A ribbed, spongy undersuit of some sort. It has a big sleeve for a tail, so it probably isn't for humans."
	species_restricted = ALL_ASCENT_SPECIES
	icon_state = "ascent"
	worn_state = "ascent"
	color = COLOR_DARK_GUNMETAL

/obj/item/clothing/suit/storage/ascent
	name = "mantid gear harness"
	desc = "A complex tangle of articulated cables and straps."
	species_restricted = ALL_ASCENT_SPECIES
	icon_state = "ascent_harness"
	body_parts_covered = 0
	slot_flags = SLOT_OCLOTHING | SLOT_BELT
	allowed = list(
		/obj/item/device/flashlight,
		/obj/item/weapon/tank,
		/obj/item/device/suit_cooling_unit,
		/obj/item/weapon/inflatable_dispenser,
		/obj/item/weapon/rcd
	)

/obj/item/clothing/suit/storage/ascent/Initialize()
	. = ..()
	for(var/tool in list(
		/obj/item/weapon/gun/energy/particle/small,
		/obj/item/device/multitool/mantid, 
		/obj/item/clustertool, 
		/obj/item/clustertool, 
		/obj/item/weapon/weldingtool/electric/mantid,
		/obj/item/stack/medical/resin
	))
		allowed |= tool
		new tool(pockets)
	pockets.make_exact_fit()
	allowed |= /obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle/ascent
	pockets.can_hold |= /obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle/ascent
