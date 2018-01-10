/obj/item/clothing/shoes/syndigaloshes
	desc = "A pair of brown shoes. They seem to have extra grip."
	name = "brown shoes"
	icon_state = "brown"
	item_state = "brown"
	permeability_coefficient = 0.05
	item_flags = ITEM_FLAG_NOSLIP
	origin_tech = list(TECH_ILLEGAL = 3)
	var/list/clothing_choices = list()
	siemens_coefficient = 0.8
	species_restricted = null

/obj/item/clothing/shoes/mime
	name = "mime shoes"
	icon_state = "mime"

/obj/item/clothing/shoes/swat
	name = "\improper SWAT boots"
	desc = "When you want to turn up the heat."
	icon_state = "swat"
	force = 3
	armor = list(melee = 80, bullet = 60, laser = 60,energy = 25, bomb = 50, bio = 10, rad = 0)
	item_flags = ITEM_FLAG_NOSLIP
	siemens_coefficient = 0.6
	can_hold_knife = 1

/obj/item/clothing/shoes/combat //Basically SWAT shoes combined with galoshes.
	name = "combat boots"
	desc = "When you REALLY want to turn up the heat."
	icon_state = "jungle"
	force = 5
	armor = list(melee = 80, bullet = 60, laser = 60,energy = 25, bomb = 50, bio = 10, rad = 0)
	item_flags = ITEM_FLAG_NOSLIP
	siemens_coefficient = 0.6
	can_hold_knife = 1

	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/shoes/jungleboots
	name = "jungle boots"
	desc = "A pair of durable brown boots. Waterproofed for use planetside."
	icon_state = "jungle"
	force = 3
	armor = list(melee = 30, bullet = 10, laser = 10, energy = 15, bomb = 20, bio = 10, rad = 0)
	siemens_coefficient = 0.7
	can_hold_knife = 1

/obj/item/clothing/shoes/desertboots
	name = "desert boots"
	desc = "A pair of durable tan boots. Designed for use in hot climates."
	icon_state = "desert"
	force = 3
	armor = list(melee = 30, bullet = 10, laser = 10, energy = 15, bomb = 20, bio = 10, rad = 0)
	siemens_coefficient = 0.7
	can_hold_knife = 1

/obj/item/clothing/shoes/dutyboots
	name = "duty boots"
	desc = "A pair of steel-toed synthleather boots with a mirror shine."
	icon_state = "duty"
	armor = list(melee = 40, bullet = 0, laser = 0, energy = 15, bomb = 20, bio = 0, rad = 20)
	siemens_coefficient = 0.7
	can_hold_knife = 1

/obj/item/clothing/shoes/tactical
	name = "tactical boots"
	desc = "Tan boots with extra padding and armor."
	icon_state = "desert"
	force = 3
	armor = list(melee = 40, bullet = 30, laser = 40,energy = 25, bomb = 50, bio = 0, rad = 0)
	siemens_coefficient = 0.7
	can_hold_knife = 1

/obj/item/clothing/shoes/dress
	name = "dress shoes"
	desc = "The height of fashion, and they're pre-polished!"
	icon_state = "laceups"

/obj/item/clothing/shoes/dress/white
	name = "white dress shoes"
	desc = "Brilliantly white shoes, not a spot on them."
	icon_state = "whitedress"

/obj/item/clothing/shoes/sandal
	desc = "A pair of rather plain, wooden sandals."
	name = "sandals"
	icon_state = "wizard"
	species_restricted = null
	body_parts_covered = 0

	wizard_garb = 1

/obj/item/clothing/shoes/sandal/marisa
	desc = "A pair of magic, black shoes."
	name = "magic shoes"
	icon_state = "black"
	body_parts_covered = FEET

/obj/item/clothing/shoes/clown_shoes
	desc = "The prankster's standard-issue clowning shoes. Damn they're huge!"
	name = "clown shoes"
	icon_state = "clown"
	item_state = "clown"
	force = 0
	var/footstep = 1	//used for squeeks whilst walking
	species_restricted = null

/obj/item/clothing/shoes/clown_shoes/New()
	..()
	slowdown_per_slot[slot_shoes]  = 1

/obj/item/clothing/shoes/clown_shoes/handle_movement(var/turf/walking, var/running)
	if(running)
		if(footstep >= 2)
			footstep = 0
			playsound(src, "clownstep", 50, 1) // this will get annoying very fast.
		else
			footstep++
	else
		playsound(src, "clownstep", 20, 1)

/obj/item/clothing/shoes/cult
	name = "boots"
	desc = "A pair of boots worn by the followers of Nar-Sie."
	icon_state = "cult"
	item_state = "cult"
	force = 2
	siemens_coefficient = 0.7

	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
	species_restricted = null

/obj/item/clothing/shoes/cyborg
	name = "cyborg boots"
	desc = "Shoes for a cyborg costume."
	icon_state = "boots"

/obj/item/clothing/shoes/slippers
	name = "bunny slippers"
	desc = "Fluffy!"
	icon_state = "slippers"
	item_state = "slippers"
	force = 0
	species_restricted = null
	w_class = ITEM_SIZE_SMALL

/obj/item/clothing/shoes/slippers_worn
	name = "worn bunny slippers"
	desc = "Fluffy..."
	icon_state = "slippers_worn"
	item_state = "slippers_worn"
	force = 0
	w_class = ITEM_SIZE_SMALL

/obj/item/clothing/shoes/laceup
	name = "laceup shoes"
	desc = "The height of fashion, and they're pre-polished!"
	icon_state = "laceups"

/obj/item/clothing/shoes/swimmingfins
	desc = "Help you swim good."
	name = "swimming fins"
	icon_state = "flippers"
	item_flags = ITEM_FLAG_NOSLIP
	species_restricted = null

/obj/item/clothing/shoes/swimmingfins/New()
	..()
	slowdown_per_slot[slot_shoes] = 1

/obj/item/clothing/shoes/athletic
	name = "athletic shoes"
	desc = "A pair of sleek atheletic shoes. Made by and for the sporty types."
	icon_state = "sportshoe"
