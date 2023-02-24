/*
HARDSUITS
*/

/obj/item/rig/ce/unlocked
	req_access = list()

/obj/item/rig/medical/unlocked
	req_access = list()

/obj/item/rig/eva/unlocked
	req_access = list()

/obj/item/rig/ert/fleet/unlocked
	req_access = list()

/datum/design/item/mechfab/hcm/zero
	category = "Hardsuit Control Modules"
	name = "Null suit control module"
	build_path = /obj/item/rig/zero
	materials = list(MATERIAL_STEEL = 20000, MATERIAL_GLASS = 5000, MATERIAL_PLASTIC = 10000, MATERIAL_SILVER = 1000)
	id = "null_suit"
	time = 120

/datum/design/item/mechfab/hcm/indistrial
	category = "Hardsuit Control Modules"
	name = "Indistrial suit control module"
	build_path = /obj/item/rig/industrial
	req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 5)
	materials = list(MATERIAL_STEEL = 40000, MATERIAL_GLASS = 5000)
	id = "industrial_suit"
	time = 120

/datum/design/item/mechfab/hcm/eva
	category = "Hardsuit Control Modules"
	name = "EVA suit control module"
	build_path = /obj/item/rig/eva/unlocked
	req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 5)
	materials = list(MATERIAL_STEEL = 20000, MATERIAL_GLASS = 5000, MATERIAL_PLASTIC = 5000, MATERIAL_ALUMINIUM = 5000)
	id = "eva_suit"
	time = 120

/datum/design/item/mechfab/hcm/ce
	category = "Hardsuit Control Modules"
	name = "Advanced engineering suit control module"
	build_path = /obj/item/rig/ce/unlocked
	req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 8)
	materials = list(MATERIAL_STEEL = 30000, MATERIAL_GLASS = 5000, MATERIAL_ALUMINIUM = 10000, MATERIAL_SILVER = 1000, MATERIAL_GOLD = 1000)
	id = "ce_suit"
	time = 120

/datum/design/item/mechfab/hcm/hazmat
	category = "Hardsuit Control Modules"
	name = "Hazmat suit control module"
	build_path = /obj/item/rig/hazmat
	req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 5)
	materials = list(MATERIAL_STEEL = 20000, MATERIAL_GLASS = 5000, MATERIAL_PLASTIC = 5000, MATERIAL_ALUMINIUM = 5000, MATERIAL_SILVER = 1000, MATERIAL_GOLD = 1000)
	id = "hazmat_suit"
	time = 120

/datum/design/item/mechfab/hcm/medical
	category = "Hardsuit Control Modules"
	name = "Rescue suit control module"
	build_path = /obj/item/rig/medical/unlocked
	req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 5, TECH_BIO = 4)
	materials = list(MATERIAL_STEEL = 20000, MATERIAL_GLASS = 5000, MATERIAL_PLASTIC = 5000, MATERIAL_ALUMINIUM = 5000)
	id = "medical_suit"
	time = 120

/datum/design/item/mechfab/hcm/hazard
	category = "Hardsuit Control Modules"
	name = "Hazard suit control module"
	build_path = /obj/item/rig/hazard
	req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 5)
	materials = list(MATERIAL_STEEL = 20000, MATERIAL_GLASS = 5000, MATERIAL_PLASTIC = 5000, MATERIAL_ALUMINIUM = 5000, MATERIAL_SILVER = 1000, MATERIAL_GOLD = 1000)
	id = "hazard_suit"
	time = 120

/datum/design/mechfab/hcm/combat
	category = "Hardsuit Control Modules"
	name = "Combat rig control module"
	build_path = /obj/item/rig/combat
	req_tech = list(TECH_MATERIAL = 6, TECH_COMBAT = 9, TECH_ENGINEERING = 5)
	materials = list(MATERIAL_STEEL = 40000, MATERIAL_GLASS = 6000, MATERIAL_SILVER = 2000, MATERIAL_TITANIUM = 10000, MATERIAL_DIAMOND = 2000)
	id = "combat_suit"
	time = 120

/datum/design/mechfab/hcm/fleet
	category = "Hardsuit Control Modules"
	name = "Fleet rig control module"
	build_path = /obj/item/rig/ert/fleet/unlocked
	req_tech = list(TECH_MATERIAL = 6, TECH_COMBAT = 6, TECH_ENGINEERING = 5)
	materials = list(MATERIAL_STEEL = 40000, MATERIAL_GLASS = 6000, MATERIAL_SILVER = 2000, MATERIAL_TITANIUM = 5000, MATERIAL_DIAMOND = 2000)
	id = "fleet_suit"
	time = 120

/datum/design/mechfab/hcm/light
	category = "Hardsuit Control Modules"
	name = "Light rig control module"
	build_path = /obj/item/rig/light
	req_tech = list(TECH_MATERIAL = 4, TECH_COMBAT = 3, TECH_ENGINEERING = 3)
	materials = list(MATERIAL_STEEL = 10000, MATERIAL_PLASTIC = 6000, MATERIAL_ALUMINIUM = 6000, MATERIAL_SILVER = 1000)
	id = "light_suit"
	time = 120

