/////////////////////////
//~~Bless this mess~~//
/////////////////////

/*
 * BASE TYPE
 */
/obj/item/rig/command
	name = "command HCM"
	suit_type = "command hardsuit"
	icon = 'maps/torch/icons/obj/uniques.dmi'
	desc = "A specialized hardsuit rig control module issued to command staff of the Expeditionary Corps and their peers."
	icon_state = "command_rig"
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)
	online_slowdown = 0.50
	offline_slowdown = 2
	offline_vision_restriction = TINT_HEAVY

	chest_type = /obj/item/clothing/suit/space/rig/command
	helm_type = /obj/item/clothing/head/helmet/space/rig/command
	boot_type = /obj/item/clothing/shoes/magboots/rig/command
	glove_type = /obj/item/clothing/gloves/rig/command

	req_access = list(access_heads) // Bridge
	allowed = list(
		/obj/item/gun,
		/obj/item/ammo_magazine,
		/obj/item/device/flashlight,
		/obj/item/tank,
		/obj/item/device/suit_cooling_unit,
		/obj/item/storage/secure/briefcase
	)

/obj/item/clothing/head/helmet/space/rig/command
	light_overlay = "helmet_light_dual"
	icon = 'maps/torch/icons/obj/obj_head_solgov.dmi'
	item_icons = list(slot_head_str = 'maps/torch/icons/mob/onmob_head_solgov.dmi')
	camera = /obj/machinery/camera/network/command
	// SIERRA TODO: port SPECIES_TAJARA, SPECIES_RESOMI
	species_restricted = list(SPECIES_HUMAN, SPECIES_IPC/*, SPECIES_TAJARA, SPECIES_RESOMI*/) // No available icons for aliens

/obj/item/clothing/suit/space/rig/command
	icon = 'maps/torch/icons/obj/obj_suit_solgov.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/onmob_suit_solgov.dmi')
	// SIERRA TODO: port SPECIES_TAJARA, SPECIES_RESOMI
	species_restricted = list(SPECIES_HUMAN, SPECIES_IPC/*, SPECIES_TAJARA, SPECIES_RESOMI*/)

/obj/item/clothing/shoes/magboots/rig/command
	icon = 'maps/torch/icons/obj/obj_feet_solgov.dmi'
	item_icons = list(slot_shoes_str = 'maps/torch/icons/mob/onmob_feet_solgov.dmi')
	// SIERRA TODO: port SPECIES_TAJARA, SPECIES_RESOMI
	species_restricted = list(SPECIES_HUMAN, SPECIES_IPC/*, SPECIES_TAJARA, SPECIES_RESOMI*/)

/obj/item/clothing/gloves/rig/command
	icon = 'maps/torch/icons/obj/obj_hands_solgov.dmi'
	item_icons = list(slot_gloves_str = 'maps/torch/icons/mob/onmob_hands_solgov.dmi')
	// SIERRA TODO: port SPECIES_TAJARA, SPECIES_RESOMI
	species_restricted = list(SPECIES_HUMAN, SPECIES_IPC/*, SPECIES_TAJARA, SPECIES_RESOMI*/)

/obj/item/rig/command/equipped
	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/cooling_unit
		)

/*
 * HEAD OF PERSONELL
 */
/obj/item/rig/command/hop
	name = "HoP's HCM"
	suit_type = "advanced command hardsuit"
	desc = "A specialized hardsuit rig control module issued to ranking personnel command staff of the NanoTrasen and their peers."
	icon_state = "command_XO_rig"
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)

	chest_type = /obj/item/clothing/suit/space/rig/command/hop
	helm_type = /obj/item/clothing/head/helmet/space/rig/command/hop

	allowed = list(/obj/item/gun, /obj/item/ammo_magazine, /obj/item/device/flashlight, /obj/item/tank, /obj/item/device/suit_cooling_unit, /obj/item/storage/secure/briefcase)
	req_access = list(access_hop)

/obj/item/clothing/head/helmet/space/rig/command/hop
	icon_state = "command_XO_rig"
/obj/item/clothing/suit/space/rig/command/hop
	icon_state = "command_XO_rig"

/obj/item/rig/command/hop/equipped
	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/flash/advanced,
		/obj/item/rig_module/grenade_launcher/smoke,
		/obj/item/rig_module/cooling_unit)

