//Regular syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate
	name = "red space helmet"
	icon_state = "syndicate"
	item_state = "syndicate"
	desc = "A crimson helmet sporting clean lines and durable plating. Engineered to look menacing."
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SMALL,
		rad = ARMOR_RAD_MINOR
		)
	siemens_coefficient = 0.3

/obj/item/clothing/suit/space/syndicate
	name = "red space suit"
	icon_state = "syndicate"
	item_state_slots = list(
		slot_l_hand_str = "space_suit_syndicate",
		slot_r_hand_str = "space_suit_syndicate",
	)
	desc = "A crimson spacesuit sporting clean lines and durable plating. Robust, reliable, and slightly suspicious."
	w_class = ITEM_SIZE_NORMAL
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy/sword,/obj/item/weapon/handcuffs,/obj/item/weapon/tank/emergency)
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SMALL,
		rad = ARMOR_RAD_MINOR
		)
	siemens_coefficient = 0.3

/obj/item/clothing/suit/space/syndicate/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 1

//Green syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/green
	name = "green space helmet"
	icon_state = "syndicate-helm-green"
	item_state = "syndicate-helm-green"

/obj/item/clothing/suit/space/syndicate/green
	name = "green space suit"
	icon_state = "syndicate-green"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-green",
		slot_r_hand_str = "syndicate-green",
	)


//Dark green syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/green/dark
	name = "dark green space helmet"
	icon_state = "syndicate-helm-green-dark"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-helm-green-dark",
		slot_r_hand_str = "syndicate-helm-green-dark",
	)

/obj/item/clothing/suit/space/syndicate/green/dark
	name = "dark green space suit"
	icon_state = "syndicate-green-dark"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-green-dark",
		slot_r_hand_str = "syndicate-green-dark",
	)


//Orange syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/orange
	name = "orange space helmet"
	icon_state = "syndicate-helm-orange"
	item_state = "syndicate-helm-orange"

/obj/item/clothing/suit/space/syndicate/orange
	name = "orange space suit"
	icon_state = "syndicate-orange"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-orange",
		slot_r_hand_str = "syndicate-orange",
	)


//Blue syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/blue
	name = "blue space helmet"
	icon_state = "syndicate-helm-blue"
	item_state = "syndicate-helm-blue"

/obj/item/clothing/suit/space/syndicate/blue
	name = "blue space suit"
	icon_state = "syndicate-blue"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-blue",
		slot_r_hand_str = "syndicate-blue",
	)


//Black syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/black
	name = "black space helmet"
	icon_state = "syndicate-helm-black"
	item_state = "syndicate-helm-black"

/obj/item/clothing/suit/space/syndicate/black
	name = "black space suit"
	icon_state = "syndicate-black"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-black",
		slot_r_hand_str = "syndicate-black",
	)


//Black-green syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/black/green
	name = "black and green space helmet"
	icon_state = "syndicate-helm-black-green"
	item_state = "syndicate-helm-black-green"

/obj/item/clothing/suit/space/syndicate/black/green
	name = "black and green space suit"
	icon_state = "syndicate-black-green"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-black-green",
		slot_r_hand_str = "syndicate-black-green",
	)


//Black-blue syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/black/blue
	name = "black and blue space helmet"
	icon_state = "syndicate-helm-black-blue"
	item_state = "syndicate-helm-black-blue"

/obj/item/clothing/suit/space/syndicate/black/blue
	name = "black and blue space suit"
	icon_state = "syndicate-black-blue"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-black-blue",
		slot_r_hand_str = "syndicate-black-blue",
	)


//Black medical syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/black/med
	name = "black medical space helmet"
	icon_state = "syndicate-helm-black-med"
	item_state_slots = list(slot_head_str = "syndicate-helm-black-med")

/obj/item/clothing/suit/space/syndicate/black/med
	name = "black medical space suit"
	icon_state = "syndicate-black-med"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-black",
		slot_r_hand_str = "syndicate-black",
	)


//Black-orange syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/black/orange
	name = "black and orange space helmet"
	icon_state = "syndicate-helm-black-orange"
	item_state_slots = list(slot_head_str = "syndicate-helm-black-orange")

/obj/item/clothing/suit/space/syndicate/black/orange
	name = "black and orange space suit"
	icon_state = "syndicate-black-orange"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-black",
		slot_r_hand_str = "syndicate-black",
	)


//Black-red syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/black/red
	name = "black and red space helmet"
	icon_state = "syndicate-helm-black-red"
	item_state = "syndicate-helm-black-red"

/obj/item/clothing/suit/space/syndicate/black/red
	name = "black and red space suit"
	icon_state = "syndicate-black-red"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-black-red",
		slot_r_hand_str = "syndicate-black-red",
	)

//Black with yellow/red engineering syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/black/engie
	name = "black engineering space helmet"
	icon_state = "syndicate-helm-black-engie"
	item_state_slots = list(slot_head_str = "syndicate-helm-black-engie")

/obj/item/clothing/suit/space/syndicate/black/engie
	name = "black engineering space suit"
	icon_state = "syndicate-black-engie"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-black",
		slot_r_hand_str = "syndicate-black",
	)
