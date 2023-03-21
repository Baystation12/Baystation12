/singleton/item_modifier/space_suit
	name = "Standard"
	type_setups = list(
		/obj/item/clothing/head/helmet/space = list(
			SETUP_NAME = "voidsuit helmet",
			SETUP_OBJ_SHEET = 'icons/obj/clothing/obj_head.dmi',
			SETUP_ONMOB_SHEET = list(slot_wear_suit_str = 'icons/mob/onmob/onmob_head.dmi'),
			SETUP_ICON_STATE = "void",
			SETUP_SPECIES_OBJ = list(
				SPECIES_HUMAN = 'icons/obj/clothing/obj_head.dmi',
				SPECIES_UNATHI = 'icons/obj/clothing/species/unathi/obj_head_unathi.dmi',
				SPECIES_SKRELL = 'icons/obj/clothing/species/skrell/obj_head_skrell.dmi'
				),
			SETUP_SPECIES_ONMOB = list(
				SPECIES_HUMAN = 'icons/mob/onmob/onmob_head.dmi',
				SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_head_unathi.dmi',
				SPECIES_SKRELL = 'icons/mob/species/skrell/onmob_head_skrell.dmi'
				)
		),
		/obj/item/clothing/suit/space/void = list(
			SETUP_NAME = "voidsuit",
			SETUP_OBJ_SHEET = 'icons/obj/clothing/obj_suit.dmi',
			SETUP_ONMOB_SHEET = list(slot_wear_suit_str = 'icons/mob/onmob/onmob_suit.dmi'),
			SETUP_ICON_STATE = "void",
			SETUP_SPECIES_OBJ = list(
				SPECIES_HUMAN = 'icons/obj/clothing/obj_suit.dmi',
				SPECIES_UNATHI = 'icons/obj/clothing/species/unathi/obj_suit_unathi.dmi',
				SPECIES_SKRELL = 'icons/obj/clothing/species/skrell/obj_suit_skrell.dmi'
				),
			SETUP_SPECIES_ONMOB = list(
				SPECIES_HUMAN = 'icons/mob/onmob/onmob_suit.dmi',
				SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_suit_unathi.dmi',
				SPECIES_SKRELL = 'icons/mob/onmob/onmob_suit.dmi'
				)
		)
	)


/singleton/item_modifier/space_suit/engineering
	name = "Engineering"

/singleton/item_modifier/space_suit/engineering/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_NAME] = "engineering voidsuit helmet"
	helmet_setup[SETUP_ICON_STATE] = "rig0-engineering"
	helmet_setup[SETUP_ITEM_STATE] = "eng_helm"

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_NAME] = "engineering voidsuit"
	suit_setup[SETUP_ICON_STATE] = "rig-engineering"
	suit_setup[SETUP_ITEM_STATE_SLOTS] = list(
			slot_l_hand_str = "eng_voidsuit",
			slot_r_hand_str = "eng_voidsuit"
		)


/singleton/item_modifier/space_suit/mining
	name = "Mining"

/singleton/item_modifier/space_suit/mining/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_NAME] = "mining voidsuit helmet"
	helmet_setup[SETUP_ICON_STATE] = "rig0-mining"
	helmet_setup[SETUP_ITEM_STATE] = "mining_helm"

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_NAME] = "mining voidsuit"
	suit_setup[SETUP_ICON_STATE] = "rig-mining"
	suit_setup[SETUP_ITEM_STATE_SLOTS] = list(
			slot_l_hand_str = "mining_voidsuit",
			slot_r_hand_str = "mining_voidsuit"
		)


/singleton/item_modifier/space_suit/salvage
	name = "Salvage"

/singleton/item_modifier/space_suit/salvage/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_NAME] = "salvage voidsuit helmet"
	helmet_setup[SETUP_ICON_STATE] = "rig0-salvage"
	helmet_setup[SETUP_ITEM_STATE] = "salvage_helm"

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_NAME] = "salvage voidsuit"
	suit_setup[SETUP_ICON_STATE] = "rig-salvage"


/singleton/item_modifier/space_suit/science
	name = "Science"

