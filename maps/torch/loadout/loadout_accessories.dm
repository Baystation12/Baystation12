/datum/gear/accessory/solgov_award_military
	display_name = "SolGov military award selection"
	description = "A selection of military awards awarded by the Sol Central Government."
	path = /obj/item/clothing/accessory/medal/solgov/mil
	cost = 8
	allowed_branches = SOLGOV_BRANCHES
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/accessory/solgov_award_military/New()
	..()
	var/solmilitary = list()
	solmilitary["Bronze Heart"] = /obj/item/clothing/accessory/medal/solgov/mil/bronze_heart
	solmilitary["Home Guard medal"] = /obj/item/clothing/accessory/medal/solgov/mil/home_guard
	solmilitary["Iron Star"] = /obj/item/clothing/accessory/medal/solgov/mil/iron_star
	solmilitary["Armed Forces medal"] = /obj/item/clothing/accessory/medal/solgov/mil/armed_forces
	solmilitary["Silver Sword"] = /obj/item/clothing/accessory/medal/solgov/mil/silver_sword
	solmilitary["Superior Service Cross"] = /obj/item/clothing/accessory/medal/solgov/mil/service_cross
	solmilitary["Medal of Honor"] = /obj/item/clothing/accessory/medal/solgov/mil/medal_of_honor
	gear_tweaks += new/datum/gear_tweak/path(solmilitary)

/datum/gear/accessory/solgov_award_civilian
	display_name = "SolGov civilian award selection"
	description = "A selection of civilian awards awarded by the Sol Central Government."
	path = /obj/item/clothing/accessory/medal/solgov/civ
	cost = 5
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/accessory/solgov_award_civilian/New()
	..()
	var/solcivilian = list()
	solcivilian["Expeditionary Medal"] = /obj/item/clothing/accessory/medal/solgov/civ/expeditionary
	solcivilian["Sapientarian Peace Award"] = /obj/item/clothing/accessory/medal/solgov/civ/sapientarian
	solcivilian["Distinguished Service Medal"] = /obj/item/clothing/accessory/medal/solgov/civ/service
	gear_tweaks += new/datum/gear_tweak/path(solcivilian)

/datum/gear/accessory/solgov_award_ribbons
	display_name = "SolGov ribbon selection"
	description = "A selection of decorations and medal ribbons awarded by the Sol Central Government."
	path = /obj/item/clothing/accessory/ribbon/solgov
	cost = 3
	allowed_branches = SOLGOV_BRANCHES
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/accessory/solgov_award_ribbons/New()
	..()
	var/solribbons = list()
	solribbons["Marksmanship ribbon"] = /obj/item/clothing/accessory/ribbon/solgov/marksman
	solribbons["Peacekeeping ribbon"] = /obj/item/clothing/accessory/ribbon/solgov/peace
	solribbons["Frontier ribbon"] = /obj/item/clothing/accessory/ribbon/solgov/frontier
	solribbons["Instructor ribbon"] = /obj/item/clothing/accessory/ribbon/solgov/instructor
	solribbons["Combat Action ribbon"] = /obj/item/clothing/accessory/ribbon/solgov/combat
	solribbons["Gaia Conflict ribbon"] = /obj/item/clothing/accessory/ribbon/solgov/gaiaconflict
	solribbons["Distinguished unit ribbon"] = /obj/item/clothing/accessory/ribbon/solgov/distinguished_unit
	//medal ribbons
	solribbons["Bronze Heart ribbon (medal)"] = /obj/item/clothing/accessory/ribbon/solgov/medal/bronze_heart
	solribbons["Home Guard ribbon (medal)"] = /obj/item/clothing/accessory/ribbon/solgov/medal/home_guard
	solribbons["Iron Star ribbon (medal)"] = /obj/item/clothing/accessory/ribbon/solgov/medal/iron_star
	solribbons["Armed Forces ribbon (medal)"] = /obj/item/clothing/accessory/ribbon/solgov/medal/armed_forces
	solribbons["Silver Sword ribbon (medal)"] = /obj/item/clothing/accessory/ribbon/solgov/medal/silver_sword
	solribbons["Superior Service ribbon (medal)"] = /obj/item/clothing/accessory/ribbon/solgov/medal/service_cross
	solribbons["Medal of Honor ribbon (medal)"] = /obj/item/clothing/accessory/ribbon/solgov/medal/medal_of_honor
	solribbons["Expeditionary Ribbon (medal)"] = /obj/item/clothing/accessory/ribbon/solgov/medal/expeditionary_medal
	solribbons["Sapientarian ribbon (medal)"] = /obj/item/clothing/accessory/ribbon/solgov/medal/sapientarian
	solribbons["Distinguished Service ribbon (medal)"] = /obj/item/clothing/accessory/ribbon/solgov/medal/service
	solribbons["Combat Medical ribbon (medal)"] = /obj/item/clothing/accessory/ribbon/solgov/medal/medical
	gear_tweaks += new/datum/gear_tweak/path(solribbons)

