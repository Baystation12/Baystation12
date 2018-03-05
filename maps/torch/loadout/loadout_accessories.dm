/datum/gear/tactical/ubac
	display_name = "ubac selection"
	path = /obj/item/clothing/accessory/ubac
	allowed_roles = MILITARY_ROLES
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/accessory/solawardmajor
	display_name = "SolGov major award selection"
	description = "A medal or ribbon awarded to SolGov personnel for significant accomplishments."
	path = /obj/item/clothing/accessory
	cost = 8
	allowed_roles = SOLGOV_ROLES

/datum/gear/accessory/solawardmajor/New()
	..()
	var/solmajors = list()
	solmajors["iron star"] = /obj/item/clothing/accessory/medal/solgov/iron/star
	solmajors["bronze heart"] = /obj/item/clothing/accessory/medal/solgov/bronze/heart
	solmajors["silver sword"] = /obj/item/clothing/accessory/medal/solgov/silver/sword
	solmajors["medical heart"] = /obj/item/clothing/accessory/medal/solgov/heart
	solmajors["valor medal"] = /obj/item/clothing/accessory/medal/solgov/silver/sol
	solmajors["sapienterian medal"] = /obj/item/clothing/accessory/medal/solgov/gold/sol
	solmajors["peacekeeper ribbon"] = /obj/item/clothing/accessory/ribbon/solgov/peace
	solmajors["marksman ribbon"] = /obj/item/clothing/accessory/ribbon/solgov/marksman
	gear_tweaks += new/datum/gear_tweak/path(solmajors)

/datum/gear/accessory/solawardminor
	display_name = "SolGov minor award selection"
	description = "A medal or ribbon awarded to SolGov personnel for minor accomplishments."
	path = /obj/item/clothing/accessory
	cost = 5
	allowed_roles = SOLGOV_ROLES

/datum/gear/accessory/solawardminor/New()
	..()
	var/solminors = list()
	solminors["expeditionary medal"] = /obj/item/clothing/accessory/medal/solgov/iron/sol
	solminors["operations medal"] = /obj/item/clothing/accessory/medal/solgov/bronze/sol
	solminors["frontier ribbon"] = /obj/item/clothing/accessory/ribbon/solgov/frontier
	solminors["instructor ribbon"] = /obj/item/clothing/accessory/ribbon/solgov/instructor
	gear_tweaks += new/datum/gear_tweak/path(solminors)

/datum/gear/accessory/tags
	display_name = "dog tags"
	path = /obj/item/clothing/accessory/badge/solgov/tags
	allowed_roles = MILITARY_ROLES

/datum/gear/accessory/torch_patch
	display_name = "Torch mission patch"
	path = /obj/item/clothing/accessory/solgov/torch_patch

/datum/gear/accessory/pilot_pin
	display_name = "pilot's qualification pin"
	path = /obj/item/clothing/accessory/solgov/speciality/pilot
	allowed_roles = list(/datum/job/captain, /datum/job/hop, /datum/job/bridgeofficer, /datum/job/pathfinder)

/datum/gear/accessory/fleetpatch
	display_name = "fleet patch"
	path = /obj/item/clothing/accessory/solgov/fleet_patch
	flags = GEAR_HAS_TYPE_SELECTION
	allowed_roles = MILITARY_ROLES

/datum/gear/accessory/armband_mp
	display_name = "military police brassard"
	path = /obj/item/clothing/accessory/armband/solgov/mp
	allowed_roles = SECURITY_ROLES

/datum/gear/accessory/armband_ma
	display_name = "master at arms brassard"
	path = /obj/item/clothing/accessory/armband/solgov/ma
	allowed_roles = SECURITY_ROLES

/datum/gear/accessory/armband_solgov
	display_name = "peacekeeper armband"
	path = /obj/item/clothing/accessory/armband/bluegold
	allowed_roles = SOLGOV_ROLES

/datum/gear/accessory/armband_security
	allowed_roles = SECURITY_ROLES

/datum/gear/accessory/armband_cargo
	allowed_roles = SUPPLY_ROLES

/datum/gear/accessory/armband_medical
	allowed_roles = MEDICAL_ROLES

/datum/gear/accessory/armband_emt
	allowed_roles = list(/datum/job/doctor, /datum/job/doctor_contractor)