/singleton/item_modifier/space_suit/science/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_NAME] = "excavation voidsuit helmet"
	helmet_setup[SETUP_ICON_STATE] = "rig0-excavation"
	helmet_setup[SETUP_ITEM_STATE] = "excavation-helm"

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_NAME] = "excavation voidsuit"
	suit_setup[SETUP_ICON_STATE] = "rig-excavation"
	suit_setup[SETUP_ITEM_STATE_SLOTS] = list(
			slot_l_hand_str = "excavation_voidsuit",
			slot_r_hand_str = "excavation_voidsuit"
		)


/singleton/item_modifier/space_suit/medical
	name = "Medical"

/singleton/item_modifier/space_suit/medical/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_NAME] = "medical voidsuit helmet"
	helmet_setup[SETUP_ICON_STATE] = "rig0-medical"
	helmet_setup[SETUP_ITEM_STATE] = "medical_helm"

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_NAME] = "medical voidsuit"
	suit_setup[SETUP_ICON_STATE] = "rig-medical"
	suit_setup[SETUP_ITEM_STATE_SLOTS] = list(
			slot_l_hand_str = "medical_voidsuit",
			slot_r_hand_str = "medical_voidsuit"
		)


/singleton/item_modifier/space_suit/security
	name = "Security"

/singleton/item_modifier/space_suit/security/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_NAME] = "security voidsuit helmet"
	helmet_setup[SETUP_ICON_STATE] = "rig0-sec"
	helmet_setup[SETUP_ITEM_STATE] = "sec_helm"

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_NAME] = "security voidsuit"
	suit_setup[SETUP_ICON_STATE] = "rig-sec"
	suit_setup[SETUP_ITEM_STATE_SLOTS] = list(
			slot_l_hand_str = "sec_voidsuit",
			slot_r_hand_str = "sec_voidsuit"
		)


/singleton/item_modifier/space_suit/security/alt
	name = "Security, Alt"

/singleton/item_modifier/space_suit/security/alt/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_NAME] = "security voidsuit helmet"
	helmet_setup[SETUP_ICON_STATE] = "rig0-secalt"
	helmet_setup[SETUP_ITEM_STATE] = "secalt_helm"

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_NAME] = "security voidsuit"
	suit_setup[SETUP_ICON_STATE] = "rig-secalt"


/singleton/item_modifier/space_suit/atmos
	name = "Atmos"

/singleton/item_modifier/space_suit/atmos/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_NAME] = "atmospherics voidsuit helmet"
	helmet_setup[SETUP_ICON_STATE] = "rig0-atmos"
	helmet_setup[SETUP_ITEM_STATE] = "atmos_helm"

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_NAME] = "atmospherics voidsuit"
	suit_setup[SETUP_ICON_STATE] = "rig-atmos"
	suit_setup[SETUP_ITEM_STATE_SLOTS] = list(
			slot_l_hand_str = "atmos_voidsuit",
			slot_r_hand_str = "atmos_voidsuit"
		)


/singleton/item_modifier/space_suit/mercenary
	name = "Mercenary"

