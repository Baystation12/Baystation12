/obj/item/weapon/rig/unathi
	name = "NT breacher chassis control module"
	desc = "A cheap NT knock-off of an Unathi battle-rig. Looks like a fish, moves like a fish, steers like a cow."
	suit_type = "NT breacher"
	icon_state = "breacher_rig_cheap"
	armor = list(melee = 150, bullet = 150, laser = 150, energy = 150, bomb = 235, bio = 100, rad = 50)
	emp_protection = -20
	slowdown = 6
	offline_slowdown = 10
	vision_restriction = 1
	offline_vision_restriction = 2
	
	chest_type = /obj/item/clothing/suit/space/rig
	helm_type = /obj/item/clothing/head/helmet/space/rig/unathi
	boot_type = /obj/item/clothing/shoes/magboots/rig/unathi

/obj/item/weapon/rig/unathi/fancy
	name = "breacher chassis control module"
	desc = "An authentic Unathi breacher chassis. Huge, bulky and absurdly heavy. It must be like wearing a tank."
	suit_type = "breacher chassis"
	icon_state = "breacher_rig"
	armor = list(melee = 900, bullet = 900, laser = 900, energy = 900, bomb = 900, bio = 100, rad = 80) //Ridiculous armour values
	vision_restriction = 0

/obj/item/clothing/head/helmet/space/rig/unathi
	species_restricted = list("Unathi")

/obj/item/clothing/suit/space/rig/unathi
	species_restricted = list("Unathi")
	
/obj/item/clothing/shoes/magboots/rig/unathi
	species_restricted = list("Unathi")