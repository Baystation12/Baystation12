/obj/item/rig/ert
	name = "emergency response hardsuit control module"
	desc = "A hardsuit used by many corporate and governmental emergency response forces. Has blue highlights. Armoured and space ready."
	suit_type = "emergency response command"
	icon_state = "ert_commander_rig"

	req_access = list(access_ert_responder)

	online_slowdown = 0.4
	offline_slowdown = 1
	seal_delay = 10 // ERT hardsuits deploy quicker, speeding up equip time
	equip_delay = 1 SECOND

	max_heat_protection_temperature = RIG_MAX_HEAT_PROTECTION_TEMPERATURE
	max_pressure_protection = HEAVY_RIG_MAX_PRESSURE
	emp_protection = 6

	chest_type = /obj/item/clothing/suit/space/rig/ert
	helm_type = /obj/item/clothing/head/helmet/space/rig/ert
	boot_type = /obj/item/clothing/shoes/magboots/rig/ert
	glove_type = /obj/item/clothing/gloves/rig/ert
	air_type =	/obj/item/tank/oxygen/full
	cell_type = /obj/item/cell/hyper

	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
		)

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/clothing/head/helmet/space/rig/ert
	light_overlay = "helmet_light_dual"
	camera = /obj/machinery/camera/network/ert
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_IPC)

/obj/item/clothing/suit/space/rig/ert
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_IPC)
	allowed = list(
		/obj/item/device/flashlight,
		/obj/item/tank,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/handcuffs,
		/obj/item/device/t_scanner,
		/obj/item/rcd,
		/obj/item/rpd,
		/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/weldingtool,
		/obj/item/wirecutters,
		/obj/item/wrench,
		/obj/item/device/multitool,
		/obj/item/device/radio,
		/obj/item/device/scanner/gas,
		/obj/item/storage/briefcase/inflatable,
		/obj/item/gun,
		/obj/item/storage/firstaid,
		/obj/item/reagent_containers/hypospray,
		/obj/item/roller_bed,
		/obj/item/device/binoculars,
		/obj/item/grenade,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/device/flash,
		/obj/item/clothing/glasses,
		/obj/item/flame/lighter,
		/obj/item/modular_computer,
		/obj/item/device/hailer,
		/obj/item/device/megaphone,
		/obj/item/melee,
		/obj/item/taperoll,
		/obj/item/tape_roll,
		/obj/item/device/holowarrant,
		/obj/item/magnetic_ammo,
		/obj/item/clothing/gloves,
		/obj/item/clothing/head/beret,
		/obj/item/material/knife
	)
	slots = 3 STORAGE_FREEFORM

/obj/item/clothing/shoes/magboots/rig/ert
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_IPC)

/obj/item/clothing/gloves/rig/ert
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_NOCUFFS | ITEM_FLAG_AIRTIGHT | ITEM_FLAG_INVALID_FOR_CHAMELEON
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_IPC)

/obj/item/rig/ert/janitor
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
