/datum/gear/accessory/tags
	display_name = "dog tags"
	path = /obj/item/clothing/accessory/badge/dog_tags

/datum/gear/accessory/pilot_pin
	display_name = "pilot's qualification pin"
	path = /obj/item/clothing/accessory/solgov/specialty/pilot
	// [INF]
	// allowed_roles = list(/datum/job/captain, /datum/job/hop, /datum/job/adjutant, /datum/job/exploration_leader, /datum/job/explorer_pilot)
	allowed_skills = list(SKILL_PILOT = SKILL_EXPERIENCED)
	// [INF/] by hacso

/datum/gear/accessory/armband_security
	allowed_roles = SECURITY_ROLES

/datum/gear/accessory/armband_cargo
	allowed_roles = SUPPLY_ROLES

/datum/gear/accessory/armband_medical
	allowed_roles = MEDICAL_ROLES

/datum/gear/accessory/armband_emt
	allowed_roles = list(/datum/job/doctor, /datum/job/doctor_trainee, /datum/job/explorer_medic)

/datum/gear/accessory/armband_engineering
	allowed_roles = ENGINEERING_ROLES

/datum/gear/accessory/armband_hydro
	allowed_roles = list(/datum/job/rd, /datum/job/senior_scientist, /datum/job/scientist, /datum/job/scientist_assistant, /datum/job/assistant)

/datum/gear/accessory/ntaward
	allowed_roles = NANOTRASEN_ROLES
	allowed_branches = list(/datum/mil_branch/employee)

/datum/gear/accessory/stethoscope
	allowed_roles = STERILE_ROLES

/datum/gear/passport/scg
	display_name = "passports selection - SCG"
	description = "A selection of SCG passports."
	path = /obj/item/passport/scg
	flags = GEAR_HAS_TYPE_SELECTION
	custom_setup_proc = /obj/item/passport/proc/set_info
	cost = 0

/datum/gear/passport/iccg
	display_name = "passports selection - ICCG"
	description = "A selection of ICCG passports."
	path = /obj/item/passport/iccg
	flags = GEAR_HAS_TYPE_SELECTION
	custom_setup_proc = /obj/item/passport/proc/set_info
	cost = 0

/datum/gear/passport
	display_name = "passports selection - independent"
	description = "A selection of independent regions passports."
	path = /obj/item/passport/independent
	flags = GEAR_HAS_SUBTYPE_SELECTION
	custom_setup_proc = /obj/item/passport/proc/set_info
	cost = 0

/datum/gear/utility/holster_belt
	display_name = "holser belt"
	path = /obj/item/storage/belt/holster/general
	allowed_roles = list(/datum/job/captain, /datum/job/hop, /datum/job/rd, /datum/job/cmo, /datum/job/chief_engineer, /datum/job/hos, /datum/job/iaa, /datum/job/adjutant)

/datum/gear/accessory/corpbadge
	display_name = "investigator holobadge (IAA)"
	path = /obj/item/clothing/accessory/badge/holo/investigator
	allowed_roles = list(/datum/job/iaa)
