// The random spawn proc on the antag datum will handle announcing the spawn and whatnot.
/datum/event/random_antag/announce()
	return

/datum/event/random_antag/start()
	if(vote && vote.is_addantag_allowed(0, 1))
		log_and_message_admins("Calling add antag vote as part of random event.")
		vote.initiate_vote("add_antagonist","the server", 2)
