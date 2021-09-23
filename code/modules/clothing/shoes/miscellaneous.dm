/obj/item/clothing/shoes/syndigaloshes
	desc = "A pair of brown shoes. They seem to have extra grip."
	name = "brown shoes"
	icon_state = "brown"
	item_state = "brown"
	permeability_coefficient = 0.05
	item_flags = ITEM_FLAG_NOSLIP
	origin_tech = list(TECH_ESOTERIC = 3)
	var/list/clothing_choices = list()
	siemens_coefficient = 0.8
	species_restricted = null

/obj/item/clothing/shoes/mime
	name = "mime shoes"
	icon_state = "mime"
	can_add_cuffs = FALSE

/obj/item/clothing/shoes/swat
	name = "\improper SWAT boots"
	desc = "When you want to turn up the heat."
	icon_state = "swat"
	force = 3
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_MINOR
		)
	item_flags = ITEM_FLAG_NOSLIP | ITEM_FLAG_WASHER_ALLOWED
	siemens_coefficient = 0.6

/obj/item/clothing/shoes/combat //Basically SWAT shoes combined with galoshes.
	name = "combat boots"
	desc = "When you REALLY want to turn up the heat."
	icon_state = "jungle"
	force = 5
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_MINOR
		)
	item_flags = ITEM_FLAG_NOSLIP | ITEM_FLAG_WASHER_ALLOWED
	siemens_coefficient = 0.6

	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/shoes/jungleboots
	name = "jungle boots"
	desc = "A pair of durable brown boots. Waterproofed for use planetside."
	icon_state = "jungle"
	force = 3
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_MINOR
		)
	siemens_coefficient = 0.7

/obj/item/clothing/shoes/desertboots
	name = "desert boots"
	desc = "A pair of durable tan boots. Designed for use in hot climates."
	icon_state = "desert"
	force = 3
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_MINOR
		)
	siemens_coefficient = 0.7

/obj/item/clothing/shoes/dutyboots
	name = "duty boots"
	desc = "A pair of steel-toed synthleather boots with a mirror shine."
	icon_state = "duty"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		rad = ARMOR_RAD_MINOR
		)
	siemens_coefficient = 0.7
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = FEET
	heat_protection = FEET
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	max_pressure_protection = FIRESUIT_MAX_PRESSURE

/obj/item/clothing/shoes/tactical
	name = "tactical boots"
	desc = "Tan boots with extra padding and armor."
	icon_state = "desert"
	force = 3
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_RESISTANT)
	siemens_coefficient = 0.7

/obj/item/clothing/shoes/dress
	name = "dress shoes"
	desc = "The height of fashion, and they're pre-polished!"
	icon_state = "laceups"
	can_add_hidden_item = FALSE
	can_add_cuffs = FALSE

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
	wizard_garb = TRUE
	can_add_hidden_item = FALSE
	can_add_cuffs = FALSE

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
	can_add_hidden_item = FALSE

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
	item_flags = null

/obj/item/clothing/shoes/slippers
	name = "bunny slippers"
	desc = "Fluffy!"
	icon_state = "slippers"
	item_state = "slippers"
	force = 0
	species_restricted = null
	w_class = ITEM_SIZE_SMALL
	can_add_hidden_item = FALSE
	can_add_cuffs = FALSE

/obj/item/clothing/shoes/slippers/worn
	name = "worn bunny slippers"
	desc = "Fluffy..."
	icon_state = "slippers_worn"
	item_state = "slippers_worn"

/obj/item/clothing/shoes/laceup
	name = "laceup shoes"
	desc = "The height of fashion, and they're pre-polished!"
	icon_state = "laceups"
	can_add_hidden_item = FALSE
	can_add_cuffs = FALSE

/obj/item/clothing/shoes/swimmingfins
	desc = "Help you swim good."
	name = "swimming fins"
	icon_state = "flippers"
	item_flags = ITEM_FLAG_NOSLIP
	species_restricted = null
	can_add_hidden_item = FALSE
	can_add_cuffs = FALSE

/obj/item/clothing/shoes/swimmingfins/New()
	..()
	slowdown_per_slot[slot_shoes] = 1

/obj/item/clothing/shoes/athletic
	name = "athletic shoes"
	desc = "A pair of sleek atheletic shoes. Made by and for the sporty types."
	icon_state = "sportshoe"

/obj/item/clothing/shoes/laceup/sneakies
	desc = "The height of fashion, and they're pre-polished. Upon further inspection, the soles appear to be on backwards. They look uncomfortable."
	species_restricted = list(SPECIES_HUMAN, SPECIES_IPC)
	move_trail = /obj/effect/decal/cleanable/blood/tracks/footprints/reversed
	item_flags = ITEM_FLAG_SILENT

/obj/item/clothing/shoes/heels
	name = "high heels"
	icon_state = "heels"
	desc = "A pair of colourable high heels."
	can_add_cuffs = FALSE

/obj/item/clothing/shoes/heels/black
	name = "black high heels"
	desc = "A pair of black high heels."
	color = COLOR_GRAY15

obj/item/clothing/shoes/heels/red
	name = "red high heels"
	desc = "A pair of red high heels."
	color = COLOR_RED

/obj/item/clothing/shoes/foamclog
	name = "foam clog"
	desc = "Made from durable foam resin that retains its spongy feel."
	icon_state = "foamclog"
	can_add_hidden_item = FALSE
	can_add_cuffs = FALSE

/obj/item/clothing/shoes/foamclog/random/New()
	..()
	color = get_random_colour()
