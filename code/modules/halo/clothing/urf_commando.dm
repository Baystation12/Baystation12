
/obj/item/clothing/under/urfc_jumpsuit
	name = "URF Commando uniform"
	desc = "Standard issue URF Commando uniform, more badass than that, you die."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_state = "commando_uniform"
	item_state = "commando_uniform"
	item_flags = STOPPRESSUREDAMAGE|AIRTIGHT

/obj/item/clothing/head/helmet/urfc
	name = "URFC Rifleman Helmet"
	desc = "Somewhat expensive and hand crafted, this helmet has been clearly converted from an old spec ops grade EVA combat helmet as the foundation. Despite the old age, a lot of work has been put into adding additional armor and refining the base processes, such as an internal oxygen filter and the replacement of the visor. It's quite heavy, but a lot of soft material has been added to the inside to make the metal more comfy. Outdated, but can be expected in combat engagements to perform on par with modern equipment, due to the extensive modifications."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state = "rifleman_worn"
	icon_state = "rifleman_helmet"
	item_state_slots = list(slot_l_hand_str = "urf_helmet", slot_r_hand_str = "urf_helmet")
	item_flags = STOPPRESSUREDAMAGE|THICKMATERIAL|AIRTIGHT
	body_parts_covered = HEAD|FACE
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	flash_protection = FLASH_PROTECTION_MODERATE
	cold_protection = HEAD
	heat_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 60, bullet = 35, laser = 25,energy = 25, bomb = 25, bio = 100, rad = 25)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	on = 0
	armor_thickness = 20

/obj/item/clothing/suit/armor/special/urfc
	name = "URFC Rifleman Armour"
	desc = "Somewhat expensive and hand crafted, this armor is the pinnacle of the work force of the URF and it's many workers. Filled with pouches and storage compartments, while still keeping a scary amount of both mobility and protection. An ideal collage of the strengths of the URF, but with the added protection found only in high tier UNSC equipment. It's quite comfy, probably won't last long in space."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state = "rifleman_a_worn"
	icon_state = "rifleman_a_obj"
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	blood_overlay_type = "armor"
	item_state_slots = list(slot_l_hand_str = "urf_armour", slot_r_hand_str = "urf_armour")
	armor = list(melee = 55, bullet = 50, laser = 55, energy = 45, bomb = 60, bio = 100, rad = 25)
	item_flags = THICKMATERIAL
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | FEET
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	heat_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	armor_thickness = 20

/obj/item/clothing/shoes/magboots/urfc
	name = "URFC Magboots"
	desc = "Experimental black magnetic boots, used to ensure the user is safely attached to any surfaces during extra-vehicular operations. They're large enough to be worn over other footwear."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_state = "magboots_obj0"
	icon_base = "magboots_obj"
	item_state = "magboots"
	can_hold_knife = 1
	force = 5
