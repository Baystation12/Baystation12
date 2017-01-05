/obj/item/clothing/shoes/galoshes
	desc = "Rubber boots."
	name = "galoshes"
	icon_state = "galoshes"
	permeability_coefficient = 0.05
	item_flags = NOSLIP
	can_hold_knife = 1
	species_restricted = null

/obj/item/clothing/shoes/galoshes/New()
	..()
	slowdown_per_slot[slot_shoes] = SHOES_SLOWDOWN+1

/obj/item/clothing/shoes/jackboots
	name = "jackboots"
	desc = "Tall synthleather boots with an artificial shine."
	icon_state = "jackboots"
	item_state = "jackboots"
	force = 3
	armor = list(melee = 30, bullet = 10, laser = 10, energy = 15, bomb = 20, bio = 0, rad = 0)
	siemens_coefficient = 0.7
	can_hold_knife = 1

/obj/item/clothing/shoes/jackboots/unathi
	name = "toe-less jackboots"
	desc = "Modified pair of jackboots, particularly comfortable for those species whose toes hold claws."
	item_state = "digiboots"
	icon_state = "digiboots"
	species_restricted = null

/obj/item/clothing/shoes/workboots
	name = "workboots"
	desc = "A pair of steel-toed work boots designed for use in industrial settings. Safety first."
	icon_state = "workboots"
	item_state = "workboots"
	armor = list(melee = 40, bullet = 0, laser = 0, energy = 15, bomb = 20, bio = 0, rad = 20)
	siemens_coefficient = 0.7
	can_hold_knife = 1

/obj/item/clothing/shoes/workboots/toeless
	name = "toe-less workboots"
	desc = "A pair of toeless work boots designed for use in industrial settings. Modified for species whose toes have claws."
	icon_state = "workbootstoeless"
	species_restricted = null