/datum/gear/accessory/armband_corpsman
	display_name = "medical corps armband"
	path = /obj/item/clothing/accessory/armband/medblue
	allowed_roles = list(/datum/job/cmo, /datum/job/senior_doctor, /datum/job/doctor)

/datum/gear/accessory/armband_engineering
	allowed_roles = ENGINEERING_ROLES

/datum/gear/accessory/armband_hydro
	allowed_roles = list(/datum/job/rd, /datum/job/scientist, /datum/job/scientist_assistant, /datum/job/assistant)

/datum/gear/accessory/armband_nt
	allowed_roles = list(/datum/job/rd, /datum/job/liaison, /datum/job/senior_scientist, /datum/job/nt_pilot, /datum/job/scientist,
						/datum/job/mining, /datum/job/guard, /datum/job/scientist_assistant,
						/datum/job/roboticist, /datum/job/engineer_contractor,
						/datum/job/psychiatrist, /datum/job/doctor_contractor, /datum/job/chemist,
						/datum/job/cargo_contractor, /datum/job/janitor, /datum/job/chef, /datum/job/bartender)
					
/datum/gear/accessory/ntaward
	allowed_roles = NANOTRASEN_ROLES

/datum/gear/accessory/tie
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/accessory/tie_color
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/accessory/stethoscope
	allowed_roles = STERILE_ROLES

/datum/gear/storage/brown_vest
	allowed_roles = list(/datum/job/chief_engineer, /datum/job/senior_engineer, /datum/job/engineer, /datum/job/engineer_contractor, /datum/job/roboticist, /datum/job/qm, /datum/job/cargo_tech,
						/datum/job/cargo_contractor, /datum/job/mining, /datum/job/janitor, /datum/job/scientist_assistant, /datum/job/merchant, /datum/job/nt_pilot)

/datum/gear/storage/black_vest
	allowed_roles = list(/datum/job/hos, /datum/job/warden, /datum/job/detective, /datum/job/officer, /datum/job/guard, /datum/job/merchant)

/datum/gear/storage/white_vest
	allowed_roles = list(/datum/job/cmo, /datum/job/senior_doctor, /datum/job/doctor, /datum/job/doctor_contractor, /datum/job/merchant)

/datum/gear/storage/brown_drop_pouches
	allowed_roles = list(/datum/job/chief_engineer, /datum/job/senior_engineer, /datum/job/engineer, /datum/job/engineer_contractor, /datum/job/roboticist, /datum/job/qm, /datum/job/cargo_tech,
						/datum/job/cargo_contractor, /datum/job/mining, /datum/job/janitor, /datum/job/scientist_assistant, /datum/job/merchant)

/datum/gear/storage/black_drop_pouches
	allowed_roles = list(/datum/job/hos, /datum/job/warden, /datum/job/detective, /datum/job/officer, /datum/job/guard, /datum/job/merchant)

/datum/gear/storage/white_drop_pouches
	allowed_roles = list(/datum/job/cmo, /datum/job/senior_doctor, /datum/job/doctor, /datum/job/doctor_contractor, /datum/job/merchant)

/datum/gear/tactical/holster
	allowed_roles = ARMED_ROLES

/datum/gear/tactical/large_pouches
	allowed_roles = ARMORED_ROLES

/datum/gear/tactical/armor_deco
	allowed_roles = ARMORED_ROLES

/datum/gear/tactical/helm_covers
	allowed_roles = ARMORED_ROLES

/datum/gear/clothing/hawaii
	allowed_roles = SEMIFORMAL_ROLES

/datum/gear/clothing/scarf
	allowed_roles = SEMIANDFORMAL_ROLES

/datum/gear/clothing/flannel
	allowed_roles = SEMIFORMAL_ROLES

/datum/gear/clothing/vest
	allowed_roles = FORMAL_ROLES

/datum/gear/clothing/suspenders
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/clothing/wcoat
	allowed_roles = FORMAL_ROLES

/datum/gear/clothing/zhongshan
	allowed_roles = FORMAL_ROLES

/datum/gear/clothing/dashiki
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/clothing/thawb
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/clothing/sherwani
	allowed_roles = FORMAL_ROLES

/datum/gear/clothing/qipao
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/clothing/sweater
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/clothing/tangzhuang
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/accessory/bowtie
	allowed_roles = NON_MILITARY_ROLES