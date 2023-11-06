
//Main Clothing
/obj/item/clothing/under/scga
	abstract_type = /obj/item/clothing/under/scga
	name = "base uniform, SCGA"
	desc = "You should not see this."
	icon = 'packs/factions/scga/clothing.dmi'
	item_icons = list(
		slot_w_uniform_str = 'packs/factions/scga/clothing.dmi'
	)
	armor = list(
		melee = ARMOR_MELEE_MINOR,
		energy = ARMOR_BALLISTIC_MINOR
	)
	sprite_sheets = list(
		SPECIES_UNATHI = 'packs/factions/scga/species/clothing_unathi.dmi'
	)


/obj/item/clothing/under/scga/pt
	name = "physical training uniform, SCGA"
	desc = "A flexible set of black shirt and pants. Part of the solar army physical training uniform."
	icon_state = "under_pt"
	item_state_slots = list(
		slot_l_hand_str = "under_pt_held_l",
		slot_r_hand_str = "under_pt_held_r",
		slot_w_uniform_str = "under_pt_worn"
	)


/obj/item/clothing/under/scga/fatigues
	name = "standard fatigues, SCGA"
	desc = "A loose set of green tank-top and brown short-pants. Part of the solar army general off-duty uniform."
	icon_state = "under_fatigues"
	item_state_slots = list(
		slot_l_hand_str = "under_fatigues_held_l",
		slot_r_hand_str = "under_fatigues_held_r",
		slot_w_uniform_str = "under_fatigues_worn"
	)
	body_parts_covered = FULL_TORSO


/obj/item/clothing/under/scga/utility
	name = "utility uniform, SCGA"
	desc = "A green, durable utility jumpsuit. Belonging to the solar army uniform."
	icon_state = "under_utility"
	item_state_slots = list(
		slot_l_hand_str = "under_utility_held_l",
		slot_r_hand_str = "under_utility_held_r",
		slot_w_uniform_str = "under_utility_worn"
	)


/obj/item/clothing/under/scga/utility/tan
	name = "tan utility uniform, SCGA"
	desc = "A tan, durable utility jumpsuit. Belonging to the solar army uniform."
	icon_state = "under_utility_tan"
	item_state_slots = list(
		slot_l_hand_str = "under_utility_tan_held_l",
		slot_r_hand_str = "under_utility_tan_held_r",
		slot_w_uniform_str = "under_utility_tan_worn"
	)


/obj/item/clothing/under/scga/utility/urban
	name = "urban utility uniform, SCGA"
	desc = "A grey, durable utility jumpsuit. Belonging to the solar army utility uniform."
	icon_state = "under_utility_urban"
	item_state_slots = list(
		slot_l_hand_str = "under_utility_urban_held_l",
		slot_r_hand_str = "under_utility_urban_held_r",
		slot_w_uniform_str = "under_utility_urban_worn"
	)


/obj/item/clothing/under/scga/service
	name = "service uniform, SCGA"
	desc = "A slimming brown service shirt and green pants. Belonging to the solar army service uniform."
	icon_state = "under_service"
	item_state_slots = list(
		slot_l_hand_str = "under_service_held_l",
		slot_r_hand_str = "under_service_held_r",
		slot_w_uniform_str = "under_service_worn"
	)


/obj/item/clothing/under/scga/service/skirt
	name = "service skirt uniform, SCGA"
	desc = "A slimming brown service shirt and green skirt. Belonging to the solar army service uniform."
	icon_state = "under_service_skirt"
	item_state_slots = list(
		slot_l_hand_str = "under_service_skirt_held_l",
		slot_r_hand_str = "under_service_skirt_held_r",
		slot_w_uniform_str = "under_service_skirt_worn"
	)


/obj/item/clothing/under/scga/service_command
	name = "service uniform, SCGA"
	desc = "A slimming brown service shirt and green pants with beige streaks, for senior officers. Belonging to the solar army command service uniform."
	icon_state = "under_command"
	item_state_slots = list(
		slot_l_hand_str = "under_command_held_l",
		slot_r_hand_str = "under_command_held_r",
		slot_w_uniform_str = "under_command_worn"
	)


/obj/item/clothing/under/scga/service_command/skirt
	name = "service skirt uniform, SCGA"
	desc = "A slimming brown service shirt and green skirt with beige streaks, for senior officers. Belonging to the solar army command service uniform."
	icon_state = "under_command_skirt"
	item_state_slots = list(
		slot_l_hand_str = "under_command_skirt_held_l",
		slot_r_hand_str = "under_command_skirt_held_r",
		slot_w_uniform_str = "under_command_skirt_worn"
	)