/datum/design/mechfab/hcm/merc
	category = "Hardsuit Control Modules"
	name = "Crimson rig control module"
	build_path = /obj/item/rig/merc
	req_tech = list(TECH_MATERIAL = 6, TECH_COMBAT = 7, TECH_ENGINEERING = 5, TECH_ESOTERIC = 3)
	materials = list(MATERIAL_STEEL = 40000, MATERIAL_GLASS = 6000, MATERIAL_SILVER = 2000, MATERIAL_DIAMOND = 2000)
	id = "merc_suit"
	time = 120

/datum/design/mechfab/hcm/eod
	category = "Hardsuit Control Modules"
	name = "Heavy Crimson rig control module"
	build_path = /obj/item/rig/merc/heavy
	req_tech = list(TECH_MATERIAL = 6, TECH_COMBAT = 8, TECH_ENGINEERING = 5, TECH_ESOTERIC = 3)
	materials = list(MATERIAL_STEEL = 40000, MATERIAL_GLASS = 6000, MATERIAL_SILVER = 2000, MATERIAL_TITANIUM = 5000, MATERIAL_DIAMOND = 2000)
	id = "eod_suit"
	time = 120


/*
VOIDSUITS
*/

/datum/design/item/mechfab/voidsuit/eng
	category = "Voidsuits"
	name = "Engineering voidsuit"
	build_path = /obj/item/clothing/suit/space/void/engineering/alt/sol/prepared
	materials = list(MATERIAL_STEEL = 10000, MATERIAL_PLASTIC = 4000, MATERIAL_ALUMINIUM = 4000)
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	id = "void_eng"

/datum/design/item/mechfab/voidsuit/med
	category = "Voidsuits"
	name = "Medical voidsuit"
	build_path = /obj/item/clothing/suit/space/void/medical/alt/sol/prepared
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_PLASTIC = 10000, MATERIAL_ALUMINIUM = 4000)
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2, TECH_BIO = 2)
	id = "void_med"

/datum/design/item/mechfab/voidsuit/atmos
	category = "Voidsuits"
	name = "Atmos voidsuit"
	build_path = /obj/item/clothing/suit/space/void/atmos/alt/sol/prepared
	materials = list(MATERIAL_STEEL = 80000, MATERIAL_PLASTIC = 2000, MATERIAL_ALUMINIUM = 10000)
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	id = "void_atmos"

/datum/design/item/mechfab/voidsuit/sec
	category = "Voidsuits"
	name = "Riot voidsuit"
	build_path = /obj/item/clothing/suit/space/void/security/alt/prepared
	materials = list(MATERIAL_STEEL = 15000, MATERIAL_PLASTIC = 2000, MATERIAL_ALUMINIUM = 4000)
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2, TECH_COMBAT = 3)
	id = "void_sec"

/datum/design/item/mechfab/voidsuit/merc
	category = "Voidsuits"
	name = "Crimson voidsuit"
	build_path = /obj/item/clothing/suit/space/void/merc/prepared
	materials = list(MATERIAL_STEEL = 15000, MATERIAL_PLASTIC = 2000, MATERIAL_ALUMINIUM = 4000)
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2, TECH_COMBAT = 3, TECH_ESOTERIC = 2)
	id = "void_merc"

/datum/design/item/mechfab/voidsuit/mining
	category = "Voidsuits"
	name = "Mining voidsuit"
	build_path = /obj/item/clothing/suit/space/void/mining/prepared
	materials = list(MATERIAL_STEEL = 10000, MATERIAL_PLASTIC = 4000, MATERIAL_ALUMINIUM = 4000)
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	id = "void_mining"

/datum/design/item/mechfab/voidsuit/excavation
	category = "Voidsuits"
	name = "Excavation voidsuit"
	build_path = /obj/item/clothing/suit/space/void/excavation/prepared
	materials = list(MATERIAL_STEEL = 10000, MATERIAL_PLASTIC = 4000, MATERIAL_ALUMINIUM = 4000)
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	id = "void_excavation"

/datum/design/item/mechfab/voidsuit/exploration
	category = "Voidsuits"
	name = "Exploration voidsuit"
	build_path = /obj/item/clothing/suit/space/void/exploration/prepared
	materials = list(MATERIAL_STEEL = 10000, MATERIAL_PLASTIC = 4000, MATERIAL_ALUMINIUM = 4000)
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	id = "void_exploration"

/datum/design/item/mechfab/voidsuit/com
	category = "Voidsuits"
	name = "Officer voidsuit"
	build_path = /obj/item/clothing/suit/space/void/command/prepared
	materials = list(MATERIAL_STEEL = 12000, MATERIAL_PLASTIC = 2000, MATERIAL_ALUMINIUM = 4000)
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2, TECH_COMBAT = 2)
	id = "void_com"
