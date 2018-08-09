
/datum/gear/uniform/utility
	display_name = "Contractor Utility Uniform"
	path = /obj/item/clothing/under/solgov/utility

/datum/gear/uniform/jumpsuit
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/uniform/jumpsuit_f
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/uniform/shortjumpskirt
	allowed_roles = RESTRICTED_ROLES

/datum/gear/uniform/blackjumpshorts
	allowed_roles = RESTRICTED_ROLES

/datum/gear/uniform/roboticist_skirt
	allowed_roles = list(/datum/job/roboticist)

/datum/gear/uniform/suit
	allowed_roles = FORMAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/uniform/scrubs
	allowed_roles = STERILE_ROLES

/datum/gear/uniform/dress
	allowed_roles = FORMAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/uniform/cheongsam
	allowed_roles = FORMAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/uniform/abaya
	allowed_roles = FORMAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/uniform/skirt
	allowed_roles = FORMAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/uniform/skirt_c
	allowed_roles = FORMAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/uniform/skirt_c/dress
	allowed_roles = FORMAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/uniform/casual_pants
	allowed_roles = SEMIFORMAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/uniform/formal_pants
	allowed_roles = FORMAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/uniform/formal_pants/custom
	allowed_roles = FORMAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/uniform/formal_pants/baggycustom
	allowed_roles = FORMAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/uniform/shorts
	allowed_roles = RESTRICTED_ROLES

/datum/gear/uniform/shorts/custom
	allowed_roles = FORMAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/uniform/turtleneck
	allowed_roles = FORMAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/tactical/tacticool
	allowed_roles = RESTRICTED_ROLES

/datum/gear/uniform/corporate
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/uniform/sterile
	allowed_roles = MEDICAL_ROLES

/datum/gear/uniform/hazard
	allowed_roles = ENGINEERING_ROLES

/datum/gear/uniform/utility
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/uniform/frontier
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/uniform/yamakari
	display_name = "yamakari jumpsuit"
	path = /obj/item/clothing/under/yamakari
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/uniform/yamakari/sec
	display_name = "yamakari jumpsuit, security"
	path = /obj/item/clothing/under/yamakari/security
	allowed_roles = list(/datum/job/detective, /datum/job/guard)

/datum/gear/uniform/yamakari/eng
	display_name = "yamakari jumpsuit, engineering"
	path = /obj/item/clothing/under/yamakari/engineering
	allowed_roles = list(/datum/job/engineer_contractor, /datum/job/roboticist)

/datum/gear/uniform/yamakari/med
	display_name = "yamakari jumpsuit, medical"
	path = /obj/item/clothing/under/yamakari/medical
	allowed_roles = list(/datum/job/doctor_contractor, /datum/job/psychiatrist, /datum/job/roboticist)

/datum/gear/uniform/yamakari/sci
	display_name = "yamakari jumpsuit, science"
	path = /obj/item/clothing/under/yamakari/science
	allowed_roles = NANOTRASEN_ROLES