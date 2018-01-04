/obj/item/weapon/rig/light/internalaffairs
	name = "augmented tie"
	suit_type = "augmented suit"
	desc = "Prepare for paperwork."
	icon_state = "internalaffairs_rig"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	online_slowdown = 0
	offline_slowdown = 0
	offline_vision_restriction = 0

	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/briefcase, /obj/item/weapon/storage/secure/briefcase)

	req_access = list()
	req_one_access = list()

	glove_type = null
	helm_type = null
	boot_type = null

	hides_uniform = 0

/obj/item/weapon/rig/light/internalaffairs/equipped

	req_access = list(access_lawyer)

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/device/paperdispenser,
		/obj/item/rig_module/device/pen,
		/obj/item/rig_module/device/stamp
		)

	glove_type = null
	helm_type = null
	boot_type = null

/obj/item/weapon/rig/industrial
	name = "industrial suit control module"
	suit_type = "industrial hardsuit"
	desc = "A heavy, powerful rig used by construction crews and mining corporations."
	icon_state = "engineering_rig"
	armor = list(melee = 60, bullet = 50, laser = 50,energy = 15, bomb = 30, bio = 100, rad = 50)
	online_slowdown = 3
	offline_slowdown = 10
	vision_restriction = TINT_HEAVY
	offline_vision_restriction = TINT_BLIND
	emp_protection = -20

	chest_type = /obj/item/clothing/suit/space/rig/industrial
	helm_type = /obj/item/clothing/head/helmet/space/rig/industrial
	boot_type = /obj/item/clothing/shoes/magboots/rig/industrial
	glove_type = /obj/item/clothing/gloves/rig/industrial

	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/stack/flag,/obj/item/weapon/storage/ore,/obj/item/device/t_scanner,/obj/item/weapon/pickaxe, /obj/item/weapon/rcd)

	req_access = list()
	req_one_access = list()

/obj/item/clothing/head/helmet/space/rig/industrial
	camera = /obj/machinery/camera/network/mining
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI)

/obj/item/clothing/suit/space/rig/industrial
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI)

/obj/item/clothing/shoes/magboots/rig/industrial
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI)

/obj/item/clothing/gloves/rig/industrial
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI)
	siemens_coefficient = 0

/obj/item/weapon/rig/industrial/equipped

	initial_modules = list(
		/obj/item/rig_module/device/plasmacutter,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/device/orescanner,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/vision/meson
		)

/obj/item/weapon/rig/eva
	name = "EVA hardsuit control module"
	suit_type = "EVA hardsuit"
	desc = "A light rig for repairs and maintenance to the outside of habitats and vessels."
	icon_state = "eva_rig"
	armor = list(melee = 30, bullet = 10, laser = 20,energy = 25, bomb = 20, bio = 100, rad = 100)
	online_slowdown = 0
	offline_slowdown = 1
	offline_vision_restriction = TINT_HEAVY

	chest_type = /obj/item/clothing/suit/space/rig/eva
	helm_type = /obj/item/clothing/head/helmet/space/rig/eva
	boot_type = /obj/item/clothing/shoes/magboots/rig/eva
	glove_type = /obj/item/clothing/gloves/rig/eva

	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/toolbox,/obj/item/weapon/storage/briefcase/inflatable,/obj/item/weapon/inflatable_dispenser,/obj/item/device/t_scanner,/obj/item/weapon/rcd)

	req_access = list()
	req_one_access = list()

/obj/item/clothing/head/helmet/space/rig/eva
	light_overlay = "helmet_light_dual"
	camera = /obj/machinery/camera/network/engineering
	species_restricted = list(SPECIES_HUMAN)

/obj/item/clothing/suit/space/rig/eva
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL)

/obj/item/clothing/shoes/magboots/rig/eva
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL)

/obj/item/clothing/gloves/rig/eva
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL)
	siemens_coefficient = 0

/obj/item/weapon/rig/eva/equipped

	initial_modules = list(
		/obj/item/rig_module/device/plasmacutter,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/vision/meson
		)

/obj/item/weapon/rig/ce

	name = "advanced engineering hardsuit control module"
	suit_type = "engineering hardsuit"
	desc = "An advanced hardsuit that protects against hazardous, low pressure environments. Shines with a high polish. Appears compatible with the physiology of most species."
	icon_state = "ce_rig"
	armor = list(melee = 40, bullet = 25, laser = 30, energy = 25, bomb = 40, bio = 100, rad = 100)
	online_slowdown = 0
	offline_slowdown = 0
	offline_vision_restriction = TINT_HEAVY

	helm_type = /obj/item/clothing/head/helmet/space/rig/ce
	glove_type = /obj/item/clothing/gloves/rig/ce

	allowed = list(/obj/item/weapon/gun,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/ore,/obj/item/weapon/storage/toolbox,/obj/item/weapon/storage/briefcase/inflatable,/obj/item/weapon/inflatable_dispenser,/obj/item/device/t_scanner,/obj/item/weapon/pickaxe,/obj/item/weapon/rcd)

	req_access = list()
	req_one_access = list()