/singleton/item_modifier/space_suit/mercenary/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_NAME] = "blood-red voidsuit helmet"
	helmet_setup[SETUP_ICON_STATE] = "rig0-syndie"
	helmet_setup[SETUP_ITEM_STATE] = "syndie_helm"
	helmet_setup[SETUP_SPECIES_OBJ] = list(
			SPECIES_HUMAN = 'icons/obj/clothing/obj_head.dmi',
			SPECIES_UNATHI = 'icons/obj/clothing/species/unathi/obj_head_unathi.dmi',
			SPECIES_SKRELL = 'icons/obj/clothing/species/skrell/obj_head_skrell.dmi',
			SPECIES_VOX = 'icons/obj/clothing/species/vox/obj_head_vox.dmi'
		)
	helmet_setup[SETUP_SPECIES_ONMOB] = list(
			SPECIES_HUMAN = 'icons/mob/onmob/onmob_head.dmi',
			SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_head_unathi.dmi',
			SPECIES_SKRELL = 'icons/mob/species/skrell/onmob_head_skrell.dmi',
			SPECIES_VOX = 'icons/mob/species/vox/onmob_head_vox.dmi'
		)

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_NAME] = "blood-red voidsuit"
	suit_setup[SETUP_ICON_STATE] = "rig-syndie"
	suit_setup[SETUP_ITEM_STATE_SLOTS] = list(
			slot_l_hand_str = "syndie_voidsuit",
			slot_r_hand_str = "syndie_voidsuit"
		)
	suit_setup[SETUP_SPECIES_OBJ] = list(
			SPECIES_HUMAN = 'icons/obj/clothing/obj_suit.dmi',
			SPECIES_UNATHI = 'icons/obj/clothing/species/unathi/obj_suit_unathi.dmi',
			SPECIES_SKRELL = 'icons/obj/clothing/species/skrell/obj_suit_skrell.dmi',
			SPECIES_VOX = 'icons/obj/clothing/species/vox/obj_suit_vox.dmi'
		)
	suit_setup[SETUP_SPECIES_ONMOB] = list(
			SPECIES_HUMAN = 'icons/mob/onmob/onmob_suit.dmi',
			SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_suit_unathi.dmi',
			SPECIES_SKRELL = 'icons/mob/onmob/onmob_suit.dmi',
			SPECIES_VOX = 'icons/mob/species/vox/onmob_suit_vox.dmi'
		)


/singleton/item_modifier/space_suit/mercenary/emag
	name = "^%###^%$"


/singleton/item_modifier/space_suit/pilot
	name = "Pilot"

/singleton/item_modifier/space_suit/pilot/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_NAME] = "pilot voidsuit helmet"
	helmet_setup[SETUP_ICON_STATE] = "rig0_pilot"
	helmet_setup[SETUP_ITEM_STATE] = "pilot_helm"

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_NAME] = "pilot voidsuit"
	suit_setup[SETUP_ICON_STATE] = "rig-pilot"
	suit_setup[SETUP_ITEM_STATE_SLOTS] = list(
			slot_l_hand_str = "s_suit",
			slot_r_hand_str = "s_suit"
		)


//Torch
/singleton/item_modifier/space_suit/sol
	name = "Standard, SolGov"
	type_setups = list(
		/obj/item/clothing/head/helmet/space = list(
			SETUP_NAME = "voidsuit helmet",
			SETUP_OBJ_SHEET = 'maps/torch/icons/obj/obj_head_solgov.dmi',
			SETUP_ONMOB_SHEET = list(slot_head_str = 'maps/torch/icons/mob/onmob_head_solgov.dmi'),
			SETUP_ICON_STATE = "rig_explorer",
			SETUP_ITEM_STATE = "explorer_helm",
			SETUP_SPECIES_OBJ = list(
				SPECIES_HUMAN = 'maps/torch/icons/obj/obj_head_solgov.dmi',
				SPECIES_UNATHI = 'maps/torch/icons/obj/unathi/obj_head_solgov_unathi.dmi',
				SPECIES_SKRELL = 'maps/torch/icons/obj/skrell/obj_head_solgov_skrell.dmi'
				),
			SETUP_SPECIES_ONMOB = list(
				SPECIES_HUMAN = 'maps/torch/icons/mob/onmob_head_solgov.dmi',
				SPECIES_UNATHI = 'maps/torch/icons/mob/unathi/onmob_head_spacesuits_solgov_unathi.dmi',
				SPECIES_SKRELL = 'maps/torch/icons/mob/skrell/onmob_head_solgov_skrell.dmi'
				)
		),
		/obj/item/clothing/suit/space/void = list(
			SETUP_NAME = "voidsuit",
			SETUP_OBJ_SHEET = 'maps/torch/icons/obj/obj_suit_solgov.dmi',
			SETUP_ONMOB_SHEET = list(slot_wear_suit_str = 'maps/torch/icons/mob/onmob_suit_solgov.dmi'),
			SETUP_ICON_STATE = "rig0_explorer",
			SETUP_SPECIES_OBJ = list(
				SPECIES_HUMAN = 'maps/torch/icons/obj/obj_suit_solgov.dmi',
				SPECIES_UNATHI = 'maps/torch/icons/obj/unathi/obj_suit_solgov_unathi.dmi',
				SPECIES_SKRELL = 'maps/torch/icons/obj/skrell/obj_suit_solgov_skrell.dmi'
				),
			SETUP_SPECIES_ONMOB = list(
				SPECIES_HUMAN = 'maps/torch/icons/mob/onmob_suit_solgov.dmi',
				SPECIES_UNATHI = 'maps/torch/icons/mob/unathi/onmob_suit_spacesuits_solgov_unathi.dmi',
				SPECIES_SKRELL = 'maps/torch/icons/mob/skrell/onmob_suit_solgov_skrell.dmi'
				)
		)
	)


