/obj/item/clothing/head/caretakerhood
	name = "holy hood"
	desc = "The hood of a shining white robe, with blue trim. Who would possess this robe and still want to hide themself away?"
	icon_state = "caretakerhood"
	armor = list(
		melee = ARMOR_MELEE_KNIVES, 
		bullet = ARMOR_BALLISTIC_MINOR, 
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL, 
		rad = ARMOR_RAD_SHIELDED
	)
	species_restricted = list(SPECIES_HUMAN)
	flags_inv = HIDEEARS | BLOCKHAIR

/obj/item/clothing/suit/caretakercloak
	name = "holy cloak"
	desc = "A shining white and blue robe. For some reason, it reminds you of the holidays."
	icon_state = "caretakercloak"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT, 
		bullet = ARMOR_BALLISTIC_PISTOL, 
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_RESISTANT, 
		rad = ARMOR_RAD_SHIELDED
	)

/obj/item/clothing/under/caretaker
	name = "caretaker's jumpsuit"
	desc = "A holy jumpsuit. Treat it well."
	icon_state = "caretaker"
	species_restricted = list(SPECIES_HUMAN)

/obj/item/clothing/shoes/dress/caretakershoes
	name = "black leather shoes"
	desc = "Dress shoes. These aren't as shiny as usual."
	icon_state = "caretakershoes"
	armor = list(
		rad = ARMOR_RAD_SHIELDED
	)