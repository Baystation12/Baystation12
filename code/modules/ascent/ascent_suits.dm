/obj/item/clothing/head/helmet/space/void/ascent
	name = "\improper Ascent voidsuit helmet"
	desc = "An articulated spacesuit helmet of mantid manufacture."
	icon_state = "ascent_general"
	armor = list(melee = 40, bullet = 40, laser = 15, energy = 15, bomb = 50, bio = 100, rad = 100)
	max_pressure_protection = ENG_VOIDSUIT_MAX_PRESSURE
	species_restricted = list(SPECIES_MANTID_ALATE)
	sprite_sheets = list(SPECIES_MANTID_ALATE = 'icons/mob/species/mantid/onmob_head_alate.dmi')

/obj/item/clothing/suit/space/void/ascent
	name = "\improper Ascent voidsuit"
	desc = "A form-fitting spacesuit of mantid manufacture."
	icon_state = "ascent_general"
	max_pressure_protection = ENG_VOIDSUIT_MAX_PRESSURE
	armor = list(melee = 40, bullet = 40, laser = 15, energy = 15, bomb = 50, bio = 100, rad = 100)
	species_restricted = list(SPECIES_MANTID_ALATE)
	sprite_sheets = list(SPECIES_MANTID_ALATE = 'icons/mob/species/mantid/onmob_suit_alate.dmi')
	allowed = list(
		/obj/item/clustertool,
		/obj/item/weapon/tank/mantid,
		/obj/item/weapon/gun/energy/particle/small,
		/obj/item/weapon/weldingtool/electric/mantid,
		/obj/item/device/multitool/mantid,
		/obj/item/stack/medical/resin,
		/obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle/ascent
	) 