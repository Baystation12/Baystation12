/obj/item/clothing/accessory/armor_plate
	name = "light armor plate"
	desc = "A basic armor plate made of steel-reinforced synthetic fibers. Attaches to a plate carrier."
	icon = 'icons/obj/clothing/obj_suit_modular_armor.dmi'
	icon_state = "armor_light"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_MINOR
		)
	slot = ACCESSORY_SLOT_ARMOR_C
	flags_inv = CLOTHING_BULKY


/obj/item/clothing/accessory/armor_plate/medium
	name = "medium armor plate"
	desc = "A plasteel-reinforced synthetic armor plate, providing good protection. Attaches to a plate carrier."
	icon_state = "armor_medium"
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
	)


/obj/item/clothing/accessory/armor_plate/tactical
	name = "tactical armor plate"
	desc = "A heavier armor plate with additional ablative coating. Attaches to a plate carrier."
	icon_state = "armor_tactical"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
	)
	slowdown = 0.5


/obj/item/clothing/accessory/armor_plate/merc
	name = "heavy armor plate"
	desc = "A ceramics-reinforced synthetic armor plate, providing state of of the art protection. Attaches to a plate carrier."
	icon_state = "armor_merc"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
	)
	slowdown = 0.5


/obj/item/clothing/accessory/armor_plate/sneaky
	name = "low-profile armor vest"
	desc = "An armor vest made of layered polymer fibers. Can attach to your slacks and office shirt."
	siemens_coefficient = 0.6
	item_icons = list(slot_wear_suit_str = 'icons/mob/onmob/onmob_accessories.dmi')
	item_flags = ITEM_FLAG_THICKMATERIAL
	slot_flags = SLOT_OCLOTHING //can wear in suit slot as well
	slot = ACCESSORY_SLOT_UTILITY
	w_class = ITEM_SIZE_NORMAL
	blood_overlay_type = "armor"
	icon_state = "undervest"


/obj/item/clothing/accessory/armor_plate/sneaky/tactical
	name = "low-profile tactical armor vest"
	desc = "An armor vest made of layered smart polymers. Can attach to your slacks and office shirt."
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
	)
