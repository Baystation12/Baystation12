/decl/item_modifier/space_suit/engineering
	name = "Engineering"
	type_setups = list(
		/obj/item/clothing/head/helmet/space = list(
			SETUP_NAME = "engineering voidsuit helmet",
			SETUP_ICON_STATE = "rig0-engineering",
			SETUP_ITEM_STATE = "eng_helm"
		),
		/obj/item/clothing/suit/space/void = list(
			SETUP_NAME = "engineering voidsuit",
			SETUP_ICON_STATE = "rig-engineering",
			SETUP_ITEM_STATE_SLOTS = list(
				slot_l_hand_str = "eng_voidsuit",
				slot_r_hand_str = "eng_voidsuit"
			)
		)
	)

/decl/item_modifier/space_suit/engineering/alt
	name = "Engineering, Alt"

/decl/item_modifier/space_suit/engineering/alt/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_ICON_STATE] = "rig0-engineeringalt"
	helmet_setup[SETUP_ITEM_STATE] = "engalt_helm"

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_ICON_STATE] = "rig-engineeringalt"

/decl/item_modifier/space_suit/mining
	name = "Mining"
	type_setups = list(
		/obj/item/clothing/head/helmet/space = list(
			SETUP_NAME = "mining voidsuit helmet",
			SETUP_ICON_STATE = "rig0-mining",
			SETUP_ITEM_STATE = "mining_helm"
		),
		/obj/item/clothing/suit/space/void = list(
			SETUP_NAME = "mining voidsuit",
			SETUP_ICON_STATE = "rig-mining",
			SETUP_ITEM_STATE_SLOTS = list(
				slot_l_hand_str = "mining_voidsuit",
				slot_r_hand_str = "mining_voidsuit"
			)
		)
	)
/decl/item_modifier/space_suit/salvage
	name = "Salvage"
	type_setups = list(
		/obj/item/clothing/head/helmet/space = list(
			SETUP_NAME = "salvage voidsuit helmet",
			SETUP_ICON_STATE = "rig0-salvage",
			SETUP_ITEM_STATE = "salvage_helm"
		),
		/obj/item/clothing/suit/space/void = list(
			SETUP_NAME = "salvage voidsuit",
			SETUP_ICON_STATE = "rig-salvage"
		)
	)



/decl/item_modifier/space_suit/science
	name = "Science"
	type_setups = list(
		/obj/item/clothing/head/helmet/space = list(
			SETUP_NAME = "excavation voidsuit helmet",
			SETUP_ICON_STATE = "rig0-excavation",
			SETUP_ITEM_STATE = "excavation-helm"
		),
		/obj/item/clothing/suit/space/void = list(
			SETUP_NAME = "excavation voidsuit",
			SETUP_ICON_STATE = "rig-excavation",
			SETUP_ITEM_STATE_SLOTS = list(
				slot_l_hand_str = "excavation_voidsuit",
				slot_r_hand_str = "excavation_voidsuit"
			)
		)
	)

/decl/item_modifier/space_suit/medical
	name = "Medical"
	type_setups = list(
		/obj/item/clothing/head/helmet/space = list(
			SETUP_NAME = "medical voidsuit helmet",
			SETUP_ICON_STATE = "rig0-medical",
			SETUP_ITEM_STATE = "medical_helm"
		),
		/obj/item/clothing/suit/space/void = list(
			SETUP_NAME = "medical voidsuit",
			SETUP_ICON_STATE = "rig-medical",
			SETUP_ITEM_STATE_SLOTS = list(
				slot_l_hand_str = "medical_voidsuit",
				slot_r_hand_str = "medical_voidsuit"
			)
		)
	)

/decl/item_modifier/space_suit/medical/alt
	name = "Medical, Alt"

/decl/item_modifier/space_suit/medical/alt/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_ICON_STATE] = "rig0-medicalalt"
	helmet_setup[SETUP_ITEM_STATE] = "medicalalt_helm"

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_ICON_STATE] = "rig-medicalalt"

/decl/item_modifier/space_suit/security
	name = "Security"
	type_setups = list(
		/obj/item/clothing/head/helmet/space = list(
			SETUP_NAME = "security voidsuit helmet",
			SETUP_ICON_STATE = "rig0-sec",
			SETUP_ITEM_STATE = "sec_helm"
		),
		/obj/item/clothing/suit/space/void = list(
			SETUP_NAME = "security voidsuit",
			SETUP_ICON_STATE = "rig-sec",
			SETUP_ITEM_STATE_SLOTS = list(
				slot_l_hand_str = "sec_voidsuit",
				slot_r_hand_str = "sec_voidsuit"
			)
		)
	)

/decl/item_modifier/space_suit/security/alt
	name = "Security, Alt"

