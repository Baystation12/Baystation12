/obj/item/clothing/head/bandana/familiarband
	name = "familiar's headband"
	desc = "It’s a simple headband made of leather."
	icon_state = "familiarband"

/obj/item/clothing/under/familiargarb
	name = "familiar's garb"
	desc = "It looks like a cross between Robin Hood’s tunic and some patchwork leather armor. Whoever put this together must have been in a hurry."
	icon_state = "familiartunic"
	armor = list(melee = 30, bullet = 5, laser = 10, energy = 30, bomb = 0, bio = 0, rad = 0)
	species_restricted = list(SPECIES_HUMAN)

/obj/item/clothing/under/familiargard/New()
	..()
	slowdown_per_slot[slot_w_uniform] = -3