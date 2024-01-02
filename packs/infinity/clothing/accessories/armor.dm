/obj/item/clothing/accessory/arm_guards/tactical
	desc = "A pair of black arm pads reinforced with additional ablative coating. Attaches to a plate carrier."
	armor = list(melee = 50, bullet = 50, laser = 60, energy = 35, bomb = 30, bio = 0, rad = 0)

/obj/item/clothing/accessory/leg_guards/tactical
	desc = "A pair of armored leg pads reinforced with additional ablative coating. Attaches to a plate carrier."
	armor = list(melee = 50, bullet = 50, laser = 60, energy = 35, bomb = 30, bio = 0, rad = 0)

/obj/item/clothing/accessory/armorplate/mainkraft/light
	name = "light metal plate"
	desc = "Thin homemade metal plate. Unlikely to protect from something strong, but it's better than nothing."
	icon_state = "armor_light"
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_MINOR
		)
	slowdown = 0.25

/obj/item/clothing/accessory/armorplate/mainkraft/medium
	name = "medium metal plate"
	desc = "Metal plate of medium thickness. Feels heavy. I hope it will be able to help."
	icon_state = "armor_medium"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL - 10,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
		)
	slowdown = 0.5

/obj/item/clothing/accessory/armorplate/mainkraft/heavy
	name = "heavy metal plate"
	desc = "A thick sheet of armor that can stop a bullet, it is a pity that as the plate is thick, so heavy."
	icon_state = "armor_merc"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
		)
	slowdown = 0.75
