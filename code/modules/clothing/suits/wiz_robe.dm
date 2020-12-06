/obj/item/clothing/head/wizard
	name = "wizard hat"
	desc = "Strange-looking hat-wear that most certainly belongs to a real magic user."
	icon_state = "wizard"
	item_state_slots = list(
		slot_l_hand_str = "wizhat",
		slot_r_hand_str = "wizhat",
		)
	//Not given any special protective value since the magic robes are full-body protection --NEO
	siemens_coefficient = 0.8
	body_parts_covered = 0
	wizard_garb = 1

/obj/item/clothing/head/wizard/red
	name = "red wizard hat"
	desc = "Strange-looking, red, hat-wear that most certainly belongs to a real magic user."
	icon_state = "redwizard"
	siemens_coefficient = 0.8

/obj/item/clothing/head/wizard/fake
	name = "wizard hat"
	desc = "It has WIZZARD written across it in sequins. Comes with a cool beard."
	icon_state = "wizard-fake"
	body_parts_covered = HEAD|FACE

/obj/item/clothing/head/wizard/marisa
	name = "Witch Hat"
	desc = "Strange-looking hat-wear, makes you want to cast fireballs."
	icon_state = "marisa"
	siemens_coefficient = 0.8

/obj/item/clothing/head/wizard/magus
	name = "Magus Helm"
	desc = "A mysterious helmet that hums with an unearthly power."
	icon_state = "magus"
	item_state = "magus"
	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet",
		)
	siemens_coefficient = 0.8
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/head/wizard/cap
	name = "Gentlemans Cap"
	desc = "A checkered gray flat cap woven together with the rarest of threads."
	icon_state = "gentcap"
	item_state_slots = list(
		slot_l_hand_str = "det_hat",
		slot_r_hand_str = "det_hat",
		)
	siemens_coefficient = 0.8

/obj/item/clothing/suit/wizrobe
	name = "wizard robe"
	desc = "A magnificant, gem-lined robe that seems to radiate power."
	icon_state = "wizard"
	gas_transfer_coefficient = 0.01 // IT'S MAGICAL OKAY JEEZ +1 TO NOT DIE
	permeability_coefficient = 0.01
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_MINOR,
		rad = ARMOR_RAD_MINOR
		)
	allowed = list(/obj/item/weapon/teleportation_scroll)
	siemens_coefficient = 0.8
	wizard_garb = 1

/obj/item/clothing/suit/wizrobe/red
	name = "red wizard robe"
	desc = "A magnificant, red, gem-lined robe that seems to radiate power."
	icon_state = "redwizard"


/obj/item/clothing/suit/wizrobe/marisa
	name = "Witch Robe"
	desc = "Magic is all about the spell power, ZE!"
	icon_state = "marisa"

/obj/item/clothing/suit/wizrobe/magusblue
	name = "Magus Robe"
	desc = "A set of armoured robes that seem to radiate a dark power."
	icon_state = "magusblue"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS|FEET

/obj/item/clothing/suit/wizrobe/magusred
	name = "Magus Robe"
	desc = "A set of armoured robes that seem to radiate a dark power."
	icon_state = "magusred"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS|FEET

/obj/item/clothing/suit/wizrobe/psypurple
	name = "purple robes"
	desc = "Heavy, royal purple robes threaded with psychic amplifiers and weird, bulbous lenses. Do not machine wash."
	icon_state = "psyamp"
	gender = PLURAL

/obj/item/clothing/suit/wizrobe/gentlecoat
	name = "Gentlemans Coat"
	desc = "A heavy threaded tweed gray jacket. For a different sort of Gentleman."
	icon_state = "gentlecoat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/suit/wizrobe/fake
	name = "wizard robe"
	desc = "A rather dull, blue robe meant to mimick real wizard robes."
	icon_state = "wizard-fake"
	armor = null
	siemens_coefficient = 1.0

/obj/item/clothing/head/wizard/marisa/fake
	name = "Witch Hat"
	desc = "Strange-looking hat-wear, makes you want to cast fireballs."
	icon_state = "marisa"
	armor = null
	siemens_coefficient = 1.0

/obj/item/clothing/suit/wizrobe/marisa/fake
	name = "Witch Robe"
	desc = "Magic is all about the spell power, ZE!"
	icon_state = "marisa"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	armor = null
	siemens_coefficient = 1.0

