#define SETUP_NAME "name"
#define SETUP_OBJ_SHEET "icon"
#define SETUP_ONMOB_SHEET "item_icons"
#define SETUP_ICON_STATE "icon_state"
#define SETUP_ITEM_STATE "item_state"
#define SETUP_ITEM_STATE_SLOTS "item_state_slots"
#define SETUP_SPECIES_OBJ "sprite_sheets_obj"
#define SETUP_SPECIES_ONMOB "sprite_sheets"


/singleton/item_modifier/space_suit/sierra
	name = "Standard, NT"
	type_setups = list(
		/obj/item/clothing/head/helmet/space = list(
			SETUP_NAME = "voidsuit helmet",
			SETUP_OBJ_SHEET = 'icons/obj/clothing/obj_head.dmi',
			SETUP_ONMOB_SHEET = list(slot_wear_suit_str = 'icons/mob/onmob/onmob_head.dmi'),
			SETUP_ICON_STATE = "void",
			SETUP_SPECIES_OBJ = list(
				SPECIES_HUMAN = 'icons/obj/clothing/obj_head.dmi',
				SPECIES_UNATHI = 'packs/infinity/icons/obj/clothing/species/erosan/hats.dmi',
				SPECIES_RESOMI = 'packs/infinity/icons/obj/clothing/species/resomi/obj_head_resomi.dmi',
				SPECIES_TAJARA = 'mods/tajara/icons/sprite_sheets/obj/hats.dmi',
				SPECIES_SKRELL = 'icons/obj/clothing/species/skrell/obj_head_skrell.dmi'
				),
			SETUP_SPECIES_ONMOB = list(
				SPECIES_HUMAN = 'icons/mob/onmob/onmob_head.dmi',
				SPECIES_UNATHI = 'mods/hardsuits/icons/voidsuits/onmob_head_unathi.dmi',
				SPECIES_RESOMI = 'mods/resomi/icons/clothing/onmob_head_resomi.dmi',
				SPECIES_TAJARA = 'mods/tajara/icons/sprite_sheets/helmet.dmi',
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
				SPECIES_UNATHI = 'packs/infinity/icons/obj/clothing/species/erosan/suits.dmi',
				SPECIES_RESOMI = 'packs/infinity/icons/obj/clothing/species/resomi/obj_suit_resomi.dmi',
				SPECIES_TAJARA = 'mods/tajara/icons/sprite_sheets/obj/suits.dmi',
				SPECIES_SKRELL = 'icons/obj/clothing/species/skrell/obj_suit_skrell.dmi'
				),
			SETUP_SPECIES_ONMOB = list(
				SPECIES_HUMAN = 'icons/mob/onmob/onmob_suit.dmi',
				SPECIES_UNATHI = 'mods/hardsuits/icons/voidsuits/onmob_suit_unathi.dmi',
				SPECIES_RESOMI = 'mods/resomi/icons/clothing/onmob_suit_resomi.dmi',
				SPECIES_TAJARA = 'mods/tajara/icons/sprite_sheets/suit.dmi',
				SPECIES_SKRELL = 'icons/mob/onmob/onmob_suit.dmi'
				)
		)
	)


/singleton/item_modifier/space_suit/sierra/engineering
	name = "Engineering, NT"

/singleton/item_modifier/space_suit/sierra/engineering/Initialize()
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


/singleton/item_modifier/space_suit/sierra/security
	name = "Security, NT"

/singleton/item_modifier/space_suit/sierra/security/Initialize()
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


/singleton/item_modifier/space_suit/sierra/security/alt
	name = "Security, Riot"

/singleton/item_modifier/space_suit/sierra/security/alt/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_NAME] = "riot security voidsuit helmet"
	helmet_setup[SETUP_ICON_STATE] = "rig0-secalt"
	helmet_setup[SETUP_ITEM_STATE] = "secalt_helm"

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_NAME] = "riot security voidsuit"
	suit_setup[SETUP_ICON_STATE] = "rig-secalt"


/singleton/item_modifier/space_suit/sierra/atmos
	name = "Atmos, NT"

/singleton/item_modifier/space_suit/sierra/atmos/Initialize()
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


/singleton/item_modifier/space_suit/sierra/pilot
	name = "Pilot, NT"

/singleton/item_modifier/space_suit/sierra/pilot/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_NAME] = "pilot voidsuit helmet"
	helmet_setup[SETUP_ICON_STATE] = "rig0_pilot"
	helmet_setup[SETUP_ITEM_STATE] = "pilot_helm"
	helmet_setup[SETUP_SPECIES_OBJ][SPECIES_UNATHI] = 'mods/hardsuits/icons/voidsuits/obj_head_unathi.dmi'
	helmet_setup[SETUP_SPECIES_OBJ][SPECIES_SKRELL] = 'mods/hardsuits/icons/voidsuits/obj_head_skrell.dmi'
	helmet_setup[SETUP_SPECIES_ONMOB][SPECIES_SKRELL] = 'mods/hardsuits/icons/voidsuits/onmob_head_skrell.dmi'

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_NAME] = "pilot voidsuit"
	suit_setup[SETUP_ICON_STATE] = "rig-pilot"
	suit_setup[SETUP_ITEM_STATE_SLOTS] = list(
			slot_l_hand_str = "s_suit",
			slot_r_hand_str = "s_suit"
		)
	suit_setup[SETUP_SPECIES_OBJ][SPECIES_UNATHI] = 'mods/hardsuits/icons/voidsuits/obj_suit_unathi.dmi'
	suit_setup[SETUP_SPECIES_OBJ][SPECIES_SKRELL] = 'mods/hardsuits/icons/voidsuits/obj_suit_skrell.dmi'
	suit_setup[SETUP_SPECIES_ONMOB][SPECIES_SKRELL] = 'mods/hardsuits/icons/voidsuits/onmob_suit_skrell.dmi'

