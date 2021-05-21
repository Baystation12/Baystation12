
/datum/vote/proc/can_initiate_vote(var/initiator, var/automatic = 0)

	if(active)
		return "Vote '[name]' already running."

	if(world.time > config.vote_delay && world.time < (GLOB.last_player_vote + config.vote_delay))
		if(!check_rights(R_ADMIN) && !automatic)
			return "Too soon to call vote '[name]'"

	if(!choices.len)
		return "No valid choices for '[name]' vote"

	return 0

/datum/vote/proc/initiate_vote(var/initiator_key, var/automatic = 0)

	if(!update_question() || !question)
		return "No valid question"

	. = can_initiate_vote(initiator, automatic)

	if(.)
		return .

	GLOB.last_player_vote = world.time

	initiator = initiator_key
	started_time = world.time
	var/announce_text = get_announce_text(automatic, initiator)
	log_vote(announce_text)
	announce_vote(announce_text)

	vote.vote_start(src)

	time_remaining = round(config.vote_period)

	GLOB.processing_objects.Add(src)
	last_process = world.time
	active = 1

	return 0

/datum/vote/proc/get_announce_text(var/automatic, var/initiator)
	var/text = "[capitalize(name)] vote started by [initiator][automatic ? " (automatic)" : ""]."
	return text

/datum/vote/proc/announce_vote(var/announce_text)
	to_world("<font color='purple'><b>[announce_text]</b>\nType <b>vote</b> or click <a href='?src=\ref[src];view_vote=1'>here</a> to place your votes.\nYou have [config.vote_period/10] seconds to vote.</font>")
	to_world(sound(announce_ogg, repeat = 0, wait = 0, volume = 50, channel = 3))

/datum/vote/proc/update_question()
	question = "Place your vote for [name]"
	return 1
