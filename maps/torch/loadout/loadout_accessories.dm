/datum/gear/accessory/solawardmajor
	display_name = "SolGov major award selection"
	description = "A medal or ribbon awarded to SolGov personnel for significant accomplishments."
	path = /obj/item/clothing/accessory
	cost = 8
	allowed_branches = SOLGOV_BRANCHES

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
	allowed_branches = SOLGOV_BRANCHES

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
	custom_setup_proc = /obj/item/clothing/accessory/badge/solgov/tags/proc/loadout_setup

/datum/gear/accessory/ec_scarf
	display_name = "Expeditionary Corps scarf"
	path = /obj/item/clothing/accessory/solgov/ec_scarf
	description = "A section-specific scarf for Expeditionary Corps uniforms."
	flags = GEAR_HAS_TYPE_SELECTION
	allowed_branches = list(/datum/mil_branch/expeditionary_corps)

/datum/gear/accessory/ec_patch
	display_name = "Expeditionary Corps patch"
	path = /obj/item/clothing/accessory/solgov/ec_patch
	description = "A shoulder patch representing the Expeditionary Corps."
	flags = GEAR_HAS_TYPE_SELECTION
	allowed_branches = list(/datum/mil_branch/expeditionary_corps)

/datum/gear/accessory/torch_patch
	display_name = "Torch mission patch"
	path = /obj/item/clothing/accessory/solgov/torch_patch
	description = "A shoulder patch representing the SEV Torch and its mission. Given to all the oddjobs pulled from various branches to work on the Torch."

/datum/gear/accessory/pilot_pin
	display_name = "pilot's qualification pin"
	path = /obj/item/clothing/accessory/solgov/specialty/pilot
	allowed_skills = list(SKILL_PILOT = SKILL_ADEPT)
	allowed_branches = list(
		/datum/mil_branch/fleet,
		/datum/mil_branch/expeditionary_corps
	)

/datum/gear/accessory/fleetpatch
	display_name = "fleet patch"
	path = /obj/item/clothing/accessory/solgov/fleet_patch
	flags = GEAR_HAS_TYPE_SELECTION
	allowed_branches = list(/datum/mil_branch/fleet)

/datum/gear/accessory/armband_ma
	display_name = "master at arms brassard"
	path = /obj/item/clothing/accessory/armband/solgov/ma
	allowed_roles = SECURITY_ROLES

/datum/gear/accessory/armband_security
	allowed_roles = SECURITY_ROLES

/datum/gear/accessory/armband_cargo
	allowed_roles = SUPPLY_ROLES

/datum/gear/accessory/armband_medical
	allowed_roles = MEDICAL_ROLES

/datum/gear/accessory/armband_emt
	allowed_roles = list(/datum/job/doctor, /datum/job/medical_trainee)

/datum/gear/accessory/armband_corpsman
	display_name = "medical armband"
	path = /obj/item/clothing/accessory/armband/medblue
	allowed_roles = list(/datum/job/cmo, /datum/job/senior_doctor, /datum/job/junior_doctor, /datum/job/doctor, /datum/job/medical_trainee)

/datum/gear/accessory/armband_engineering
	allowed_roles = ENGINEERING_ROLES

/datum/gear/accessory/armband_hydro
	allowed_roles = list(/datum/job/rd, /datum/job/scientist, /datum/job/scientist_assistant, /datum/job/assistant)

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
	allowed_roles = list(/datum/job/pathfinder, /datum/job/explorer)


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
	allowed_roles = list(/datum/job/assistant)

/datum/gear/tactical/helm_covers
	allowed_roles = ARMORED_ROLES

/datum/gear/clothing/hawaii
	allowed_roles = SEMIFORMAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/clothing/scarf

/datum/gear/clothing/flannel
	allowed_roles = SEMIFORMAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

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
	allowed_branches = list(/datum/mil_branch/expeditionary_corps, /datum/mil_branch/civilian)

/datum/gear/tactical/ubac/blue
	display_name = "navy blue UBAC shirt"
	path = /obj/item/clothing/accessory/ubac/blue
	allowed_branches = list(/datum/mil_branch/fleet)

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
	allowed_branches = list(/datum/mil_branch/fleet, /datum/mil_branch/civilian)

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
	allowed_branches = list(/datum/mil_branch/fleet, /datum/mil_branch/civilian)

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