/obj/item/clothing/under/scga/dress
	name = "dress uniform, SCGA"
	desc = "A classy brown shirt and black dress pants. Part of the solar army dress uniform."
	icon_state = "under_dress"
	item_state_slots = list(
		slot_l_hand_str = "under_dress_held_l",
		slot_r_hand_str = "under_dress_held_r",
		slot_w_uniform_str = "under_dress_worn"
	)


/obj/item/clothing/under/scga/dress/skirt
	name = "dress skirt uniform, SCGA"
	desc = "A classy brown shirt and black dress skirt. Part of the solar army dress uniform."
	icon_state = "under_dress_skirt"
	item_state_slots = list(
		slot_l_hand_str = "under_dress_skirt_held_l",
		slot_r_hand_str = "under_dress_skirt_held_r",
		slot_w_uniform_str = "under_dress_skirt_worn"
	)

/obj/item/clothing/under/scga/dress_command
	name = "dress uniform, SCGA"
	desc = "A classy brown shirt and black dress pants with gold streaks, for senior officers. Part of the solar army command dress uniform."
	icon_state = "under_dress_command"
	item_state_slots = list(
		slot_l_hand_str = "under_dress_command_held_l",
		slot_r_hand_str = "under_dress_command_held_r",
		slot_w_uniform_str = "under_dress_command_worn"
	)

/obj/item/clothing/under/scga/dress_command/skirt
	name = "dress skirt uniform, SCGA"
	desc = "A classy brown shirt and black dress skirt with gold streaks, for senior officers. Part of the solar army command dress uniform."
	icon_state = "under_dress_command_skirt"
	item_state_slots = list(
		slot_l_hand_str = "under_dress_command_skirt_held_l",
		slot_r_hand_str = "under_dress_command_skirt_held_r",
		slot_w_uniform_str = "under_dress_command_skirt_worn"
	)


//Over Clothing
/obj/item/clothing/suit/scga
	abstract_type = /obj/item/clothing/suit/scga
	name = "base jacket, SCGA"
	desc = "You should not see this."
	icon = 'packs/factions/scga/clothing.dmi'
	item_icons = list(
		slot_wear_suit_str = 'packs/factions/scga/clothing.dmi'
	)
	valid_accessory_slots = list(
		ACCESSORY_SLOT_RANK,
		ACCESSORY_SLOT_INSIGNIA,
		ACCESSORY_SLOT_MEDAL
	)
	allowed = list()


/obj/item/clothing/suit/scga/hooded/wintercoat
	name = "utility wintercoat, SCGA"
	desc = "A comfortable winter-coat in green. Part of the solar army utility uniform."
	icon_state = "suit_wintercoat"
	item_state_slots = list(
		slot_l_hand_str = "suit_wintercoat_held_l",
		slot_r_hand_str = "suit_wintercoat_held_r",
		slot_wear_suit_str = "suit_wintercoat_worn"
	)
	accessories = list(
		/obj/item/clothing/accessory/storage/pockets,
		/obj/item/clothing/accessory/scga_badge/enlisted
	)


/obj/item/clothing/suit/scga/service
	name = "service jacket, SCGA"
	desc = "A rugged green service over-jacket. Part of the solar army service uniform for enlisted."
	icon_state = "suit_service"
	item_state_slots = list(
		slot_l_hand_str = "suit_service_held_l",
		slot_r_hand_str = "suit_service_held_r",
		slot_wear_suit_str = "suit_service_worn"
	)
	accessories = list(
		/obj/item/clothing/accessory/storage/pockets,
		/obj/item/clothing/accessory/scga_badge/enlisted
	)


/obj/item/clothing/suit/scga/service_officer
	name = "service jacket, SCGA"
	desc = "A rugged green service over-jacket. Part of the solar army service uniform for officers."
	icon_state = "suit_service_officer"
	item_state_slots = list(
		slot_l_hand_str = "suit_service_officer_held_l",
		slot_r_hand_str = "suit_service_officer_held_r",
		slot_wear_suit_str = "suit_service_officer_worn"
	)
	accessories = list(
		/obj/item/clothing/accessory/storage/pockets,
		/obj/item/clothing/accessory/scga_badge/officer
	)


/obj/item/clothing/suit/scga/dress
	name = "dress jacket, SCGA"
	desc = "A strapping dress jacket. Part of the solar army dress uniform."
	icon_state = "suit_dress"
	item_state_slots = list(
		slot_l_hand_str = "suit_dress_held_l",
		slot_r_hand_str = "suit_dress_held_r",
		slot_wear_suit_str = "suit_dress_worn"
	)


