/datum/gear/augment/glare_dampeners/allowed_roles = TECHNICAL_ROLES

/datum/gear/augment/hud_health/allowed_roles = MEDICAL_ROLES

/datum/gear/augment/hud_security/allowed_roles = SECURITY_ROLES

/datum/gear/augment/hud_janitor/allowed_roles = SERVICE_ROLES

/datum/gear/augment/hud_science/New()
	allowed_roles = RESEARCH_ROLES | EXPLORATION_ROLES
	..()
