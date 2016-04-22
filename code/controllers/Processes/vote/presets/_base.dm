/datum/vote/preset
	var/list/datum/vote/effect/vote_effects = list()
	var/list/datum/vote/restriction/vote_restrictions = list()
	var/datum/vote/progress/vote_progress
	var/datum/vote/method/vote_method

/datum/vote/preset/proc/build()
	var/datum/vote/setup/setup = new()
	for(var/effect in vote_effects)
		setup.vote_effects += new effect(setup)
	for(var/restriction in vote_restrictions)
		setup.vote_restrictions = new restriction(setup)
	setup.vote_progress = new vote_progress(setup)
	setup.vote_method = new vote_method(setup)

	post_build(setup)
	return setup

/datum/vote/preset/proc/post_build(var/datum/vote/setup/setup)
	return
