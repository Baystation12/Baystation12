/obj/item/clothing/accessory/cloak // A colorable cloak
	name = "blank cloak"
	desc = "A simple, bland cloak."
	icon = 'proxima/icons/obj/clothing/obj_accessories.dmi'
	icon_state = "colorcloak"

	accessory_icons = list(
		slot_w_uniform_str = 'proxima/icons/mob/onmob/onmob_accessories.dmi', \
		slot_tie_str = 'proxima/icons/mob/onmob/onmob_accessories.dmi', \
		slot_wear_suit_str = 'proxima/icons/mob/onmob/onmob_accessories.dmi')
	item_icons = list(
		slot_wear_suit_str = 'proxima/icons/mob/onmob/onmob_accessories.dmi')

	var/fire_resist = T0C+100
	allowed = list(/obj/item/tank/oxygen)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	slot_flags = SLOT_OCLOTHING
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	body_location = FULL_TORSO
	species_restricted = null
	siemens_coefficient = 0.9
	w_class = ITEM_SIZE_NORMAL
	slot = ACCESSORY_SLOT_ARMBAND
	accessory_flags = ACCESSORY_HIGH_VISIBILITY | ACCESSORY_REMOVABLE

	species_restricted = null
	valid_accessory_slots = null

/obj/item/clothing/accessory/cloak/cargo
	name = "brown cloak"
	desc = "A simple brown and black cloak."
	icon_state = "cargocloak"

/obj/item/clothing/accessory/cloak/mining
	name = "trimmed purple cloak"
	desc = "A trimmed purple and brown cloak."
	icon_state = "miningcloak"

/obj/item/clothing/accessory/cloak/security
	name = "red cloak"
	desc = "A simple red and black cloak."
	icon_state = "seccloak"

/obj/item/clothing/accessory/cloak/service
	name = "green cloak"
	desc = "A simple green and blue cloak."
	icon_state = "servicecloak"

/obj/item/clothing/accessory/cloak/engineer
	name = "gold cloak"
	desc = "A simple gold and brown cloak."
	icon_state = "engicloak"

/obj/item/clothing/accessory/cloak/atmos
	name = "yellow cloak"
	desc = "A trimmed yellow and blue cloak."
	icon_state = "atmoscloak"

/obj/item/clothing/accessory/cloak/research
	name = "purple cloak"
	desc = "A simple purple and white cloak."
	icon_state = "scicloak"

/obj/item/clothing/accessory/cloak/medical
	name = "blue cloak"
	desc = "A simple blue and white cloak."
	icon_state = "medcloak"
