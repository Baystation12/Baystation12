//Makes sure we don't get any merchant antags as a balance concern. Can also be used for future Torch specific antag restrictions.
/datum/antagonist/changeling
	blacklisted_jobs = list(/datum/job/ai, /datum/job/cyborg, /datum/job/merchant, /datum/job/captain, /datum/job/hop)

/datum/antagonist/godcultist
	blacklisted_jobs = list(/datum/job/ai, /datum/job/cyborg, /datum/job/chaplain, /datum/job/merchant, /datum/job/captain, /datum/job/hop, /datum/job/hos)

/datum/antagonist/cultist
	blacklisted_jobs = list(/datum/job/ai, /datum/job/cyborg, /datum/job/chaplain, /datum/job/psychiatrist, /datum/job/merchant, /datum/job/captain, /datum/job/hop, /datum/job/hos)

/datum/antagonist/loyalists
	blacklisted_jobs = list(/datum/job/ai, /datum/job/cyborg, /datum/job/merchant)

/datum/antagonist/revolutionary
	blacklisted_jobs = list(/datum/job/ai, /datum/job/cyborg, /datum/job/merchant)

/datum/antagonist/traitor
	blacklisted_jobs = list(/datum/job/merchant, /datum/job/captain, /datum/job/hop)