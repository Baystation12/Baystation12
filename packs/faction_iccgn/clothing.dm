
//Main Clothing
/obj/item/clothing/under/iccgn
	name = "base uniform, ICCGN"
	desc = "You should not see this."
	icon = 'packs/faction_iccgn/clothing.dmi'
	item_icons = list(
		slot_w_uniform_str = 'packs/faction_iccgn/clothing.dmi'
	)
	sprite_sheets = list()
	icon_state = "error"
	body_parts_covered = FULL_TORSO | ARMS | FULL_LEGS
	siemens_coefficient = 0.9
	armor = list(
		melee = ARMOR_MELEE_MINOR,
		energy = ARMOR_ENERGY_MINOR
	)


/obj/item/clothing/under/iccgn/Initialize()
	. = ..()
	INIT_SKIP_QDELETED
	INIT_DISALLOW_TYPE(/obj/item/clothing/under/iccgn)


/obj/item/clothing/under/iccgn/get_gender_suffix(suffix)
	return ""


/obj/item/clothing/under/iccgn/get_icon_state(mob/user_mob, slot)
	return item_state_slots[slot]


/obj/item/clothing/under/iccgn/pt
	name = "physical training uniform, ICCGN"
	desc = "A comfortable set of clingy shorts and a t-shirt sporting the insigna of the confederation navy."
	icon_state = "under_pt"
	item_state_slots = list(
		slot_l_hand_str = "under_pt_held_l",
		slot_r_hand_str = "under_pt_held_r",
		slot_w_uniform_str = "under_pt_worn"
	)


/obj/item/clothing/under/iccgn/utility
	name = "utility uniform, ICCGN"
	desc = "A comfortable black utility jumpsuit from a confederation navy uniform."
	icon_state = "under_utility"
	item_state_slots = list(
		slot_l_hand_str = "under_utility_held_l",
		slot_r_hand_str = "under_utility_held_r",
		slot_w_uniform_str = "under_utility_worn"
	)


/obj/item/clothing/under/iccgn/service
	name = "service uniform, ICCGN"
	desc = "A smart service shirt and dress pants from a confederation navy uniform."
	icon_state = "under_service"
	item_state_slots = list(
		slot_l_hand_str = "under_service_held_l",
		slot_r_hand_str = "under_service_held_r",
		slot_w_uniform_str = "under_service_worn"
	)


/obj/item/clothing/under/iccgn/service_command
	name = "service uniform, ICCGN"
	desc = "A smart senior officers' shirt and dress pants from a confederation navy uniform."
	icon_state = "under_service_command"
	item_state_slots = list(
		slot_l_hand_str = "under_service_command_held_l",
		slot_r_hand_str = "under_service_command_held_r",
		slot_w_uniform_str = "under_service_command_worn"
	)


//Over Clothing
/obj/item/clothing/suit/iccgn
	name = "base jacket, ICCGN"
	desc = "You should not see this."
	icon = 'packs/faction_iccgn/clothing.dmi'
	item_icons = list(
		slot_wear_suit_str = 'packs/faction_iccgn/clothing.dmi'
	)
	sprite_sheets = list()
	icon_state = "error"
	body_parts_covered = FULL_TORSO | ARMS
	siemens_coefficient = 0.9
	valid_accessory_slots = list(
		ACCESSORY_SLOT_RANK,
		ACCESSORY_SLOT_INSIGNIA,
		ACCESSORY_SLOT_MEDAL
	)
	allowed = list()


/obj/item/clothing/suit/iccgn/Initialize()
	. = ..()
	INIT_SKIP_QDELETED
	INIT_DISALLOW_TYPE(/obj/item/clothing/suit/iccgn)


