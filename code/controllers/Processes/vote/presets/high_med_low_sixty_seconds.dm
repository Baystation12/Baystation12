/*
	A 60 second high-med-low vote with no restrictions or effects.
*/
/datum/vote/preset/high_med_low_sixty_seconds
	description = "60 Second Vote - High/Medium/Low"
	vote_method = /datum/vote/method/high_med_low
	vote_progress = /datum/vote/progress/timer

/datum/vote/preset/simple_sixty_seconds/post_build(var/datum/vote/setup/setup)
	var/datum/vote/progress/timer/vote_timer = setup.vote_progress
	vote_timer.vote_duration = 60
