/datum/gear/eyes/sciencegoggles
	allowed_roles = STERILE_ROLES

/datum/gear/eyes/security
	allowed_roles = SECURITY_ROLES

/datum/gear/eyes/medical/New()
  allowed_roles = MEDICAL_ROLES + /datum/job/explorer_medic
  ..()
/datum/gear/eyes/meson
	allowed_roles = list(/datum/job/senior_engineer, /datum/job/engineer, /datum/job/mining, /datum/job/scientist_assistant,   /datum/job/rd,/datum/job/senior_scientist, /datum/job/scientist, /datum/job/chief_engineer,/datum/job/engineer_trainee,/datum/job/exploration_leader, /datum/job/explorer, /datum/job/explorer_pilot,/datum/job/explorer_medic, /datum/job/explorer_engineer, /datum/job/qm)

/datum/gear/eyes/material
	allowed_roles = TECHNICAL_ROLES
