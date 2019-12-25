/obj/item/clothing/head/infilhat
	name = "immaculate fedora"
	desc = "Whoever owns this hat means business. Hopefully, it's just good business."
	icon_state = "infhat"
	armor = list(
		melee = ARMOR_MELEE_MINOR, 
		bullet = ARMOR_BALLISTIC_MINOR, 
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR
		)
	species_restricted = list(SPECIES_HUMAN)

/obj/item/clothing/suit/infilsuit
	name = "immaculate suit"
	desc = "The clothes of an impeccable diplomat. Or perhaps a businessman. Let's not consider the horrors that might arise if it belongs to a lawyer."
	icon_state = "infsuit"
	armor = list(
		melee = ARMOR_MELEE_MINOR, 
		bullet = ARMOR_BALLISTIC_PISTOL, 
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR
		)

/obj/item/clothing/under/lawyer/infil
	name = "formal outfit"
	desc = "A white dress shirt and navy pants. Snazzy."
	icon_state = "inf_mob"
	species_restricted = list(SPECIES_HUMAN)

/obj/item/clothing/shoes/dress/infilshoes
	name = "black leather shoes"
	desc = "Dress shoes. Their footsteps are dead silent."
	icon_state = "infshoes"
	item_flags = ITEM_FLAG_SILENT

/obj/item/clothing/head/infilhat/fem
	name = "maid's headband"
	desc = "This dainty, frilled thing is apparently meant to go on your head."
	icon_state = "infhatfem"

/obj/item/clothing/suit/infilsuit/fem
	name = "maid's uniform"
	desc = "The uniform of someone you'd expect to see dusting off the Antique Gun's display case."
	icon_state = "infdress"

/obj/item/clothing/under/lawyer/infil/fem
	name = "white dress"
	desc = "It's a simple, sleeveless white dress with black trim."
	icon_state = "inffem"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET