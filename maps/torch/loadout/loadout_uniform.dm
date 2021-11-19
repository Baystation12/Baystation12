
/datum/gear/uniform
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/uniform/utility
	display_name = "Contractor Utility Uniform"
	path = /obj/item/clothing/under/solgov/utility

/datum/gear/uniform/shortjumpskirt
	allowed_roles = CASUAL_ROLES

/datum/gear/uniform/blackjumpshorts
	allowed_roles = CASUAL_ROLES

/datum/gear/uniform/roboticist_skirt
	allowed_roles = list(/datum/job/roboticist)

/datum/gear/uniform/suit
	allowed_roles = SEMIANDFORMAL_ROLES

/datum/gear/uniform/scrubs
	allowed_roles = STERILE_ROLES
	allowed_branches = null

/datum/gear/uniform/dress
	allowed_roles = FORMAL_ROLES

/datum/gear/uniform/cheongsam
	allowed_roles = FORMAL_ROLES

/datum/gear/uniform/abaya
	allowed_roles = FORMAL_ROLES

/datum/gear/uniform/skirt
	allowed_roles = SEMIANDFORMAL_ROLES

/datum/gear/uniform/skirt_c
	allowed_roles = SEMIANDFORMAL_ROLES

/datum/gear/uniform/skirt_c/dress
	allowed_roles = FORMAL_ROLES

/datum/gear/uniform/casual_pants
	allowed_roles = SEMIFORMAL_ROLES

/datum/gear/uniform/formal_pants
	allowed_roles = SEMIANDFORMAL_ROLES

//from infinity
/datum/gear/uniform/formal_shirt_and_pants
	display_name = "formal shirts with pants"
	allowed_roles = SEMIANDFORMAL_ROLES
	path = /obj/item/clothing/under/suit_jacket

/datum/gear/uniform/formal_shirt_and_pants/New()
	..()
	var/list/shirts = list()
	shirts += /obj/item/clothing/under/suit_jacket/charcoal/no_accessories
	shirts += /obj/item/clothing/under/suit_jacket/navy/no_accessories
	shirts += /obj/item/clothing/under/suit_jacket/burgundy/no_accessories
	shirts += /obj/item/clothing/under/suit_jacket/checkered/no_accessories
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(shirts)

/datum/gear/uniform/formal_pants/custom
	allowed_roles = SEMIANDFORMAL_ROLES

/datum/gear/uniform/formal_pants/baggycustom
	allowed_roles = SEMIANDFORMAL_ROLES

/datum/gear/uniform/shorts
	allowed_roles = CASUAL_ROLES

/datum/gear/uniform/shorts/custom
	allowed_roles = CASUAL_ROLES

/datum/gear/uniform/turtleneck
	allowed_roles = SEMIFORMAL_ROLES

/datum/gear/tactical/tacticool
	allowed_roles = CASUAL_ROLES

/datum/gear/uniform/sterile
	allowed_roles = MEDICAL_ROLES

/datum/gear/uniform/hazard
	allowed_roles = ENGINEERING_ROLES

/datum/gear/uniform/corp_overalls
	allowed_roles = list(/datum/job/mining, /datum/job/scientist_assistant)

/datum/gear/uniform/corp_flight
	allowed_roles = list(/datum/job/nt_pilot)

/datum/gear/uniform/corp_exec
	allowed_roles = list(/datum/job/liaison)

/datum/gear/uniform/corp_exec_jacket
	allowed_roles = list(/datum/job/liaison)
