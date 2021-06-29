/datum/gear/augment/glare_dampeners
	allowed_roles = TECHNICAL_ROLES

/datum/gear/augment/integrated_health_hud
	allowed_roles = MEDICAL_ROLES

/datum/gear/augment/integrated_security_hud
	allowed_roles = SECURITY_ROLES

/datum/gear/augment/integrated_janitor_hud
	allowed_roles = list(/datum/job/janitor)

/datum/gear/augment/integrated_science_hud/New()
	allowed_roles = RESEARCH_ROLES | EXPLORATION_ROLES
	..()