/obj/item/clothing/suit/iccgn/utility
	name = "utility jacket, ICCGN"
	desc = "A rugged utility jacket from a confederation navy uniform."
	icon_state = "suit_utility"
	item_state_slots = list(
		slot_l_hand_str = "suit_utility_held_l",
		slot_r_hand_str = "suit_utility_held_r",
		slot_wear_suit_str = "suit_utility_worn"
	)
	accessories = list(
		/obj/item/clothing/accessory/storage/pockets
	)


/obj/item/clothing/suit/iccgn/service_enlisted
	name = "service jacket, ICCGN"
	desc = "A slick enlisted persons' service jacket from a confederation navy uniform."
	icon_state = "suit_service"
	item_state_slots = list(
		slot_l_hand_str = "suit_service_held_l",
		slot_r_hand_str = "suit_service_held_r",
		slot_wear_suit_str = "suit_service_worn"
	)
	accessories = list(
		/obj/item/clothing/accessory/storage/pockets,
		/obj/item/clothing/accessory/iccgn_badge/enlisted
	)


/obj/item/clothing/suit/iccgn/service_officer
	name = "service jacket, ICCGN"
	desc = "A slick officers' service jacket from a confederation navy uniform."
	icon_state = "suit_service"
	item_state_slots = list(
		slot_l_hand_str = "suit_service_held_l",
		slot_r_hand_str = "suit_service_held_r",
		slot_wear_suit_str = "suit_service_worn"
	)
	accessories = list(
		/obj/item/clothing/accessory/storage/pockets,
		/obj/item/clothing/accessory/iccgn_badge/officer
	)


/obj/item/clothing/suit/iccgn/service_command
	name = "service jacket, ICCGN"
	desc = "A slick senior officers' service jacket from a confederation navy uniform."
	icon_state = "suit_service_command"
	item_state_slots = list(
		slot_l_hand_str = "suit_service_held_l",
		slot_r_hand_str = "suit_service_held_r",
		slot_wear_suit_str = "suit_service_command_worn"
	)
	accessories = list(
		/obj/item/clothing/accessory/storage/pockets,
		/obj/item/clothing/accessory/iccgn_badge/officer
	)


/obj/item/clothing/suit/iccgn/dress_enlisted
	name = "dress cloak, ICCGN"
	desc = "A stylish enlisted persons' dress cloak from a confederation navy uniform."
	icon_state = "suit_dress_enlisted"
	item_state_slots = list(
		slot_l_hand_str = "suit_dress_enlisted_held_l",
		slot_r_hand_str = "suit_dress_enlisted_held_r",
		slot_wear_suit_str = "suit_dress_enlisted_worn"
	)
	accessories = list(
		/obj/item/clothing/accessory/iccgn_badge/enlisted
	)
	allowed = list()


/obj/item/clothing/suit/iccgn/dress_officer
	name = "dress cloak, ICCGN"
	desc = "A stylish officers' dress cloak from a confederation navy uniform."
	icon_state = "suit_dress_officer"
	item_state_slots = list(
		slot_l_hand_str = "suit_dress_officer_held_l",
		slot_r_hand_str = "suit_dress_officer_held_r",
		slot_wear_suit_str = "suit_dress_officer_worn"
	)
	accessories = list(
		/obj/item/clothing/accessory/iccgn_badge/officer
	)
	allowed = list()


/obj/item/clothing/suit/iccgn/dress_command
	name = "dress cloak, ICCGN"
	desc = "A stylish senior officers' dress cloak from a confederation navy uniform."
	icon_state = "suit_dress_command"
	item_state_slots = list(
		slot_l_hand_str = "suit_dress_command_held_l",
		slot_r_hand_str = "suit_dress_command_held_r",
		slot_wear_suit_str = "suit_dress_command_worn"
	)
	accessories = list(
		/obj/item/clothing/accessory/iccgn_badge/officer
	)
	allowed = list()


//Gloves
/obj/item/clothing/gloves/iccgn
	name = "base gloves, ICCGN"
	desc = "You should not see this."
	icon = 'packs/faction_iccgn/clothing.dmi'
	item_icons = list(
		slot_gloves_str = 'packs/faction_iccgn/clothing.dmi'
	)
	sprite_sheets = list()
	icon_state = "error"


