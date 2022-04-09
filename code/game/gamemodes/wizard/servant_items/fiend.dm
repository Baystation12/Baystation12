/obj/item/clothing/head/fiendhood
	name = "fiend's hood"
	desc = "A dark hood with blood-red trim. Something about the fabric blocks more light than it should."
	icon_state = "fiendhood"
	armor = list(
		melee = ARMOR_MELEE_KNIVES, 
		bullet = ARMOR_BALLISTIC_MINOR, 
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL, 
		rad = ARMOR_RAD_SHIELDED
	)
	species_restricted = list(SPECIES_HUMAN)
	flags_inv = HIDEEARS | BLOCKHAIR

/obj/item/clothing/suit/fiendcowl
	name = "fiend's cowl"
	desc = "A charred black duster with red trim. In its fabric, you can see the faint outline of millions of eyes."
	icon_state = "fiendcowl"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(
		melee = ARMOR_MELEE_RESISTANT, 
		bullet = ARMOR_BALLISTIC_PISTOL, 
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_RESISTANT, 
		rad = ARMOR_RAD_SHIELDED
	)

/obj/item/clothing/under/lawyer/fiendsuit
	name = "black suit"
	desc = "A snappy black suit with red trim. The undershirt's stained with something, though..."
	icon_state = "fiendsuit"
	species_restricted = list(SPECIES_HUMAN)

/obj/item/clothing/shoes/dress/devilshoes
	name = "dress shoes"
	desc = "Off-colour leather dress shoes. Their footsteps are silent."
	icon_state = "fiendshoes"
	item_flags = ITEM_FLAG_SILENT

/obj/item/clothing/head/fiendhood/fem
	name = "fiend's visage"
	desc = "To gaze upon this is to gaze into an inferno. Look away, before it looks back of its own accord."
	icon_state = "fiendvisage"
	flags_inv = HIDEEARS | BLOCKHAIR

/obj/item/clothing/suit/fiendcowl/fem
	name = "fiend's robe"
	icon_state = "fiendrobe"
	desc = "A tattered, black and red robe. Nothing is visible through the holes in its fabric, except for a strange, inky blackness. It looks as if it was stitched together with other clothing..."

/obj/item/clothing/under/devildress
	name = "old dress"
	desc = "An elegant - if tattered - black and red dress. There's nothing visible through the holes in the fabric; nothing but darkness."
	icon_state = "fienddress"
