/obj/item/clothing/shoes/kneesocks
	name = "kneesocks"
	desc = "A pair of girly knee-high socks"
	icon_state = "eros_kneesock"
	item_state = "eros_kneesock"

/obj/item/clothing/shoes/jestershoes
	name = "jester shoes"
	desc = "As worn by the clowns of old."
	icon_state = "eros_jestershoes"
	item_state = "eros_jestershoes"

/obj/item/clothing/shoes/aviatorboots
	name = "aviator boots"
	desc = "Boots suitable for just about any occasion"
	icon_state = "eros_aviator_boots"
	item_state = "eros_aviator_boots"
	can_hold_knife = 1

/obj/item/clothing/shoes/tourist
	name = "tourist sandals"
	desc = "Socks with sandals..?"
	icon_state = "eros_tourist"
	item_state = "eros_tourist"

/obj/item/clothing/shoes/lolitastockings
	name = "lolita stockings"
	desc = ""
	icon_state = "eros_lolitastockings"
	item_state = "eros_lolitastockings"

/obj/item/clothing/shoes/sneakers
	name = "sneakers"
	desc = "Good all-purpose shoes."
	icon_state = "eros_sneakers"
	item_state = "eros_sneakers"

/obj/item/clothing/shoes/cowboy
	name = "cowboy boots"
	desc = "Not a lot of horses to ride in space."
	icon_state = "cowboy"
	item_state = "cowboy"
	can_hold_knife = 1

/obj/item/clothing/shoes/winterboots
	name = "winter boots"
	desc = "Boots lined with 'synthetic' animal fur."
	icon_state = "winterboots"
	item_state = "winterboots"
	can_hold_knife = 1
	cold_protection = FEET|LEGS
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET|LEGS
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/shoes/laces
	name = "lace sandals"
	desc = ""
	icon_state = "eros_laces"
	item_state = "eros_laces"
	body_parts_covered = 0

/obj/item/clothing/shoes/flipflop
	name = "flip flops"
	desc = "A pair of foam flip flops. For those not afraid to show a little ankle."
	icon_state = "thongsandal"
	item_state = "thongsandal"
	body_parts_covered = 0
	force = 0

/obj/item/clothing/shoes/flats
	name = "black flats"
	desc = "Sleek black flats."
	icon_state = "flatsblack"
	icon_state = "flatsblack"
	item_state_slots = list(slot_r_hand_str = "black", slot_l_hand_str = "black")

/obj/item/clothing/shoes/flats/white
	name = "white flats"
	desc = "Shiny white flats."
	icon_state = "flatswhite"
	icon_state = "flatswhite"
	item_state_slots = list(slot_r_hand_str = "white", slot_l_hand_str = "white")

/obj/item/clothing/shoes/flats/red
	name = "red flats"
	desc = "Ruby red flats."
	icon_state = "flatsred"
	icon_state = "flatsred"
	item_state_slots = list(slot_r_hand_str = "red", slot_l_hand_str = "red")

/obj/item/clothing/shoes/flats/purple
	name = "purple flats"
	desc = "Royal purple flats."
	icon_state = "flatspurple"
	icon_state = "flatspurple"
	item_state_slots = list(slot_r_hand_str = "purple", slot_l_hand_str = "purple")

/obj/item/clothing/shoes/flats/blue
	name = "blue flats"
	desc = "Sleek blue flats."
	icon_state = "flatsblue"
	icon_state = "flatsblue"
	item_state_slots = list(slot_r_hand_str = "blue", slot_l_hand_str = "blue")

/obj/item/clothing/shoes/flats/brown
	name = "brown flats"
	desc = "Sleek brown flats."
	icon_state = "flatsbrown"
	icon_state = "flatsbrown"
	item_state_slots = list(slot_r_hand_str = "brown", slot_l_hand_str = "brown")

/obj/item/clothing/shoes/flats/orange
	name = "orange flats"
	desc = "Radiant orange flats."
	icon_state = "flatsorange"
	icon_state = "flatsorange"
	item_state_slots = list(slot_r_hand_str = "orange", slot_l_hand_str = "orange")

/obj/item/clothing/shoes/workbootsalt
	desc = "A pair of steel-toed work boots designed for use in industrial settings. Safety first. These ones look a little older."
	icon_state = "workboots_old"
	icon_state = "workboots_old"
	armor = list(melee = 40, bullet = 0, laser = 0, energy = 15, bomb = 20, bio = 0, rad = 20)
	siemens_coefficient = 0.7
	can_hold_knife = 1

/obj/item/clothing/shoes/fancyboots
	name = "fancy boots"
	desc = "Those look expensive."
	icon_state = "noble_boot"
	icon_state = "noble_boot"
	can_hold_knife = 1