/decl/item_modifier/space_suit/security/alt/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_ICON_STATE] = "rig0-secalt"
	helmet_setup[SETUP_ITEM_STATE] = "secalt_helm"

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_ICON_STATE] = "rig-secalt"

/decl/item_modifier/space_suit/atmos
	name = "Atmos"
	type_setups = list(
		/obj/item/clothing/head/helmet/space = list(
			SETUP_NAME = "atmospherics voidsuit helmet",
			SETUP_ICON_STATE = "rig0-atmos",
			SETUP_ITEM_STATE = "atmos_helm"
		),
		/obj/item/clothing/suit/space/void = list(
			SETUP_NAME = "atmospherics voidsuit",
			SETUP_ICON_STATE = "rig-atmos",
			SETUP_ITEM_STATE_SLOTS = list(
				slot_l_hand_str = "atmos_voidsuit",
				slot_r_hand_str = "atmos_voidsuit"
			)
		)
	)

/decl/item_modifier/space_suit/atmos/alt
	name = "Atmos, Alt"

/decl/item_modifier/space_suit/atmos/alt/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_ICON_STATE] = "rig0-atmosalt"
	helmet_setup[SETUP_ITEM_STATE] = "atmosalt_helm"

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_ICON_STATE] = "rig-atmosalt"

/decl/item_modifier/space_suit/explorer
	name = "Explorer"
	type_setups = list(
		/obj/item/clothing/head/helmet/space = list(
			SETUP_NAME = "exploration voidsuit helmet",
			SETUP_ICON_STATE = "rig0_explorer",
			SETUP_ITEM_STATE = "explorer_helm"
		),
		/obj/item/clothing/suit/space/void = list(
			SETUP_NAME = "exploration voidsuit",
			SETUP_ICON_STATE = "rig_explorer",
			SETUP_ITEM_STATE_SLOTS = list(
				slot_l_hand_str = "s_suit",
				slot_r_hand_str = "s_suit"
			)
		)
	)

/decl/item_modifier/space_suit/mercenary
	name = "Mercenary"
	type_setups = list(
		/obj/item/clothing/head/helmet/space = list(
			SETUP_NAME = "blood-red voidsuit helmet",
			SETUP_ICON_STATE = "rig0-syndie",
			SETUP_ITEM_STATE = "syndie_helm"
		),
		/obj/item/clothing/suit/space/void = list(
			SETUP_NAME = "blood-red voidsuit",
			SETUP_ICON_STATE = "rig-syndie",
			SETUP_ITEM_STATE_SLOTS = list(
				slot_l_hand_str = "syndie_voidsuit",
				slot_r_hand_str = "syndie_voidsuit"
			)
		)
	)

/decl/item_modifier/space_suit/mercenary/emag
	name = "^%###^%$"

/decl/item_modifier/space_suit/pilot
	name = "Pilot"
	type_setups = list(
		/obj/item/clothing/head/helmet/space = list(
			SETUP_NAME = "pilot voidsuit helmet",
			SETUP_ICON_STATE = "rig0_pilot",
			SETUP_ITEM_STATE = "pilot_helm"
		),
		/obj/item/clothing/suit/space/void = list(
			SETUP_NAME = "pilot voidsuit",
			SETUP_ICON_STATE = "rig-pilot",
			SETUP_ITEM_STATE_SLOTS = list(
				slot_l_hand_str = "s_suit",
				slot_r_hand_str = "s_suit"
			)
		)
	)

/decl/item_modifier/space_suit/hazard
	name = "Hazard"
	type_setups = list(
		/obj/item/clothing/head/helmet/space = list(
			SETUP_NAME = "hazardous operation voidsuit helmet",
			SETUP_ICON_STATE = "rig0-haz",
			SETUP_ITEM_STATE = "haz_helm"
		),
		/obj/item/clothing/suit/space/void = list(
			SETUP_NAME = "hazardous operation voidsuit",
			SETUP_ICON_STATE = "rig-haz",
			SETUP_ITEM_STATE_SLOTS = list(
				slot_l_hand_str = "eng_voidsuit",
				slot_r_hand_str = "eng_voidsuit"
			)
		)
	)

/decl/item_modifier/space_suit/command
	name = "Command"
	type_setups = list(
		/obj/item/clothing/head/helmet/space = list(
			SETUP_NAME = "command voidsuit helmet",
			SETUP_ICON_STATE = "rig0_command",
			SETUP_ITEM_STATE = "command_helm"
		),
		/obj/item/clothing/suit/space/void = list(
			SETUP_NAME = "command voidsuit",
			SETUP_ICON_STATE = "rig_command",
			SETUP_ITEM_STATE_SLOTS = list(
				slot_l_hand_str = "s_suit",
				slot_r_hand_str = "s_suit"
			)
		)
	)