/obj/item/clothing/suit/scga/dress_command
	name = "dress jacket, SCGA"
	desc = "A strapping dress jacket. Part of the solar army dress uniform for senior officers."
	icon_state = "suit_dress_command"
	item_state_slots = list(
		slot_l_hand_str = "suit_dress_command_held_l",
		slot_r_hand_str = "suit_dress_command_held_r",
		slot_wear_suit_str = "suit_dress_command_worn"
	)


//Gloves
/obj/item/clothing/gloves/scga
	abstract_type = /obj/item/clothing/gloves/scga
	name = "base gloves, SCGA"
	desc = "You should not see this."
	icon = 'packs/factions/scga/clothing.dmi'
	item_icons = list(
		slot_gloves_str = 'packs/factions/scga/clothing.dmi'
	)
	sprite_sheets = list()


/obj/item/clothing/gloves/scga/duty
	name = "duty gloves, SCGA"
	desc = "Tough, brown duty gloves for the solar army personnel. Complete with reinforced knuckle-guards."
	icon_state = "gloves_utility"
	item_state_slots = list(
		slot_l_hand_str = "gloves_utility_held_l",
		slot_r_hand_str = "gloves_utility_held_r",
		slot_gloves_str = "gloves_utility_worn"
	)


//Shoes
/obj/item/clothing/shoes/scga
	abstract_type = /obj/item/clothing/shoes/scga
	name = "base shoes, SCGA"
	desc = "You should not see this."
	icon = 'packs/factions/scga/clothing.dmi'
	item_icons = list(
		slot_shoes_str = 'packs/factions/scga/clothing.dmi'
	)
	sprite_sheets = list()


/obj/item/clothing/shoes/scga/utility
	name = "duty boots, SCGA"
	desc = "Hardy, strong soled boots in jungle-beige camouflage configuration. Part of the solar army uniform."
	icon_state = "boots_utility"
	item_state_slots = list(
		slot_l_hand_str = "boots_utility_held_l",
		slot_r_hand_str = "boots_utility_held_r",
		slot_shoes_str = "boots_utility_worn"
	)
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_MINOR
		)
	siemens_coefficient = 0.7


/obj/item/clothing/shoes/scga/utility/tan
	name = "tan duty boots, SCGA"
	desc = "Hardy, strong soled boots in dusty-tan camouflage configuration. Part of the solar army uniform."
	icon_state = "boots_utility_tan"
	item_state_slots = list(
		slot_l_hand_str = "boots_utility_tan_held_l",
		slot_r_hand_str = "boots_utility_tan_held_r",
		slot_shoes_str = "boots_utility_tan_worn"
	)


/obj/item/clothing/shoes/scga/dress
	name = "dress shoes, SCGA"
	desc = "Flat, shiny dress shoes belonging to the solar army service and dress uniforms."
	icon_state = "shoes_dress"
	item_state_slots = list(
		slot_l_hand_str = "shoes_dress_held_l",
		slot_r_hand_str = "shoes_dress_held_r",
		slot_shoes_str = "shoes_dress_worn"
	)


//Hats
/obj/item/clothing/head/scga
	abstract_type = /obj/item/clothing/head/scga
	name = "base hat, SCGA"
	desc = "You should not see this."
	icon = 'packs/factions/scga/clothing.dmi'
	item_icons = list(
		slot_head_str = 'packs/factions/scga/clothing.dmi'
	)
	sprite_sheets = list()


/obj/item/clothing/head/scga/beret
	name = "tan beret, SCGA"
	desc = "A tan beret denoting service in the SCG Army Diplomatic Security Group. Part of the solar army utility and service uniform."
	icon_state = "hat_beret"
	item_state_slots = list(
		slot_l_hand_str = "hat_beret_held_l",
		slot_r_hand_str = "hat_beret_held_r",
		slot_head_str = "hat_beret_worn"
	)


/obj/item/clothing/head/scga/utility
	name = "utility cover, SCGA"
	desc = "A stern, green utility cover. Part of the solar army utility uniform."
	icon_state = "hat_utility"
	item_state_slots = list(
		slot_l_hand_str = "hat_utility_held_l",
		slot_r_hand_str = "hat_utility_held_r",
		slot_head_str = "hat_utility_worn"
	)


/obj/item/clothing/head/scga/utility/tan
	name = "tan utility cover, SCGA"
	desc = "A stern, tan utility cover. Part of the solar army utility uniform."
	icon_state = "hat_utility_tan"
	item_state_slots = list(
		slot_l_hand_str = "hat_utility_tan_held_l",
		slot_r_hand_str = "hat_utility_tan_held_r",
		slot_head_str = "hat_utility_tan_worn"
	)


