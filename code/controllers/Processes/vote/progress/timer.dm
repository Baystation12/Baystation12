/*
* Time limited voting
*/
/datum/vote/progress/timer
	description = "Timer"
	var/vote_duration = min_vote_duration
	var/vote_began_at
	var/const/min_vote_duration = 30

/datum/vote/progress/timer/setup_may_proceed()
	return vote_duration >= min_vote_duration

/datum/vote/progress/timer/vote_initiated()
	..()
	vote_began_at = world.time

/datum/vote/progress/timer/has_vote_concluded()
	return world.time > vote_began_at + vote_duration SECONDS

/datum/vote/progress/timer/status()
	if(!vote_began_at)
		return "Time Left: &infin;"
	if(world.time > vote_began_at + vote_duration)
		return "Time remaining: 00:00"
	return "Time Left: [(vote_began_at+vote_duration) - world.time] second\s"

/datum/vote/progress/timer/configuration()
	return list("Duration: [vote_duration] seconds\s" = "set_duration")

/datum/vote/progress/timer/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["set_duration"])
		var/new_duration = input("Set vote duration in seconds. Cannot set it to less than [min_vote_duration] second\s.", "Vote Setup", vote_duration) as null|num
		if(new_duration >= min_vote_duration && CanUseTopic(usr))
			vote_duration = new_duration
		return 1
