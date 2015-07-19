/datum/mob_ai_state/proc/LostControl()
	walk(host, 0)	// Cease any potential move_to if we lost control

/datum/mob_ai_state/proc/Life(datum/mob_ai/ai)
	return

/datum/mob_ai_state/proc/Died(datum/mob_ai/ai)
	walk(host, 0)	// Cease any potential move_to if we died

/datum/mob_ai_state/proc/Death(datum/mob_ai/ai)
	return

/datum/mob_ai_state/proc/NextState()
	return src
