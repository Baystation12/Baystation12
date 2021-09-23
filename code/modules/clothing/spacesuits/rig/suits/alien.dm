/obj/item/rig/unathi
	name = "\improper NT breacher chassis control module"
	desc = "A NanoTrasen-made Unathi battle-rig. Looks like a fish, moves like a fish, steers like a cow."
	suit_type = "\improper NT breacher rig"
	icon_state = "breacher_rig_cheap"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_MINOR
		)
	emp_protection = -20
	online_slowdown = 6
	offline_slowdown = 10
	offline_vision_restriction = TINT_BLIND

	chest_type = /obj/item/clothing/suit/space/rig/unathi
	helm_type = /obj/item/clothing/head/helmet/space/rig/unathi
	boot_type = /obj/item/clothing/shoes/magboots/rig/unathi
	glove_type = /obj/item/clothing/gloves/rig/unathi

/obj/item/rig/unathi/fancy
	name = "breacher chassis control module"
	desc = "An (outwardly) authentic Unathi breacher chassis. Huge, bulky and absurdly heavy. It must be like wearing a tank."
	suit_type = "breacher chassis"
	icon_state = "breacher_rig"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_AP,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_STRONG,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL)

/obj/item/clothing/head/helmet/space/rig/unathi
	species_restricted = list(SPECIES_UNATHI)
	force = 5
	sharp = TRUE

/obj/item/clothing/suit/space/rig/unathi
	species_restricted = list(SPECIES_UNATHI)

/obj/item/clothing/shoes/magboots/rig/unathi
	species_restricted = list(SPECIES_UNATHI)

/obj/item/clothing/gloves/rig/unathi
	species_restricted = list(SPECIES_UNATHI)
