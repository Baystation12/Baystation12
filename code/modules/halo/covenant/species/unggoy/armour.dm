
/obj/item/clothing/suit/armor/special/unggoy_combat_harness
	name = "Unggoy Combat Harness (Minor)"
	desc = "A combat harness with an inbuilt gas tank"
	icon = GRUNT_GEAR_ICON
	icon_override = GRUNT_GEAR_ICON
	item_state_slots = list(slot_l_hand_str = "armor", slot_r_hand_str = "armor")
	icon_state = "combatharness_minor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS //Essentially, the entire body besides the head,feet,hands
	flags_inv = HIDESUITSTORAGE|HIDEBACK
	armor_thickness_modifiers = list()
	unacidable = 1
	allowed = list(/obj/item/weapon/tank)
	species_restricted = list("Unggoy")
	matter = list("nanolaminate" = 1)

	//5 less all-round protection compared to marines and high ranking grunts
	armor = list(melee = 50, bullet = 45, laser = 50, energy = 40, bomb = 35, bio = 25, rad = 25)

/obj/item/clothing/suit/armor/special/unggoy_combat_harness/major
	name = "Unggoy Combat Harness (Major)"
	icon_state = "combatharness_major"
	item_state = "combatharness_major"
	//
	//3 less all-round protection compared to marines and high ranking grunts
	armor = list(melee = 52, bullet = 47, laser = 52, energy = 42, bomb = 37, bio = 25, rad = 25)

/obj/item/clothing/suit/armor/special/unggoy_combat_harness/heavy
	name = "Unggoy Combat Harness (Heavy)"
	icon_state = "combatharness_heavy"
	item_state = "combatharness_heavy"

/obj/item/clothing/suit/armor/special/unggoy_combat_harness/deacon
	name = "Unggoy Combat Harness (Deacon)"
	icon_state = "combatharness_deacon"
	item_state = "combatharness_deacon"
	//
	totalshields = 60
	specials = list(/datum/armourspecials/shields/unggoy)

/obj/item/clothing/suit/armor/special/unggoy_combat_harness/ultra
	name = "Unggoy Combat Harness (Ultra)"
	icon_state = "combatharness_ultra"
	item_state = "combatharness_ultra"
	//
	totalshields = 100
	specials = list(/datum/armourspecials/shields/unggoy)
	//same as a marine
	armor = list(melee = 55, bullet = 50, laser = 55, energy = 45, bomb = 40, bio = 25, rad = 25)

/obj/item/clothing/suit/armor/special/unggoy_combat_harness/specops
	name = "Unggoy Combat Harness (Spec-Ops)"
	icon_state = "combatharness_specops"
	item_state = "combatharness_specops"
	//
	action_button_name = "Toggle Active Camouflage"
	specials = list(/datum/armourspecials/cloaking)
	//same as a marine
	armor = list(melee = 55, bullet = 50, laser = 55, energy = 45, bomb = 40, bio = 25, rad = 25)

/obj/item/clothing/suit/armor/special/unggoy_combat_harness/honour_guard
	name = "Unggoy Combat Harness (Honour Guard)"
	icon_state = "combatharness_honour"
	item_state = "combatharness_honour"
	//
	totalshields = 150
	specials = list(/datum/armourspecials/shields/unggoy)
	//same as a marine
	armor = list(melee = 55, bullet = 50, laser = 55, energy = 45, bomb = 40, bio = 25, rad = 25)



/* CUSTOM GAMEMODE VARIANTS */

/obj/item/clothing/suit/armor/special/unggoy_combat_harness/ramclan
	name = "Ram Clan Unggoy Harness"
	icon_state = "combatharness_blue"
	item_state = "combatharness_blue"

/obj/item/clothing/suit/armor/special/unggoy_combat_harness/boulderclan
	name = "Boulder Clan Unggoy Harness"
	icon_state = "combatharness_red"
	item_state = "combatharness_red"

/obj/item/clothing/suit/armor/special/unggoy_combat_harness/first_contact
	name = "Unggoy Combat Harness, Modified"
	desc = "An unggoy combat harness, with plating stripped and assumadly sold off for Gekz."
	armor = list(melee = 30, bullet = 40, laser = 40, energy = 40, bomb = 40, bio = 20, rad = 20)