/*
 * COMMANDING OFFICER
 */
/obj/item/rig/command/captain
	name = "captain's HCM"
	suit_type = "advanced command hardsuit"
	desc = "A specialized hardsuit rig control module issued to captains of the NanoTrasen."
	icon_state = "command_CO_rig"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)

	chest_type = /obj/item/clothing/suit/space/rig/command/captain
	helm_type = /obj/item/clothing/head/helmet/space/rig/command/captain
	allowed = list(/obj/item/gun, /obj/item/ammo_magazine, /obj/item/device/flashlight, /obj/item/tank, /obj/item/device/suit_cooling_unit, /obj/item/storage/secure/briefcase)

	req_access = list(access_captain)

/obj/item/clothing/head/helmet/space/rig/command/captain
	icon_state = "command_CO_rig"
/obj/item/clothing/suit/space/rig/command/captain
	icon_state = "command_CO_rig"

/obj/item/rig/command/captain/equipped
	initial_modules = list(
//INF		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/flash/advanced,
		/obj/item/rig_module/grenade_launcher/smoke,
		/obj/item/rig_module/cooling_unit)

/*
 * CHIEF MEDICAL OFFICER
 */
/obj/item/rig/command/cmo
	name = "CMO's HCM"
	suit_type = "medical command hardsuit"
	desc = "A specialized hardsuit rig control module issued to ranking medical command staff of the NanoTrasen and their peers."

	sprite_sheets = list(
		SPECIES_RESOMI = 'mods/resomi/icons/clothing/onmob_rig_back_resomi.dmi',
		//SPECIES_UNATHI = 'icons/mob/onmob/Unathi/rig_back.dmi' TODO: SIERRA PORT
		)

	icon_state = "command_med_rig"
	chest_type = /obj/item/clothing/suit/space/rig/command/cmo
	helm_type = /obj/item/clothing/head/helmet/space/rig/command/cmo

	allowed = list(/obj/item/gun,
				   /obj/item/ammo_magazine,
				   /obj/item/device/flashlight,
				   /obj/item/tank,
			 	   /obj/item/device/suit_cooling_unit,
				   /obj/item/storage/firstaid,
				   /obj/item/device/scanner/health,
				   /obj/item/stack/medical,
				   /obj/item/roller_bed)

	req_access = list(access_cmo)

/obj/item/clothing/head/helmet/space/rig/command/cmo
	icon_state = "command_med_rig"

/obj/item/clothing/suit/space/rig/command/cmo
	icon_state = "command_med_rig"


/obj/item/rig/command/cmo/equipped
	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/device/defib,
		/obj/item/rig_module/chem_dispenser/injector,
		/obj/item/rig_module/vision/medhud,
		/obj/item/rig_module/cooling_unit)

/*
* CHIEF OF SECURITY
*/
/obj/item/rig/command/hos
	name = "HoS' HCM"
	suit_type = "security command hardsuit"
	desc = "A specialized hardsuit rig control module issued to ranking security command staff of the NanoTrasen and their peers."
	icon = 'maps/sierra/icons/obj/rig_modules.dmi'
	icon_state = "hos_rig"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)

	chest_type = /obj/item/clothing/suit/space/rig/command/hos
	helm_type = /obj/item/clothing/head/helmet/space/rig/command/hos
	boot_type = /obj/item/clothing/shoes/magboots/rig/command/hos
	glove_type = /obj/item/clothing/gloves/rig/command/hos

	allowed = list(/obj/item/gun,
	 			  /obj/item/ammo_magazine,
	  			  /obj/item/handcuffs,
	   			  /obj/item/device/flashlight,
	    		  /obj/item/tank,
				  /obj/item/device/suit_cooling_unit,
				  /obj/item/melee/baton)

	req_access = list(access_hos)

/obj/item/clothing/head/helmet/space/rig/command/hos
	icon_state = "hos_rig"
	icon = 'maps/sierra/icons/obj/clothing/obj_head.dmi'
	item_icons = list(slot_head_str = 'maps/sierra/icons/mob/onmob/onmob_head.dmi')
	species_restricted = list(SPECIES_HUMAN) // No available icons for aliens

/obj/item/clothing/suit/space/rig/command/hos
	icon_state = "hos_rig"
	icon = 'maps/sierra/icons/obj/clothing/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi')
	species_restricted = list(SPECIES_HUMAN)

