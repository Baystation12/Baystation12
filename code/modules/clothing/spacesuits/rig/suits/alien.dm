/obj/item/weapon/rig/unathi
	name = "\improper NT breacher chassis control module"
	desc = "A NanoTrasen-made Unathi battle-rig. Looks like a fish, moves like a fish, steers like a cow."
	suit_type = "\improper NT breacher rig"
	icon_state = "breacher_rig_cheap"
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 60, bomb = 70, bio = 100, rad = 12.5)
	emp_protection = -20
	online_slowdown = 6
	offline_slowdown = 10
	offline_vision_restriction = TINT_BLIND

	chest_type = /obj/item/clothing/suit/space/rig/unathi
	helm_type = /obj/item/clothing/head/helmet/space/rig/unathi
	boot_type = /obj/item/clothing/shoes/magboots/rig/unathi
	glove_type = /obj/item/clothing/gloves/rig/unathi

/obj/item/weapon/rig/unathi/fancy
	name = "breacher chassis control module"
	desc = "An (outwardly) authentic Unathi breacher chassis. Huge, bulky and absurdly heavy. It must be like wearing a tank."
	suit_type = "breacher chassis"
	icon_state = "breacher_rig"
	armor = list(melee = 75, bullet = 75, laser = 75, energy = 75, bomb = 75, bio = 100, rad = 22.5)

/obj/item/clothing/head/helmet/space/rig/unathi
	species_restricted = list(SPECIES_UNATHI)
	force = 5
	sharp = 1 //poking people with the horn

/obj/item/clothing/suit/space/rig/unathi
	species_restricted = list(SPECIES_UNATHI)

/obj/item/clothing/shoes/magboots/rig/unathi
	species_restricted = list(SPECIES_UNATHI)

/obj/item/clothing/gloves/rig/unathi
	species_restricted = list(SPECIES_UNATHI)
