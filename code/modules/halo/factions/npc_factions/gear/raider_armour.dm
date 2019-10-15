


/* RAIDER ARMOUR */

/obj/item/clothing/suit/armor/raider_armour
	name = "Khoros Raider Armour"
	icon = 'khoros.dmi'
	icon_override = 'khoros.dmi'
	icon_state = "khoros_armor_obj"
	item_state = "khoros_armor"
	blood_overlay_type = "armor"
	armor = list(melee = 55, bullet = 50, laser = 55, energy = 45, bomb = 40, bio = 50, rad = 25)
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | ARMS
	armor_thickness = 20
	item_flags = THICKMATERIAL
	/*item_icons = list(
		slot_l_hand_str = 'khoros.dmi',
		slot_r_hand_str = 'khoros.dmi',
		)
	item_state_slots = list(
		slot_l_hand_str = "explosive_spearl",
		slot_r_hand_str = "explosive_spearr",
		)*/
