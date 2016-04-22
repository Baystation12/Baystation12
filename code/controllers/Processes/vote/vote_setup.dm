#define VOTE_HAS_BEEN_INITIATED 1
#define VOTE_HAS_BEEN_CONCLUDED 2
#define VOTE_HAS_BEEN_CANCELED 4

/datum/vote/setup
	var/mode = 0
	var/status = 0
	var/list/datum/vote/restriction/vote_restrictions
	var/list/datum/vote/effect/vote_effects
	var/datum/vote/progress/vote_progress
	var/datum/vote/method/vote_method

/datum/vote/setup/New()
	..(src)
	vote_restrictions = list()
	vote_effects = list()

/datum/vote/setup/ui_data()
	return list()

/datum/vote/setup/proc/initiate_vote()
	status |= VOTE_HAS_BEEN_INITIATED
	vote_progress.vote_initiated()
	for(var/effect in vote_effects)
		var/datum/vote/effect/vote_effect = effect
		vote_effect.vote_initiated()

/datum/vote/setup/proc/has_vote_initiated()
	return status & VOTE_HAS_BEEN_INITIATED

/datum/vote/setup/proc/has_vote_concluded()
	if(status & VOTE_HAS_BEEN_CONCLUDED)
		return TRUE
	if(!vote_progress.has_vote_concluded())
		return FALSE

	status |= VOTE_HAS_BEEN_CONCLUDED
	for(var/effect in vote_effects)
		var/datum/vote/effect/vote_effect = effect
		vote_effect.vote_concluded()
	return TRUE

/datum/vote/setup/proc/is_user_restricted(var/mob/user)
	for(var/vr in vote_setup.vote_restrictions)
		var/datum/vote/restriction/vote_restriction = vr
		if(!vote_restriction.may_vote(user))
			return FALSE
	return TRUE

/datum/vote/setup/proc/status()
	if(status & VOTE_HAS_BEEN_CANCELED)
		return "Cancelled"
	if(status & VOTE_HAS_BEEN_CONCLUDED)
		return "Concluded"
	return vote_progress ? vote_progress.status() : "ERROR: Bad setup."

#undef VOTE_HAS_BEEN_INITIATED
#undef VOTE_HAS_BEEN_CONCLUDED
#undef VOTE_HAS_BEEN_CANCELED
