/obj/item/clothing/head/helmet/space/rig/command/exploration/New()
	. = ..()
	species_restricted |= list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI,SPECIES_IPC)
	sprite_sheets ^= list(
		SPECIES_SKRELL,
		SPECIES_UNATHI
	)
	sprite_sheets |= list(
		SPECIES_SKRELL = 'mods/hardsuits/icons/rigs/onmob_head_solgov_skrell.dmi',
		SPECIES_UNATHI = 'mods/hardsuits/icons/rigs/onmob_head_solgov_unathi.dmi'
	)
		
/obj/item/clothing/suit/space/rig/command/exploration
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI,SPECIES_IPC)
	icon_state = "command_exp_rig"
	sprite_sheets = list(
		SPECIES_UNATHI = 'mods/hardsuits/icons/rigs/onmob_suit_solgov_unathi.dmi'
	)
		
/obj/item/clothing/gloves/rig/command/exploration
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI,SPECIES_IPC)
	icon_state = "command_exp_rig"
	sprite_sheets = list(
		SPECIES_UNATHI = 'mods/hardsuits/icons/rigs/onmob_hands_solgov_unathi.dmi'
	)
		
/obj/item/clothing/shoes/magboots/rig/command/exploration
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI,SPECIES_IPC)
	icon_state = "command_exp_rig"
	sprite_sheets = list(
		SPECIES_UNATHI = 'mods/hardsuits/icons/rigs/onmob_feet_solgov_unathi.dmi'
	)
