//Overriding loyalists and making them adminspawn only due to their imbalance
/datum/antagonist/revolutionary
	blacklisted_jobs = list(/datum/job/ai, /datum/job/cyborg, /datum/job/captain, /datum/job/hop, /datum/job/hos, /datum/job/chief_engineer, /datum/job/rd, /datum/job/cmo, /datum/job/lawyer)
	restricted_jobs = list(/datum/job/detective, /datum/job/officer, /datum/job/warden)

/datum/game_mode/revolution
	antag_tags = list(MODE_REVOLUTIONARY, MODE_MERCENARY)

/datum/game_mode/siege
	antag_tags = list(MODE_REVOLUTIONARY, MODE_MERCENARY)

/datum/game_mode/uprising
	antag_tags = list(MODE_REVOLUTIONARY, MODE_MERCENARY)