/obj/item/weapon/rig/ce/equipped

	req_access = list(access_ce)

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/plasmacutter,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/vision/meson
		)

/obj/item/clothing/head/helmet/space/rig/ce
	camera = /obj/machinery/camera/network/engineering

/obj/item/clothing/gloves/rig/ce
	siemens_coefficient = 0

/obj/item/weapon/rig/hazmat

	name = "AMI control module"
	suit_type = "hazmat hardsuit"
	desc = "An Anomalous Material Interaction hardsuit, a prototype NanoTrasen design, protects the wearer against the strangest energies the universe can throw at it."
	icon_state = "science_rig"
	armor = list(melee = 45, bullet = 5, laser = 45, energy = 80, bomb = 60, bio = 100, rad = 100)
	online_slowdown = 1
	offline_vision_restriction = TINT_HEAVY

	chest_type = /obj/item/clothing/suit/space/rig/hazmat
	helm_type = /obj/item/clothing/head/helmet/space/rig/hazmat
	boot_type = /obj/item/clothing/shoes/magboots/rig/hazmat
	glove_type = /obj/item/clothing/gloves/rig/hazmat

	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/stack/flag,/obj/item/weapon/storage/excavation,/obj/item/weapon/pickaxe,/obj/item/device/healthanalyzer,/obj/item/device/measuring_tape,/obj/item/device/ano_scanner,/obj/item/device/depth_scanner,/obj/item/device/core_sampler,/obj/item/device/gps,/obj/item/device/beacon_locator,/obj/item/device/radio/beacon,/obj/item/weapon/pickaxe/hand,/obj/item/weapon/storage/bag/fossils)

	req_access = list()
	req_one_access = list()

/obj/item/clothing/head/helmet/space/rig/hazmat
	light_overlay = "helmet_light_dual"
	camera = /obj/machinery/camera/network/research
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI)

/obj/item/clothing/suit/space/rig/hazmat
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI)

/obj/item/clothing/shoes/magboots/rig/hazmat
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI)

/obj/item/clothing/gloves/rig/hazmat
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI)

/obj/item/weapon/rig/hazmat/equipped

	req_access = list(access_rd)

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/anomaly_scanner
		)

/obj/item/weapon/rig/medical

	name = "rescue suit control module"
	suit_type = "rescue hardsuit"
	desc = "A durable suit designed for medical rescue in high risk areas."
	icon_state = "medical_rig"
	armor = list(melee = 30, bullet = 15, laser = 25, energy = 60, bomb = 30, bio = 100, rad = 100)
	online_slowdown = 1
	offline_vision_restriction = TINT_HEAVY

	chest_type = /obj/item/clothing/suit/space/rig/medical
	helm_type = /obj/item/clothing/head/helmet/space/rig/medical
	boot_type = /obj/item/clothing/shoes/magboots/rig/medical
	glove_type = /obj/item/clothing/gloves/rig/medical

	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/firstaid,/obj/item/device/healthanalyzer,/obj/item/stack/medical,/obj/item/roller )

	req_access = list()
	req_one_access = list()

/obj/item/clothing/head/helmet/space/rig/medical
	camera = /obj/machinery/camera/network/medbay
	species_restricted = list(SPECIES_HUMAN, SPECIES_TAJARA)

/obj/item/clothing/suit/space/rig/medical
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL, SPECIES_TAJARA)

/obj/item/clothing/shoes/magboots/rig/medical
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL, SPECIES_TAJARA)

/obj/item/clothing/gloves/rig/medical
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL, SPECIES_TAJARA)

/obj/item/weapon/rig/medical/equipped

	req_access = list(access_medical_equip)

	initial_modules = list(
		/obj/item/rig_module/chem_dispenser/injector,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/vision/medhud
		)

/obj/item/weapon/rig/hazard
	name = "hazard hardsuit control module"
	suit_type = "hazard hardsuit"
	desc = "A NanoTrasen security hardsuit designed for prolonged EVA in dangerous environments."
	icon_state = "hazard_rig"
	armor = list(melee = 60, bullet = 40, laser = 40, energy = 15, bomb = 60, bio = 100, rad = 30)
	online_slowdown = 1
	offline_slowdown = 3
	offline_vision_restriction = TINT_BLIND

	chest_type = /obj/item/clothing/suit/space/rig/hazard
	helm_type = /obj/item/clothing/head/helmet/space/rig/hazard
	boot_type = /obj/item/clothing/shoes/magboots/rig/hazard
	glove_type = /obj/item/clothing/gloves/rig/hazard

	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/handcuffs,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/melee/baton)

	req_access = list()
	req_one_access = list()

/obj/item/clothing/head/helmet/space/rig/hazard
	light_overlay = "helmet_light_dual"
	camera = /obj/machinery/camera/network/security
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI)

/obj/item/clothing/suit/space/rig/hazard
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI)

/obj/item/clothing/shoes/magboots/rig/hazard
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI)

/obj/item/clothing/gloves/rig/hazard
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI)

/obj/item/weapon/rig/hazard/equipped

	initial_modules = list(
		/obj/item/rig_module/vision/sechud,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/mounted/taser
		)
