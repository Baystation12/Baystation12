#define ITEM_HAND 'code/modules/halo/clothing/head.dmi'
#define URF_OVERRIDE 'code/modules/halo/clothing/urf_commando.dmi'

//SUIT

/obj/item/clothing/under/urfc_jumpsuit
	name = "SOE Commando uniform"
	desc = "Standard issue SOE Commando uniform, more badass than that, you die."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_state = "commando_uniform"
	item_state = "commando_uniform"
	worn_state = "commando_uniform"
	item_state_slots = list(slot_l_hand_str = "commando_uniform", slot_r_hand_str = "commando_uniform")

//HELMET

/obj/item/clothing/head/helmet/urfc
	name = "SOE Rifleman Helmet"
	desc = "A simple helmet. Despite the old age, a lot of work has been put into adding additional armor and refining the base processes. It's quite heavy, but a lot of soft material has been added to the inside to make the metal more comfy. Outdated, but can be expected in combat engagements to perform on par with modern equipment, due to the extensive modifications."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state = "rifleman_worn"
	icon_state = "rifleman_helmet"
	item_state_slots = list(slot_l_hand_str = "urf_helmet", slot_r_hand_str = "urf_helmet")
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	flags_inv = HIDEEARS
	unacidable = 1
	armor = list(melee = 55, bullet = 35, laser = 25,energy = 25, bomb = 20, bio = 25, rad = 25)
	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	integrated_hud = /obj/item/clothing/glasses/hud/tactical/innie

/obj/item/clothing/head/helmet/urfccommander
	name = "SOE Commander Hat"
	desc = "A commander hat. Weirdly made of some kind of bulletproof material."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state = "commander_worn"
	icon_state = "commander_helmet"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor = list(melee = 55, bullet = 35, laser = 25,energy = 25, bomb = 20, bio = 25, rad = 25)
	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	integrated_hud = /obj/item/clothing/glasses/hud/tactical/innie

/obj/item/clothing/head/helmet/soe
	name = "SOE Space Helmet"
	desc = "Non-Standard issue short-EVA capable helmet issued to commandos."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state = "soe_worn"
	icon_state = "soe_helmet"
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	item_flags = STOPPRESSUREDAMAGE|THICKMATERIAL|AIRTIGHT
	body_parts_covered = HEAD|FACE
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	flash_protection = FLASH_PROTECTION_MODERATE
	cold_protection = HEAD | FACE
	heat_protection = HEAD | FACE
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 55, bullet = 35, laser = 25,energy = 25, bomb = 20, bio = 25, rad = 25)
	item_state_slots = list(slot_l_hand_str = "urf_helmet", slot_r_hand_str = "urf_helmet")
	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	on = 0
	armor_thickness = 20

	integrated_hud = /obj/item/clothing/glasses/hud/tactical/innie


//ARMOR

/obj/item/clothing/suit/armor/special/urfc
	name = "SOE Rifleman Armour"
	desc = "A bulletproof vest. Filled with pouches and storage compartments, while still keeping a scary amount of both mobility and protection. An ideal collage of the strengths of the URF, but with the added protection found only in high tier UNSC equipment. It's quite comfy, probably won't last long in space."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state = "rifleman_a_worn"
	icon_state = "rifleman_a_obj"
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	blood_overlay_type = "armor"
	item_state_slots = list(slot_l_hand_str = "urf_armour", slot_r_hand_str = "urf_armour")
	armor = list(melee = 55, bullet = 50, laser = 55, energy = 45, bomb = 40, bio = 25, rad = 25)
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | ARMS
	armor_thickness = 20
	item_flags = THICKMATERIAL
	unacidable = 1
	var/slots = 4
	var/max_w_class = ITEM_SIZE_SMALL

/obj/item/clothing/suit/armor/special/soe
	name = "SOE Spacesuit"
	desc = "Heavyweight, somewhat durable armour issued to commandos for increased survivability in space."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state = "soe_spacesuit_worn"
	icon_state = "soe_spacesuit"
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	blood_overlay_type = "armor"
	armor = list(melee = 55, bullet = 50, laser = 55, energy = 45, bomb = 40, bio = 25, rad = 25)
	item_flags = STOPPRESSUREDAMAGE|THICKMATERIAL
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | ARMS | LEGS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	heat_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	item_state_slots = list(slot_l_hand_str = "urf_armor", slot_r_hand_str = "urf_armor")
	armor_thickness = 20
	slowdown_general = 1

//SHOES

/obj/item/clothing/shoes/magboots/urfc
	name = "SOE Magboots"
	desc = "Experimental black magnetic boots, used to ensure the user is safely attached to any surfaces during extra-vehicular operations. They're large enough to be worn over other footwear."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_state = "magboots_obj0"
	icon_base = "magboots_obj"
	item_state = "magboots"
	can_hold_knife = 1
	force = 5

//GLOVES

/obj/item/clothing/gloves/soegloves/urfc
	name = "SOE Gloves"
	desc = "These  gloves are somewhat fire and impact-resistant."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state = "merc_gloves_worn"
	icon_state = "merc_gloves"
	force = 5
	armor = list(melee = 80, bullet = 60, laser = 60,energy = 25, bomb = 50, bio = 10, rad = 0)

//BACKPACKS

/obj/item/weapon/storage/backpack/cmdo
	icon = 'code/modules/halo/clothing/commandopack.dmi'
	name = "Commando Rifleman Backpack"
	icon_override = 'code/modules/halo/clothing/commandopack.dmi'

	icon_state = "c_packO_rif"
	item_state = "c_pack_rif_worn"

	item_state_slots = list(
	slot_l_hand_str = "c_pack_rif",
	slot_r_hand_str = "c_pack_rif",
	)

/obj/item/weapon/storage/backpack/cmdo/cqc
	name = "Commando CQC Backpack"

	icon_state = "c_packO_cqc"
	item_state = "c_pack_cqc_worn"

	item_state_slots = list(
	slot_l_hand_str = "c_pack_cqc",
	slot_r_hand_str = "c_pack_cqc",
	)

/obj/item/weapon/storage/backpack/cmdo/eng
	name = "Commando Engineer Backpack"

	icon_state = "c_packO_eng"
	item_state = "c_pack_eng_worn"

	item_state_slots = list(
	slot_l_hand_str = "c_pack_eng",
	slot_r_hand_str = "c_pack_eng",
	)

/obj/item/weapon/storage/backpack/cmdo/med
	name = "Commando Medic Backpack"

	icon_state = "c_packO_med"
	item_state = "c_pack_med_worn"

	item_state_slots = list(
	slot_l_hand_str = "c_pack_med",
	slot_r_hand_str = "c_pack_med",
	)


//JETPACK

/obj/item/weapon/tank/jetpack/void/urfc
	name = "SOE Jetpack (oxygen)"
	desc = "It works well in a void."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_state = "soe_tank_obj"
	item_state =  "soe_tank"

//MASK

/obj/item/clothing/mask/gas/soebalaclava
	name = "SOE Balaclava"
	desc = "Designed to both hide identities and keep your face comfy and warm, a mask that can be connected to an air supply. Filters harmful gases from the air."
	icon = ITEM_HAND
	icon_override = URF_OVERRIDE
	icon_state = "merc_balaclava"
	item_state = "merc_balaclava"
	flags_inv = HIDEFACE|BLOCKHAIR
	body_parts_covered = FACE
	item_flags = AIRTIGHT|FLEXIBLEMATERIAL
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	siemens_coefficient = 0.9
	w_class = ITEM_SIZE_SMALL

#undef URF_OVERRIDE
#undef ITEM_HAND