/datum/gear/accessory/tags
	display_name = "dog tags"
	path = /obj/item/clothing/accessory/badge/solgov/tags
	custom_setup_proc = /obj/item/clothing/accessory/badge/solgov/tags/proc/loadout_setup

/datum/gear/accessory/tags/iccgn
	display_name = "ICCGN dog tags"
	path = /obj/item/clothing/accessory/badge/solgov/tags/iccgn
	custom_setup_proc = /obj/item/clothing/accessory/badge/solgov/tags/proc/loadout_setup
	allowed_branches = list(/datum/mil_branch/expeditionary_corps, /datum/mil_branch/solgov, /datum/mil_branch/civilian)

/datum/gear/accessory/ec_scarf
	display_name = "Expeditionary Corps scarf"
	path = /obj/item/clothing/accessory/solgov/ec_scarf
	description = "A section-specific scarf for Expeditionary Corps uniforms."
	flags = GEAR_HAS_TYPE_SELECTION | GEAR_HAS_NO_CUSTOMIZATION
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps
	)

/datum/gear/accessory/ec_patch
	display_name = "Expeditionary Corps patch"
	path = /obj/item/clothing/accessory/solgov/ec_patch
	description = "A shoulder patch representing the Expeditionary Corps."
	flags = GEAR_HAS_TYPE_SELECTION | GEAR_HAS_NO_CUSTOMIZATION
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps
	)

/datum/gear/accessory/torch_patch
	display_name = "Torch mission patch"
	path = /obj/item/clothing/accessory/solgov/torch_patch
	description = "A shoulder patch representing the SEV Torch and its mission. Given to all the oddjobs pulled from various branches to work on the Torch."
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/accessory/pilot_pin
	display_name = "pilot's qualification pin"
	path = /obj/item/clothing/accessory/solgov/specialty/pilot
	flags = GEAR_HAS_NO_CUSTOMIZATION
	allowed_skills = list(
		SKILL_PILOT = SKILL_ADEPT
	)
	allowed_branches = list(
		/datum/mil_branch/fleet,
		/datum/mil_branch/expeditionary_corps
	)

/datum/gear/accessory/fleetpatch
	display_name = "fleet patch"
	path = /obj/item/clothing/accessory/solgov/fleet_patch
	flags = GEAR_HAS_TYPE_SELECTION | GEAR_HAS_NO_CUSTOMIZATION
	allowed_branches = list(
		/datum/mil_branch/fleet
	)

/datum/gear/accessory/armband_ma
	display_name = "master at arms brassard"
	path = /obj/item/clothing/accessory/armband/solgov/ma
	allowed_roles = SECURITY_ROLES
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/accessory/armband_security
	allowed_roles = SECURITY_ROLES

/datum/gear/accessory/armband_cargo
	allowed_roles = SUPPLY_ROLES

/datum/gear/accessory/armband_medical
	allowed_roles = MEDICAL_ROLES

/datum/gear/accessory/armband_emt
	allowed_roles = list(
		/datum/job/doctor,
		/datum/job/medical_trainee
	)
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/accessory/armband_corpsman
	display_name = "medical armband"
	path = /obj/item/clothing/accessory/armband/medblue
	allowed_roles = list(
		/datum/job/cmo,
		/datum/job/senior_doctor,
		/datum/job/junior_doctor,
		/datum/job/doctor,
		/datum/job/medical_trainee
	)
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/accessory/armband_engineering
	allowed_roles = ENGINEERING_ROLES

/datum/gear/accessory/armband_hydro
	allowed_roles = list(
		/datum/job/rd,
		/datum/job/scientist,
		/datum/job/scientist_assistant,
		/datum/job/assistant
	)
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/accessory/armband_nt
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/accessory/ntaward
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/accessory/tie
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/accessory/tie_color
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/accessory/neckerchief

/datum/gear/accessory/stethoscope
	allowed_roles = STERILE_ROLES

/datum/gear/tactical/holster
	allowed_roles = ARMED_ROLES