/obj/item/clothing/gloves/iccgn/Initialize()
	. = ..()
	INIT_SKIP_QDELETED
	INIT_DISALLOW_TYPE(/obj/item/clothing/gloves/iccgn)


/obj/item/clothing/gloves/iccgn/duty
	name = "duty gloves, ICCGN"
	desc = "Regal black utility gloves from a confederation navy uniform."
	icon_state = "gloves_utility"
	item_state_slots = list(
		slot_l_hand_str = "gloves_utility_held_l",
		slot_r_hand_str = "gloves_utility_held_r",
		slot_gloves_str = "gloves_utility_worn"
	)


//Shoes
/obj/item/clothing/shoes/iccgn
	name = "base shoes, ICCGN"
	desc = "You should not see this."
	icon = 'packs/faction_iccgn/clothing.dmi'
	item_icons = list(
		slot_shoes_str = 'packs/faction_iccgn/clothing.dmi'
	)
	sprite_sheets = list()
	icon_state = "error"


/obj/item/clothing/shoes/iccgn/Initialize()
	. = ..()
	INIT_SKIP_QDELETED
	INIT_DISALLOW_TYPE(/obj/item/clothing/shoes/iccgn)


/obj/item/clothing/shoes/iccgn/utility
	name = "duty boots, ICCGN"
	desc = "Spectacularly shiny utility boots from a confederation navy uniform."
	icon_state = "boots_utility"
	item_state_slots = list(
		slot_l_hand_str = "boots_utility_held_l",
		slot_r_hand_str = "boots_utility_held_r",
		slot_shoes_str = "boots_utility_worn"
	)


/obj/item/clothing/shoes/iccgn/service
	name = "service boots, ICCGN"
	desc = "Extra tall service boots from a confederation navy uniform."
	icon_state = "boots_service"
	item_state_slots = list(
		slot_l_hand_str = "boots_service_held_l",
		slot_r_hand_str = "boots_service_held_r",
		slot_shoes_str = "boots_service_worn"
	)


//Hats
/obj/item/clothing/head/iccgn
	name = "base hat, ICCGN"
	desc = "You should not see this."
	icon = 'packs/faction_iccgn/clothing.dmi'
	item_icons = list(
		slot_head_str = 'packs/faction_iccgn/clothing.dmi'
	)
	sprite_sheets = list()
	icon_state = "error"


/obj/item/clothing/head/iccgn/Initialize()
	. = ..()
	INIT_SKIP_QDELETED
	INIT_DISALLOW_TYPE(/obj/item/clothing/head/iccgn)


/obj/item/clothing/head/iccgn/beret
	name = "uniform beret, ICCGN"
	desc = "A slick grey beret from a confederation navy uniform."
	icon_state = "hat_beret"
	item_state_slots = list(
		slot_l_hand_str = "hat_beret_held_l",
		slot_r_hand_str = "hat_beret_held_r",
		slot_head_str = "hat_beret_worn"
	)


/obj/item/clothing/head/iccgn/service
	name = "service cover, ICCGN"
	desc = "A peaked service cap from a confederation navy uniform."
	icon_state = "hat_service"
	item_state_slots = list(
		slot_l_hand_str = "hat_service_held_l",
		slot_r_hand_str = "hat_service_held_r",
		slot_head_str = "hat_service_worn"
	)


/obj/item/clothing/head/iccgn/service_command
	name = "service cover, ICCGN"
	desc = "A senior officers' peaked service cap from a confederation navy uniform."
	icon_state = "hat_service_command"
	item_state_slots = list(
		slot_l_hand_str = "hat_service_command_held_l",
		slot_r_hand_str = "hat_service_command_held_r",
		slot_head_str = "hat_service_command_worn"
	)