/obj/item/clothing/head/scga/utility/urban
	name = "urban utility cover, SCGA"
	desc = "A stern, urban utility cover. Part of the solar army utility uniform."
	icon_state = "hat_utility_urban"
	item_state_slots = list(
		slot_l_hand_str = "hat_utility_urban_held_l",
		slot_r_hand_str = "hat_utility_urban_held_r",
		slot_head_str = "hat_utility_urban_worn"
	)


/obj/item/clothing/head/scga/utility/ushanka
	name = "ushanka hat, SCGA"
	desc = "A comfy, padded ushanka hat. Part of the solar army utility uniform."
	icon_state = "hat_ushanka"
	item_state_slots = list(
		slot_l_hand_str = "hat_ushanka_held_l",
		slot_r_hand_str = "hat_ushanka_held_r",
		slot_head_str = "hat_ushanka_worn"
	)


/obj/item/clothing/head/scga/utility/ushanka/green
	name = "ushanka hat, SCGA"
	desc = "A comfy, padded ushanka hat in green. Part of the solar army utility uniform."
	icon_state = "hat_ushanka_green"
	item_state_slots = list(
		slot_l_hand_str = "hat_ushanka_green_held_l",
		slot_r_hand_str = "hat_ushanka_green_held_r",
		slot_head_str = "hat_ushanka_green_worn"
	)


/obj/item/clothing/head/scga/utility/drill
	name = "drill hat, SCGA"
	desc = "A firm, green drill hat for non-commissioned officers. Part of the solar army utility and service uniform."
	icon_state = "hat_drill"
	item_state_slots = list(
		slot_l_hand_str = "hat_drill_held_l",
		slot_r_hand_str = "hat_drill_held_r",
		slot_head_str = "hat_drill_worn"
	)


/obj/item/clothing/head/scga/service/garrison
	name = "garrison cap, SCGA"
	desc = "A peaked garrison cap for enlisted. Part of the solar army service uniform."
	icon_state = "hat_garrison"
	item_state_slots = list(
		slot_l_hand_str = "hat_garrison_held_l",
		slot_r_hand_str = "hat_garrison_held_r",
		slot_head_str = "hat_garrison_worn"
	)


/obj/item/clothing/head/scga/service/garrison_officer
	name = "garrison cap, SCGA"
	desc = "A peaked garrison cap for officers. Part of the solar army service uniform."
	icon_state = "hat_garrison_officer"
	item_state_slots = list(
		slot_l_hand_str = "hat_garrison_officer_held_l",
		slot_r_hand_str = "hat_garrison_officer_held_r",
		slot_head_str = "hat_garrison_officer_worn"
	)


/obj/item/clothing/head/scga/service/wheel
	name = "service wheel cover, SCGA"
	desc = "A rounded wheel cover for officers. Part of the solar army service uniform."
	icon_state = "hat_wheel"
	item_state_slots = list(
		slot_l_hand_str = "hat_wheel_held_l",
		slot_r_hand_str = "hat_wheel_held_r",
		slot_head_str = "hat_wheel_worn"
	)


/obj/item/clothing/head/scga/service/wheel_command
	name = "service wheel cover, SCGA"
	desc = "A rounded wheel cover for senior officers. Part of the solar army service uniform."
	icon_state = "hat_wheel_command"
	item_state_slots = list(
		slot_l_hand_str = "hat_wheel_command_held_l",
		slot_r_hand_str = "hat_wheel_command_held_r",
		slot_head_str = "hat_wheel_command_worn"
	)


/obj/item/clothing/head/scga/dress/garrison
	name = "dress garrison cap, SCGA"
	desc = "A white, peaked garrison cap for enlisted. Part of the solar army dress uniform."
	icon_state = "hat_dress_garrison"
	item_state_slots = list(
		slot_l_hand_str = "hat_dress_garrison_held_l",
		slot_r_hand_str = "hat_dress_garrison_held_r",
		slot_head_str = "hat_dress_garrison_worn"
	)


/obj/item/clothing/head/scga/dress/wheel
	name = "dress wheel cover, SCGA"
	desc = "A white, rounded wheel cover for officers. Part of the solar army dress uniform."
	icon_state = "hat_dress_wheel"
	item_state_slots = list(
		slot_l_hand_str = "hat_dress_wheel_held_l",
		slot_r_hand_str = "hat_dress_wheel_held_r",
		slot_head_str = "hat_dress_wheel_worn"
	)


/obj/item/clothing/head/scga/dress/wheel_command
	name = "dress wheel cover, SCGA"
	desc = "A white, rounded wheel cover for senior officers. Part of the solar army dress uniform."
	icon_state = "hat_dress_wheel_command"
	item_state_slots = list(
		slot_l_hand_str = "hat_dress_wheel_command_held_l",
		slot_r_hand_str = "hat_dress_wheel_command_held_r",
		slot_head_str = "hat_dress_wheel_command_worn"
	)
