/obj/item/weapon/rig/ert
	name = "emergency response command hardsuit control module"
	desc = "A hardsuit used by many corporate and governmental emergency response forces. Has blue highlights. Armoured and space ready."
	suit_type = "emergency response command"
	icon_state = "ert_commander_rig"

	chest_type = /obj/item/clothing/suit/space/rig/ert
	helm_type = /obj/item/clothing/head/helmet/space/rig/ert
	boot_type = /obj/item/clothing/shoes/magboots/rig/ert
	glove_type = /obj/item/clothing/gloves/rig/ert

	req_access = list(access_cent_specops)

	armor = list(
		melee = ARMOR_MELEE_MAJOR, 
		bullet = ARMOR_BALLISTIC_RESISTANT, 
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_MINOR, 
		bomb = ARMOR_BOMB_PADDED, 
		bio = ARMOR_BIO_SHIELDED, 
		rad = ARMOR_RAD_SHIELDED
		)
	allowed = list(/obj/item/device/flashlight, /obj/item/weapon/tank,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/handcuffs, /obj/item/device/t_scanner, /obj/item/weapon/rcd, /obj/item/weapon/crowbar, \
	/obj/item/weapon/screwdriver, /obj/item/weapon/weldingtool, /obj/item/weapon/wirecutters, /obj/item/weapon/wrench, /obj/item/device/multitool, \
	/obj/item/device/radio, /obj/item/device/scanner/gas,/obj/item/weapon/storage/briefcase/inflatable, /obj/item/weapon/melee/baton, /obj/item/weapon/gun, \
	/obj/item/weapon/storage/firstaid, /obj/item/weapon/reagent_containers/hypospray, /obj/item/roller)

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/clothing/head/helmet/space/rig/ert
	light_overlay = "helmet_light_dual"
	camera = /obj/machinery/camera/network/ert
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI)

/obj/item/clothing/suit/space/rig/ert
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI)

/obj/item/clothing/shoes/magboots/rig/ert
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI)

/obj/item/clothing/gloves/rig/ert
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_NOCUFFS
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI)


/obj/item/weapon/rig/ert/engineer
	name = "emergency response engineering hardsuit control module"
	desc = "A hardsuit used by many corporate and governmental emergency response forces. Has orange highlights. Armoured and space ready."
	suit_type = "emergency response engineer"
	icon_state = "ert_engineer_rig"

	glove_type = /obj/item/clothing/gloves/rig/ert/engineer

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/mounted/plasmacutter,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/clothing/gloves/rig/ert/engineer
	siemens_coefficient = 0

/obj/item/weapon/rig/ert/janitor
	name = "emergency response sanitation hardsuit control module"
	desc = "A hardsuit used by many corporate and governmental emergency response forces. Has purple highlights. Armoured and space ready."
	suit_type = "emergency response sanitation"
	icon_state = "ert_janitor_rig"

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/fabricator/wf_sign,
		/obj/item/rig_module/grenade_launcher/cleaner,
		/obj/item/rig_module/device/decompiler,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/weapon/rig/ert/medical
	name = "emergency response medical hardsuit control module"
	desc = "A hardsuit used by many corporate and governmental emergency response forces. Has white highlights. Armoured and space ready."
	suit_type = "emergency response medic"
	icon_state = "ert_medical_rig"

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/chem_dispenser/injector,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/weapon/rig/ert/security
	name = "emergency response security hardsuit control module"
	desc = "A hardsuit used by many corporate and governmental emergency response forces. Has red highlights. Armoured and space ready."
	suit_type = "emergency response security"
	icon_state = "ert_security_rig"

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/mounted/egun,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/weapon/rig/ert/assetprotection
	name = "heavy emergency response suit control module"
	desc = "A heavy, modified version of a common emergency response hardsuit. Has blood red highlights.  Armoured and space ready."
	suit_type = "heavy emergency response"
	icon_state = "asset_protection_rig"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH, 
		bullet = ARMOR_BALLISTIC_RESISTANT, 
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_MINOR, 
		bomb = ARMOR_BOMB_PADDED, 
		bio = ARMOR_BIO_SHIELDED, 
		rad = ARMOR_RAD_SHIELDED
		)

	glove_type = /obj/item/clothing/gloves/rig/ert/assetprotection

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/mounted/egun,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/mounted/plasmacutter,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/clothing/gloves/rig/ert/assetprotection
	siemens_coefficient = 0
