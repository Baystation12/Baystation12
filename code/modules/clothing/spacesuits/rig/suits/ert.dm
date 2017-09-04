/obj/item/weapon/rig/ert
	name = "asset protection command hardsuit control module"
	desc = "A hardsuit used by many corporate and private asset protection forces. Has blue highlights. Armoured and space ready."
	suit_type = "Asset Protection command"
	icon_state = "ert_commander_rig"

	chest_type = /obj/item/clothing/suit/space/rig/ert
	helm_type = /obj/item/clothing/head/helmet/space/rig/ert
	boot_type = /obj/item/clothing/shoes/magboots/rig/ert
	glove_type = /obj/item/clothing/gloves/rig/ert

	req_access = list(access_cent_specops)

	armor = list(melee = 60, bullet = 50, laser = 50,energy = 15, bomb = 30, bio = 100, rad = 100)
	allowed = list(/obj/item/device/flashlight, /obj/item/weapon/tank,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/handcuffs, /obj/item/device/t_scanner, /obj/item/weapon/rcd, /obj/item/weapon/crowbar, \
	/obj/item/weapon/screwdriver, /obj/item/weapon/weldingtool, /obj/item/weapon/wirecutters, /obj/item/weapon/wrench, /obj/item/device/multitool, \
	/obj/item/device/radio, /obj/item/device/analyzer,/obj/item/weapon/storage/briefcase/inflatable, /obj/item/weapon/melee/baton, /obj/item/weapon/gun, \
	/obj/item/weapon/storage/firstaid, /obj/item/weapon/reagent_containers/hypospray, /obj/item/roller)

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/datajack,
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
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI)


/obj/item/weapon/rig/ert/engineer
	name = "asset protection engineering hardsuit control module"
	desc = "A hardsuit used by many corporate and private asset protection forces. Has orange highlights. Armoured and space ready."
	suit_type = "Asset Protection engineer"
	icon_state = "ert_engineer_rig"
	armor = list(melee = 60, bullet = 50, laser = 50,energy = 15, bomb = 30, bio = 100, rad = 100)

	glove_type = /obj/item/clothing/gloves/rig/ert/engineer

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/plasmacutter,
		/obj/item/rig_module/device/rcd
		)

/obj/item/clothing/gloves/rig/ert/engineer
	siemens_coefficient = 0

/obj/item/weapon/rig/ert/janitor
	name = "asset protection sanitation hardsuit control module"
	desc = "A hardsuit used by many corporate and private asset protection forces. Has purple highlights. Armoured and space ready."
	suit_type = "Asset Protection sanitation"
	icon_state = "ert_janitor_rig"
	armor = list(melee = 60, bullet = 50, laser = 50,energy = 40, bomb = 40, bio = 100, rad = 100)

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/fabricator/wf_sign,
		/obj/item/rig_module/grenade_launcher/cleaner,
		/obj/item/rig_module/device/decompiler
		)

/obj/item/weapon/rig/ert/medical
	name = "asset protection medical hardsuit control module"
	desc = "A hardsuit used by many corporate and private asset protection forces. Has white highlights. Armoured and space ready."
	suit_type = "Asset Protection medic"
	icon_state = "ert_medical_rig"

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/chem_dispenser/injector
		)

/obj/item/weapon/rig/ert/security
	name = "asset protection security hardsuit control module"
	desc = "A hardsuit used by many corporate and private asset protection forces. Has red highlights. Armoured and space ready."
	suit_type = "Asset Protection security"
	icon_state = "ert_security_rig"

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/mounted/egun,
		)

/obj/item/weapon/rig/ert/assetprotection
	name = "heavy asset protection suit control module"
	desc = "A heavy, modified version of a common asset protection hardsuit. Has blood red highlights.  Armoured and space ready."
	suit_type = "heavy asset protection"
	icon_state = "asset_protection_rig"
	armor = list(melee = 60, bullet = 50, laser = 50,energy = 40, bomb = 40, bio = 100, rad = 100)

	glove_type = /obj/item/clothing/gloves/rig/ert/assetprotection

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/mounted/egun,
		/obj/item/rig_module/chem_dispenser/injector,
		/obj/item/rig_module/device/plasmacutter,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/datajack
		)

/obj/item/clothing/gloves/rig/ert/assetprotection
	siemens_coefficient = 0
