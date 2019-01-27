
/datum/vote/proc/process()
	// Calculate how much time is remaining by comparing current time, to time of vote start,
	// plus vote duration
	if(!delayed)
		time_remaining -= (world.time - last_process)
		last_process = world.time

		if(time_remaining < 0 && active)
			end_vote()

/datum/vote/proc/end_vote(var/end_early = 0)
	active = 0
	GLOB.processing_objects.Remove(src)

	vote.vote_finish(src)

	if(!end_early)
		do_result()

	reset()

	update_clients_browsing()