/datum/gear/tactical/holster/New()
	..()
	var/holsters = list()
	holsters["shoulder holster"] = /obj/item/clothing/accessory/storage/holster
	holsters["armpit holster"] = /obj/item/clothing/accessory/storage/holster/armpit
	holsters["waist holster"] = /obj/item/clothing/accessory/storage/holster/waist
	holsters["hip holster"] = /obj/item/clothing/accessory/storage/holster/hip
	holsters["thigh holster"] = /obj/item/clothing/accessory/storage/holster/thigh
	gear_tweaks += new/datum/gear_tweak/path(holsters)

/datum/gear/tactical/sheath
	allowed_roles = list(
		/datum/job/pathfinder,
		/datum/job/explorer)


/datum/gear/tactical/bloodpatch
	display_name = "blood patch selection"
	path = /obj/item/clothing/accessory/armor_tag
	allowed_roles = ARMORED_ROLES

/datum/gear/tactical/bloodpatch/New()
	..()
	var/blatch = list()
	blatch["O+ blood patch"] = /obj/item/clothing/accessory/armor_tag/opos
	blatch["O- blood patch"] = /obj/item/clothing/accessory/armor_tag/oneg
	blatch["A+ blood patch"] = /obj/item/clothing/accessory/armor_tag/apos
	blatch["A- blood patch"] = /obj/item/clothing/accessory/armor_tag/aneg
	blatch["B+ blood patch"] = /obj/item/clothing/accessory/armor_tag/bpos
	blatch["B- blood patch"] = /obj/item/clothing/accessory/armor_tag/bneg
	blatch["AB+ blood patch"] = /obj/item/clothing/accessory/armor_tag/abpos
	blatch["AB- blood patch"] = /obj/item/clothing/accessory/armor_tag/abneg
	gear_tweaks += new/datum/gear_tweak/path(blatch)

/datum/gear/tactical/armor_deco
	display_name = "armor tags selection"
	path = /obj/item/clothing/accessory/armor_tag
	allowed_roles = ARMORED_ROLES

/datum/gear/tactical/armor_deco/New()
	..()
	var/atags = list()
	atags["NTSF tag"] = /obj/item/clothing/accessory/armor_tag/nt
	atags["PCRC tag"] = /obj/item/clothing/accessory/armor_tag/pcrc
	atags["SAARE tag"] = /obj/item/clothing/accessory/armor_tag/saare
	atags["MEDIC tag"] = /obj/item/clothing/accessory/armor_tag/solgov/medic
	atags["SFP AGENT tag"] = /obj/item/clothing/accessory/armor_tag/solgov/agent
	atags["SCG tag"] = /obj/item/clothing/accessory/armor_tag/solgov/com
	atags["POLICE tag"] = /obj/item/clothing/accessory/armor_tag/solgov/com/sec
	atags["Expeditionary Corps crest"] = /obj/item/clothing/accessory/armor_tag/solgov/ec
	atags["SCG Flag"] = /obj/item/clothing/accessory/armor_tag/solgov
	gear_tweaks += new/datum/gear_tweak/path(atags)

/datum/gear/tactical/press_tag
	display_name = "Press tag"
	path = /obj/item/clothing/accessory/armor_tag/press
	allowed_roles = list(
		/datum/job/assistant
	)
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/tactical/helm_covers
	allowed_roles = ARMORED_ROLES

/datum/gear/clothing/hawaii
	allowed_roles = SEMIFORMAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/clothing/scarf

/datum/gear/clothing/flannel
	allowed_roles = SEMIFORMAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/clothing/cloak_custom // common cloak
	display_name = "cloak, colorable"
	path = /obj/item/clothing/accessory/cloak
	flags = GEAR_HAS_COLOR_SELECTION
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/clothing/cloak_cargo // departaments cloaks
	display_name = "cloak, cargo"
	path = /obj/item/clothing/accessory/cloak/cargo
	allowed_branches = CIVILIAN_BRANCHES
	allowed_roles = SUPPLY_ROLES

/datum/gear/clothing/cloak_mining
	display_name = "cloak, mining"
	path = /obj/item/clothing/accessory/cloak/mining
	allowed_roles = list(/datum/job/mining)

/datum/gear/clothing/cloak_security
	display_name = "cloak, security"
	path = /obj/item/clothing/accessory/cloak/security
	allowed_branches = CIVILIAN_BRANCHES
	allowed_roles = SECURITY_ROLES

/datum/gear/clothing/cloak_service
	display_name = "cloak, service"
	path = /obj/item/clothing/accessory/cloak/service
	allowed_branches = CIVILIAN_BRANCHES
	allowed_roles = SERVICE_ROLES

/datum/gear/clothing/cloak_engineer
	display_name = "cloak, engineer"
	path = /obj/item/clothing/accessory/cloak/engineer
	allowed_branches = CIVILIAN_BRANCHES
	allowed_roles = ENGINEERING_ROLES

