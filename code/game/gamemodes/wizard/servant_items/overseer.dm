/obj/item/clothing/head/overseerhood
	name = "grim hood"
	desc = "Darker than dark. What... what is this <i>made</i> of?"
	armor = list(melee = 100, bullet = 100, laser = 100,energy = 100, bomb = 100, bio = 0, rad = 0)
	icon_state = "necromancer"
	item_flags = ITEM_FLAG_AIRTIGHT
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	min_pressure_protection = 0
	species_restricted = list(SPECIES_HUMAN)
	flags_inv = HIDEEARS | BLOCKHAIR

/obj/item/clothing/suit/straight_jacket/overseercloak
	name = "grim cloak"
	desc = "The void of space woven into fabric. It's hard to tell where its edges are."
	icon_state = "overseercloak"
	armor = list(melee = 100, bullet = 100, laser = 100,energy = 100, bomb = 100, bio = 0, rad = 0)
	item_flags = ITEM_FLAG_AIRTIGHT
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	min_pressure_protection = 0
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/under/grimhoodie
	name = "black hoodie"
	desc = "A generic black hoodie. There's a pattern akin to splattered blood along the bottom."
	icon_state = "grimhoodie"
	species_restricted = list(SPECIES_HUMAN)

//These are the ones that it gets when they toggle it off
/obj/item/clothing/shoes/sandals/grimboots
	name = "stained boots"
	desc = "These boots are stained with blood so dry that it's turned black..."
	icon_state = "grimboots"
	item_flags = ITEM_FLAG_SILENT