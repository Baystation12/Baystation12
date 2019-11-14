/obj/item/clothing/head/helmet/space/void/ascent
	name = "\improper Ascent voidsuit helmet"
	desc = "An articulated spacesuit helmet of mantid manufacture."
	icon_state = "ascent_general"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
	max_pressure_protection = ENG_VOIDSUIT_MAX_PRESSURE
	species_restricted = list(SPECIES_MANTID_ALATE)
	sprite_sheets = list(SPECIES_MANTID_ALATE = 'icons/mob/species/mantid/onmob_head_alate.dmi')

/obj/item/clothing/suit/space/void/ascent
	name = "\improper Ascent voidsuit"
	desc = "A form-fitting spacesuit of mantid manufacture."
	icon_state = "ascent_general"
	max_pressure_protection = ENG_VOIDSUIT_MAX_PRESSURE
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
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