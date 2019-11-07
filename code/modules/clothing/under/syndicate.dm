/obj/item/clothing/under/syndicate
	name = "tactical turtleneck"
	desc = "It's some non-descript, slightly suspicious looking, civilian clothing."
	icon_state = "syndicate"
	item_state = "bl_suit"
	worn_state = "syndicate"
	has_sensor = 0
	gender_icons = 1
	armor = list(
		melee = ARMOR_MELEE_SMALL, 
		bullet = ARMOR_BALLISTIC_MINOR, 
		laser = ARMOR_LASER_MINOR
		)
	siemens_coefficient = 0.9

/obj/item/clothing/under/syndicate/combat
	name = "combat turtleneck"
	desc = "The height of fashion and tactical utility."
	icon_state = "combat"
	item_state = "bl_suit"
	worn_state = "combat"
	gender_icons = 1
	has_sensor = SUIT_HAS_SENSORS

/obj/item/clothing/under/syndicate/tacticool
	name = "\improper Tacticool turtleneck"
	desc = "Just looking at it makes you want to buy an SKS, go into the woods, and -operate-."
	icon_state = "tactifool"
	item_state = "bl_suit"
	worn_state = "tactifool"
	armor = null
	siemens_coefficient = 1
	has_sensor = SUIT_HAS_SENSORS


