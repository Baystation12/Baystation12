
/obj/item/clothing/suit/armor/vest
	name = "armor"
	desc = "An armored vest that protects against some damage."
	icon_state = "unsc"
	item_state = "unsc"
	blood_overlay_type = "armor"
	armor = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)


/obj/item/clothing/suit/armor/marine
	name = "M52B Body Armor"
	desc = "an armored protective vest worn by the members of the UNSC Marine Corps."
	icon_state = "marine"
	item_state = "marine"
	blood_overlay_type = "armor"
	armor = list(melee = 50, bullet = 95, laser = 4, energy = 4, bomb = 60, bio = 0, rad = 0)

/obj/item/clothing/head/helmet/spartan
	name = "MJOLNIR Powered Assault Armor Helmet"
	desc = "Ave, Imperator, morituri te salutant."
	icon_state = "spartan5"
	item_state_slots = list(
		slot_l_hand_str = "spartan5",
		slot_r_hand_str = "spartan5",
		)
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	body_parts_covered = HEAD|FACE
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 1
	armor = list(melee = 50,bullet = 15,laser = 50,energy = 10,bomb = 25,bio = 0,rad = 0)

/obj/item/clothing/suit/armor/spartan
	name = "MJOLNIR Powered Assault Armor Mark V"
	desc = "a technologically-advanced combat exoskeleton system designed to vastly improve the strength, speed, agility, reflexes and durability of a SPARTAN-II, supersoldier in the field of combat."
	icon_state = "spartan5"
	item_state = "spartan5"
	blood_overlay_type = "armor"
	armor = list(melee = 80, bullet = 95, laser = 50, energy = 50, bomb = 60, bio = 25, rad = 25)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
