/datum/gear/head/solberet
	display_name = "SolGov beret selection"
	description = "A beret denoting service in an organization within SolGov."
	path = /obj/item/clothing/head/beret
	allowed_branches = SOLGOV_BRANCHES
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/head/solberet/New()
	..()
	var/berets = list()
	berets["peacekeeper beret"] = /obj/item/clothing/head/beret/solgov
	berets["home guard beret"] = /obj/item/clothing/head/beret/solgov/homeguard
	berets["gateway administration beret"] = /obj/item/clothing/head/beret/solgov/gateway
	berets["customs and trade beret"] = /obj/item/clothing/head/beret/solgov/customs
	berets["government research beret"] = /obj/item/clothing/head/beret/solgov/research
	berets["health service beret"] = /obj/item/clothing/head/beret/solgov/health
	berets["border security beret"] = /obj/item/clothing/head/beret/solgov/borderguard
	gear_tweaks += new/datum/gear_tweak/path(berets)

/datum/gear/head/veteranhat
	display_name = "veteran hat"
	path = /obj/item/clothing/head/soft/solgov/veteranhat
	allowed_branches = CIVILIAN_BRANCHES
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/head/solhat
	display_name = "sol central government hat"
	path = /obj/item/clothing/head/soft/solgov
	allowed_branches = SOLGOV_BRANCHES
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/head/fleetcover
	display_name = "fleet utilty cover"
	path = /obj/item/clothing/head/solgov/utility/fleet
	cost = 0
	allowed_branches = list(
		/datum/mil_branch/fleet
	)
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/head/fleetcap
	display_name = "fleet cap"
	path = /obj/item/clothing/head/soft/solgov/fleet
	cost = 0
	allowed_branches = list(
		/datum/mil_branch/fleet
	)
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/head/echat
	display_name = "EC cap"
	path = /obj/item/clothing/head/soft/solgov/expedition
	cost = 0
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps
	)
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/head/surgical
	allowed_roles = STERILE_ROLES

/datum/gear/head/beret
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/sterile_mask
	display_name = "sterile mask"
	path = /obj/item/clothing/mask/surgical

/datum/gear/head/beanie
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/head/bow
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/head/cap
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/head/hairflower
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/head/hardhat
	allowed_roles = TECHNICAL_ROLES

/datum/gear/head/formalhat
	allowed_roles = FORMAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/head/informalhat
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/head/welding
	allowed_roles = TECHNICAL_ROLES

/datum/gear/tactical/balaclava
	allowed_roles = SECURITY_ROLES

/datum/gear/head/fleetberet
	display_name = "Fleet branch beret selection"
	description = "A beret denoting service in one of the fleets within the SCG Fleet."
	path = /obj/item/clothing/head/beret/solgov/fleet/branch
	allowed_branches = list(
		/datum/mil_branch/fleet
	)
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/head/fleetberet/New()
	..()
	var/berets = list()
	berets["first fleet beret"] = /obj/item/clothing/head/beret/solgov/fleet/branch
	berets["second fleet beret"] = /obj/item/clothing/head/beret/solgov/fleet/branch/second
	berets["third fleet beret"] = /obj/item/clothing/head/beret/solgov/fleet/branch/third
	berets["fourth fleet beret"] = /obj/item/clothing/head/beret/solgov/fleet/branch/fourth
	berets["fifth fleet beret"] = /obj/item/clothing/head/beret/solgov/fleet/branch/fifth
	gear_tweaks += new/datum/gear_tweak/path(berets)

/datum/gear/head/ECberet
	display_name = "EC sections beret selection"
	description = "A beret denoting service in one of the branches within the SCG EC."
	path = /obj/item/clothing/head/beret/solgov/expedition/branch
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps
		)
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/head/ECberet/New()
	..()
	var/berets = list()
	berets["field operation beret"] = /obj/item/clothing/head/beret/solgov/expedition/branch
	berets["observatory beret"] = /obj/item/clothing/head/beret/solgov/expedition/branch/observatory
	gear_tweaks += new/datum/gear_tweak/path(berets)

/datum/gear/head/corporateberet
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/head/deckcrew
	allowed_roles = SUPPLY_ROLES


/datum/gear/tactical/armor_tag_flag
	display_name = "Armor Tag Selection - Flags"
	path = /obj/item/clothing/accessory/armor_tag


/datum/gear/tactical/armor_tag_flag/New()
	..()
	var/list/options = list()
	options["SCG flag"] = /obj/item/clothing/accessory/armor_tag/solgov
	options["EC flag"] = /obj/item/clothing/accessory/armor_tag/solgov/ec
	options["Fleet flag"] =  /obj/item/clothing/accessory/armor_tag/solgov/fleet
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/tactical/armor_tag_blood
	display_name = "Armor Tag Selection - Blood Type"
	path = /obj/item/clothing/accessory/armor_tag


/datum/gear/tactical/armor_tag_blood/New()
	..()
	var/list/options = list()
	options["O+ blood patch"] = /obj/item/clothing/accessory/armor_tag/opos
	options["O- blood patch"] = /obj/item/clothing/accessory/armor_tag/oneg
	options["A+ blood patch"] = /obj/item/clothing/accessory/armor_tag/apos
	options["A- blood patch"] = /obj/item/clothing/accessory/armor_tag/aneg
	options["AB+ blood patch"] = /obj/item/clothing/accessory/armor_tag/abpos
	options["AB- blood patch"] = /obj/item/clothing/accessory/armor_tag/abneg
	options["B+ blood patch"] = /obj/item/clothing/accessory/armor_tag/bpos
	options["B- blood patch"] = /obj/item/clothing/accessory/armor_tag/bneg
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/tactical/armor_tag_corporate
	display_name = "Armor Tag Selection - Corporate Insignia"
	path = /obj/item/clothing/accessory/armor_tag


/datum/gear/tactical/armor_tag_corporate/New()
	..()
	var/list/options = list()
	options["SAARE tag"] = /obj/item/clothing/accessory/armor_tag/saare
	options["PCRC tag"] =  /obj/item/clothing/accessory/armor_tag/pcrc
	gear_tweaks += new /datum/gear_tweak/path (options)
