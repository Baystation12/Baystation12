/datum/gear/eyes/science/New()
	allowed_roles = RESEARCH_ROLES | EXPLORATION_ROLES
	..()


/datum/gear/eyes/security/allowed_roles = SECURITY_ROLES


/datum/gear/eyes/medical/allowed_roles = MEDICAL_ROLES


/datum/gear/eyes/meson/New()
	allowed_roles = TECHNICAL_ROLES | EXPLORATION_ROLES
	..()


/datum/gear/eyes/janitor/allowed_roles = SERVICE_ROLES


/datum/gear/eyes/aviators_shutter/allowed_branches = CIVILIAN_BRANCHES


/datum/gear/eyes/welding/allowed_roles = TECHNICAL_ROLES


/datum/gear/eyes/material/New()
	allowed_roles = TECHNICAL_ROLES | EXPLORATION_ROLES
	..()


/datum/gear/eyes/monocle/allowed_branches = CIVILIAN_BRANCHES


/datum/gear/eyes/blindfold/allowed_branches = CIVILIAN_BRANCHES
