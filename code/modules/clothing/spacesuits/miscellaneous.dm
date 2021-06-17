//Deathsquad suit
/obj/item/clothing/head/helmet/space/deathsquad
	name = "deathsquad helmet"
	desc = "That's not red paint. That's real blood."
	icon_state = "deathsquad"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-helm-black-red",
		slot_r_hand_str = "syndicate-helm-black-red",
		)
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	min_pressure_protection = 0
	flags_inv = BLOCKHAIR
	siemens_coefficient = 0.6

//Space santa outfit suit
/obj/item/clothing/head/helmet/space/santahat
	name = "Santa's hat"
	desc = "Ho ho ho. Merrry X-mas!"
	icon_state = "santahat"
	item_state = "santahat"
	flags_inv = BLOCKHAIR
	body_parts_covered = HEAD

/obj/item/clothing/suit/space/santa
	name = "Santa's suit"
	desc = "Festive!"
	icon_state = "santa"
	allowed = list(/obj/item) //for stuffing exta special presents

/obj/item/clothing/suit/space/santa/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 0

//Orange emergency space suit
/obj/item/clothing/head/helmet/space/emergency
	name = "emergency space helmet"
	icon_state = "spacebowl"
	light_overlay = "yellow_light"
	desc = "A simple helmet with a built-in light. Smells like mothballs."
	flash_protection = FLASH_PROTECTION_NONE

/obj/item/clothing/suit/space/emergency
	name = "emergency softsuit"
	icon_state = "space_emergency"
	desc = "A thin, ungainly softsuit colored in blaze orange for rescuers to easily locate. Looks pretty fragile."

/obj/item/clothing/suit/space/emergency/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 4

/obj/item/clothing/head/helmet/space/fishbowl
	name = "spacesuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. The tinting can be toggled for flash protection at the cost of worse visibility."
	icon_state = "spacebowl"
	light_overlay = "yellow_light"
	tinted = FALSE