/obj/item/clothing/shoes/magboots/rig/command/hos
	icon_state = "hos_rig"
	icon = 'maps/sierra/icons/obj/clothing/obj_feet.dmi'
	item_icons = list(slot_shoes_str = 'maps/sierra/icons/mob/onmob/onmob_feet.dmi')
	species_restricted = list(SPECIES_HUMAN)

/obj/item/clothing/gloves/rig/command/hos
	icon_state = "hos_rig"
	icon = 'maps/sierra/icons/obj/clothing/obj_hands.dmi'
	item_icons = list(slot_gloves_str = 'maps/sierra/icons/mob/onmob/onmob_hands.dmi')
	species_restricted = list(SPECIES_HUMAN)


/obj/item/rig/command/hos/equipped
	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/vision/sechud,
		/obj/item/rig_module/cooling_unit)

/*
* CHIEF SCIENCE OFFICER
*/
/obj/item/rig/command/science
	name = "research command HCM"
	suit_type = "research command hardsuit"
	desc = "A specialized hardsuit rig control module issued to ranking research officers of the Expeditionary Corps."
	icon_state = "command_sci_rig"
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_STRONG,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
		)

	chest_type = /obj/item/clothing/suit/space/rig/command/science
	helm_type = /obj/item/clothing/head/helmet/space/rig/command/science

	allowed = list(/obj/item/gun,
				   /obj/item/ammo_magazine,
				   /obj/item/device/flashlight,
				   /obj/item/tank,
				   /obj/item/device/suit_cooling_unit,
			       /obj/item/stack/flag,
				   /obj/item/storage/excavation,
				   /obj/item/device/scanner/health,
				   /obj/item/device/measuring_tape,
				   /obj/item/device/ano_scanner,
				   /obj/item/device/depth_scanner,
				   /obj/item/device/core_sampler,
				   /obj/item/device/gps,
				   /obj/item/pinpointer/radio,
				   /obj/item/pickaxe/xeno,
				   /obj/item/storage/bag/fossils,
				   /obj/item/rig_module/grenade_launcher/light)

	req_access = list(access_rd)

/obj/item/clothing/head/helmet/space/rig/command/science
	icon_state = "command_sci_rig"

/obj/item/clothing/suit/space/rig/command/science
	icon_state = "command_sci_rig"

/obj/item/clothing/shoes/magboots/rig/command/science
/obj/item/clothing/gloves/rig/command/science


/obj/item/rig/command/science/equipped
	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/device/anomaly_scanner,
		/obj/item/rig_module/grenade_launcher/light,
		/obj/item/rig_module/cooling_unit)

/*
* EXPLORATION
*/
/obj/item/rig/exploration
	name = "heavy exploration HCM"
	suit_type = "heavy exploration hardsuit"
	desc = "Expeditionary Corps' Exoplanet Exploration Armored Unit, A-Unit for short. Built for more hostile (and hungry) environments, it features additional armor and powered exoskeleton."
	icon = 'maps/sierra/icons/obj/uniques.dmi'
	icon_state = "command_exp_rig"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_MINOR,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
		)

	chest_type = /obj/item/clothing/suit/space/rig/command
	helm_type = /obj/item/clothing/head/helmet/space/rig/command/exploration
	boot_type = /obj/item/clothing/shoes/magboots/rig/command
	glove_type = /obj/item/clothing/gloves/rig/command

	allowed = list(/obj/item/gun,
				   /obj/item/ammo_magazine,
				   /obj/item/device/flashlight,
				   /obj/item/tank,
				   /obj/item/device/suit_cooling_unit)

	online_slowdown = 0.50
	offline_slowdown = 4
	offline_vision_restriction = TINT_BLIND

/obj/item/clothing/head/helmet/space/rig/command/exploration
	camera = /obj/machinery/camera/network/expedition
	icon_state = "command_exp_rig"
	light_overlay = "yellow_double_light"
	brightness_on = 0.8

/obj/item/rig/exploration/equipped
	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/device/anomaly_scanner,
		/obj/item/rig_module/grenade_launcher/light,
		/obj/item/rig_module/cooling_unit)

/*
 Overrides for standard mapset rig items
 */

/obj/item/clothing/head/helmet/space/rig/industrial
	camera = /obj/machinery/camera/network/supply
