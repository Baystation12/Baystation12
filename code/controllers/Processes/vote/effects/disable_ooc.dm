/*
* Disable OOC
*/
/datum/vote/effect/disable_ooc
	description = "Disable OOC"
	var/disabled_ooc

/datum/vote/effect/disable_ooc/vote_initiated()
	disabled_ooc = is_ooc_enabled()
	if(disabled_ooc)
		toggle_ooc()

/datum/vote/effect/disable_ooc/vote_concluded()
	if(disabled_ooc && is_ooc_enabled())
		toggle_ooc()