/singleton/item_modifier/space_suit/sol/sierra
	name = "Standard, SCG"
	type_setups = list(
		/obj/item/clothing/head/helmet/space = list(
			SETUP_NAME = "voidsuit helmet",
			SETUP_OBJ_SHEET = 'maps/torch/icons/obj/obj_head_solgov.dmi',
			SETUP_ONMOB_SHEET = list(slot_head_str = 'maps/torch/icons/mob/onmob_head_solgov.dmi'),
			SETUP_ICON_STATE = "rig_explorer",
			SETUP_ITEM_STATE = "explorer_helm",
			SETUP_SPECIES_OBJ = list(
				SPECIES_HUMAN = 'maps/torch/icons/obj/obj_head_solgov.dmi',
				SPECIES_UNATHI = 'packs/infinity/icons/obj/clothing/species/erosan/hats.dmi',
				SPECIES_RESOMI = 'packs/infinity/icons/obj/clothing/species/resomi/obj_head_resomi.dmi',
				SPECIES_TAJARA = 'mods/tajara/icons/sprite_sheets/obj/hats.dmi',
				SPECIES_SKRELL = 'maps/torch/icons/obj/skrell/obj_head_solgov_skrell.dmi'
				),
			SETUP_SPECIES_ONMOB = list(
				SPECIES_HUMAN = 'maps/torch/icons/mob/onmob_head_solgov.dmi',
				SPECIES_UNATHI = 'mods/hardsuits/icons/voidsuits/onmob_head_unathi.dmi',
				SPECIES_RESOMI = 'mods/resomi/icons/clothing/onmob_head_resomi.dmi',
				SPECIES_TAJARA = 'mods/tajara/icons/sprite_sheets/helmet.dmi',				
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
				SPECIES_UNATHI = 'packs/infinity/icons/obj/clothing/species/erosan/suits.dmi',
				SPECIES_RESOMI = 'packs/infinity/icons/obj/clothing/species/resomi/obj_suit_resomi.dmi',
				SPECIES_TAJARA = 'mods/tajara/icons/sprite_sheets/obj/suits.dmi',
				SPECIES_SKRELL = 'maps/torch/icons/obj/skrell/obj_suit_solgov_skrell.dmi'
				),
			SETUP_SPECIES_ONMOB = list(
				SPECIES_HUMAN = 'maps/torch/icons/mob/onmob_suit_solgov.dmi',
				SPECIES_UNATHI = 'mods/hardsuits/icons/voidsuits/onmob_suit_unathi.dmi',
				SPECIES_RESOMI = 'mods/resomi/icons/clothing/onmob_suit_resomi.dmi',
				SPECIES_TAJARA = 'mods/tajara/icons/sprite_sheets/suit.dmi',
				SPECIES_SKRELL = 'maps/torch/icons/mob/skrell/onmob_suit_solgov_skrell.dmi'
				)
		)
	)

/singleton/item_modifier/space_suit/sol/sierra/medical
	name = "Medical, Streamlined"

/singleton/item_modifier/space_suit/sol/sierra/medical/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_NAME] = "streamlined medical voidsuit helmet"
	helmet_setup[SETUP_ICON_STATE] = "rig0-medicalalt"
	helmet_setup[SETUP_ITEM_STATE] = "medicalalt_helm"

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_NAME] = "streamlined medical voidsuit"
	suit_setup[SETUP_ICON_STATE] = "rig-medicalalt"

/singleton/item_modifier/space_suit/sol/sierra/exploration
	name = "Explorer, SCG"

/singleton/item_modifier/space_suit/sol/sierra/exploration/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_NAME] = "exploration voidsuit helmet"
	helmet_setup[SETUP_ICON_STATE] = "rig0_explorer"
	helmet_setup[SETUP_ITEM_STATE] = "explorer_helm"
	helmet_setup[SETUP_SPECIES_OBJ][SPECIES_UNATHI] = 'mods/hardsuits/icons/voidsuits/obj_head_unathi.dmi'
	helmet_setup[SETUP_SPECIES_OBJ][SPECIES_SKRELL] = 'mods/hardsuits/icons/voidsuits/obj_head_skrell.dmi'
	helmet_setup[SETUP_SPECIES_ONMOB][SPECIES_SKRELL] = 'mods/hardsuits/icons/voidsuits/onmob_head_skrell.dmi'

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_NAME] = "exploration voidsuit"
	suit_setup[SETUP_ICON_STATE] = "rig_explorer"
	suit_setup[SETUP_SPECIES_OBJ][SPECIES_UNATHI] = 'mods/hardsuits/icons/voidsuits/obj_suit_unathi.dmi'
	suit_setup[SETUP_SPECIES_OBJ][SPECIES_SKRELL] = 'mods/hardsuits/icons/voidsuits/obj_suit_skrell.dmi'
	suit_setup[SETUP_SPECIES_ONMOB][SPECIES_SKRELL] = 'mods/hardsuits/icons/voidsuits/onmob_suit_skrell.dmi'

#undef SETUP_NAME
#undef SETUP_OBJ_SHEET
#undef SETUP_ONMOB_SHEET
#undef SETUP_ICON_STATE
#undef SETUP_ITEM_STATE
#undef SETUP_ITEM_STATE_SLOTS
#undef SETUP_SPECIES_OBJ
#undef SETUP_SPECIES_ONMOB