/singleton/item_modifier/space_suit/sol/explorer
	name = "Explorer"

/singleton/item_modifier/space_suit/sol/explorer/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_NAME] = "exploration voidsuit helmet"
	helmet_setup[SETUP_ICON_STATE] = "rig0_explorer"
	helmet_setup[SETUP_ITEM_STATE] = "explorer_helm"

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_NAME] = "exploration voidsuit"
	suit_setup[SETUP_ICON_STATE] = "rig_explorer"


/singleton/item_modifier/space_suit/sol/pilot
	name = "Pilot, Alt"

/singleton/item_modifier/space_suit/sol/pilot/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_NAME] = "pilot voidsuit helmet"
	helmet_setup[SETUP_ICON_STATE] = "rig0_pilot"
	helmet_setup[SETUP_ITEM_STATE] = "pilot_helm"

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_NAME] = "pilot voidsuit"
	suit_setup[SETUP_ICON_STATE] = "rig-pilot"


/singleton/item_modifier/space_suit/sol/command
	name = "Command"

/singleton/item_modifier/space_suit/sol/command/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_NAME] = "command voidsuit helmet"
	helmet_setup[SETUP_ICON_STATE] = "rig0_command"
	helmet_setup[SETUP_ITEM_STATE] = "command_helm"

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_NAME] = "command voidsuit"
	suit_setup[SETUP_ICON_STATE] = "rig_command"


/singleton/item_modifier/space_suit/sol/medical
	name = "Medical, Alt"

/singleton/item_modifier/space_suit/sol/medical/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_NAME] = "medical voidsuit helmet"
	helmet_setup[SETUP_ICON_STATE] = "rig0-medicalalt"
	helmet_setup[SETUP_ITEM_STATE] = "medicalalt_helm"

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_NAME] = "medical voidsuit"
	suit_setup[SETUP_ICON_STATE] = "rig-medicalalt"


/singleton/item_modifier/space_suit/sol/engineering
	name = "Engineering, Alt"

/singleton/item_modifier/space_suit/sol/engineering/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_NAME] = "engineering voidsuit helmet"
	helmet_setup[SETUP_ICON_STATE] = "rig0-engineeringalt"
	helmet_setup[SETUP_ITEM_STATE] = "engalt_helm"

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_NAME] = "engineering voidsuit"
	suit_setup[SETUP_ICON_STATE] = "rig-engineeringalt"


/singleton/item_modifier/space_suit/sol/atmos
	name = "Atmos, Alt"

/singleton/item_modifier/space_suit/sol/atmos/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_NAME] = "atmospherics voidsuit helmet"
	helmet_setup[SETUP_ICON_STATE] = "rig0-atmosalt"
	helmet_setup[SETUP_ITEM_STATE] = "atmosalt_helm"

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_NAME] = "atmospherics voidsuit"
	suit_setup[SETUP_ICON_STATE] = "rig-atmosalt"


/singleton/item_modifier/space_suit/sol/hazard
	name = "Hazard"

/singleton/item_modifier/space_suit/sol/hazard/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_NAME] = "hazardous operation voidsuit helmet"
	helmet_setup[SETUP_ICON_STATE] = "rig0-haz"
	helmet_setup[SETUP_ITEM_STATE] = "haz_helm"

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_NAME] = "hazardous operation voidsuit"
	suit_setup[SETUP_ICON_STATE] = "rig-haz"