/datum/gear/clothing/cloak_atmos
	display_name = "cloak, atmos"
	path = /obj/item/clothing/accessory/cloak/atmos
	allowed_branches = CIVILIAN_BRANCHES
	allowed_roles = ENGINEERING_ROLES

/datum/gear/clothing/cloak_research
	display_name = "cloak, science"
	path = /obj/item/clothing/accessory/cloak/research
	allowed_branches = CIVILIAN_BRANCHES
	allowed_roles = RESEARCH_ROLES

/datum/gear/clothing/cloak_medical
	display_name = "cloak, medical"
	path = /obj/item/clothing/accessory/cloak/medical
	allowed_branches = CIVILIAN_BRANCHES
	allowed_roles = MEDICAL_ROLES

/datum/gear/clothing/vest
	allowed_roles = FORMAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/clothing/suspenders
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/clothing/suspenders/colorable
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/clothing/wcoat
	allowed_roles = FORMAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/clothing/zhongshan
	allowed_roles = FORMAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/clothing/dashiki
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/clothing/thawb
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/clothing/sherwani
	allowed_roles = FORMAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/clothing/qipao
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/clothing/sweater
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/clothing/tangzhuang
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/accessory/bowtie
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/accessory/ftu_pin
	allowed_branches = CIVILIAN_BRANCHES

/*********************
 tactical accessories
*********************/
/datum/gear/tactical/ubac
	display_name = "black UBAC shirt"
	path = /obj/item/clothing/accessory/ubac
	allowed_roles = ARMORED_ROLES
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/civilian
	)

/datum/gear/tactical/ubac/blue
	display_name = "navy blue UBAC shirt"
	path = /obj/item/clothing/accessory/ubac/blue
	allowed_branches = list(
		/datum/mil_branch/fleet
	)
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/tactical/ubac/misc
	display_name = "miscellaneous UBAC shirt selection"
	path = /obj/item/clothing/accessory/ubac
	allowed_branches = list(/datum/mil_branch/army, /datum/mil_branch/civilian)

/datum/gear/tactical/ubac/misc/New()
	..()
	var/shirts = list()
	shirts["green UBAC shirt"] = /obj/item/clothing/accessory/ubac/green
	shirts["tan UBAC shirt"] = /obj/item/clothing/accessory/ubac/tan
	gear_tweaks += new/datum/gear_tweak/path(shirts)

/datum/gear/tactical/armor_pouches
	display_name = "black armor pouches"
	path = /obj/item/clothing/accessory/storage/pouches
	cost = 2
	allowed_roles = ARMORED_ROLES

/datum/gear/tactical/armor_pouches/navy
	display_name = "navy armor pouches"
	path = /obj/item/clothing/accessory/storage/pouches/navy
	allowed_branches = list(
		/datum/mil_branch/fleet,
		/datum/mil_branch/civilian
	)
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/tactical/armor_pouches/misc
	display_name = "miscellaneous armor pouches selection"
	path = /obj/item/clothing/accessory/storage/pouches
	allowed_branches = list(/datum/mil_branch/army, /datum/mil_branch/civilian)

/datum/gear/tactical/armor_pouches/misc/New()
	..()
	var/pouches = list()
	pouches["green armor pouches"] = /obj/item/clothing/accessory/storage/pouches/green
	pouches["tan armor pouches"] = /obj/item/clothing/accessory/storage/pouches/tan
	gear_tweaks += new/datum/gear_tweak/path(pouches)

/datum/gear/tactical/large_pouches
	display_name = "black large armor pouches"
	path = /obj/item/clothing/accessory/storage/pouches/large
	cost = 5
	allowed_roles = ARMORED_ROLES

/datum/gear/tactical/large_pouches/navy
	display_name = "navy large armor pouches"
	path = /obj/item/clothing/accessory/storage/pouches/large/navy
	allowed_branches = list(
		/datum/mil_branch/fleet,
		/datum/mil_branch/civilian
	)
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/tactical/large_pouches/misc
	display_name = "miscellaneous large armor pouches selection"
	path = /obj/item/clothing/accessory/storage/pouches/large
	allowed_branches = list(/datum/mil_branch/army, /datum/mil_branch/civilian)

/datum/gear/tactical/large_pouches/misc/New()
	..()
	var/pouches = list()
	pouches["green large armor pouches"] = /obj/item/clothing/accessory/storage/pouches/large/green
	pouches["tan large armor pouches"] = /obj/item/clothing/accessory/storage/pouches/large/tan
	gear_tweaks += new/datum/gear_tweak/path(pouches)
