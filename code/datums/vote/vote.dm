/datum/vote
	var/name = "default vote"
	var/initiator
	var/question
	var/list/choices = list()

	var/list/display_choices = list() // What's actually shown to the users.
	var/list/additional_text = list() // Stuff for UI formatting.
	var/additional_header
	var/list/priorities = list("First", "Second", "Third") // Should have the same length as weights below.

	var/start_time
	var/time_remaining
	var/status = VOTE_STATUS_PREVOTE

	var/list/result                // The results; format is list(choice = votes).
	var/results_length = 3         // How many choices to show in the result. Setting to -1 will show all choices.
	var/list/weights = list(3,2,1) // Controls how many things a person can vote for and how they will be weighed.
	var/list/voted = list()        // Format is list(ckey = list(a, b, ...)); a, b, ... are ordered by order of preference and are numbers, referring to the index in choices

	var/win_x = 450
	var/win_y = 740                // Vote window size.

	var/manual_allowed = 1         // Whether humans can start it.

//Expected to be run immediately after creation; a false return means that the vote could not be run and the datum will be deleted.
/datum/vote/proc/setup(mob/creator, automatic)
	if(!can_run(creator, automatic))
		qdel(src)
		return FALSE
	setup_vote(creator, automatic)
	if(!can_run(creator, automatic))
		qdel(src)
		return FALSE
	start_vote()
	return TRUE

//Checks any conditions required for the vote to run. The argument is optional, in case a player started the vote.
/datum/vote/proc/can_run(mob/creator, automatic)
	return TRUE

//Performs functions relating to setting up the question and choices, if relevant.
/datum/vote/proc/setup_vote(mob/creator, automatic)
	initiator = (!automatic && istype(creator)) ? creator.ckey : "the server"
	for(var/choice in choices)
		display_choices[choice] = choice // Default behavior is that the choice name is displayed directly.

/datum/vote/proc/start_vote()
	start_time = world.time
	status = VOTE_STATUS_ACTIVE
	time_remaining = round(config.vote_period/10)

	var/text = get_start_text()

	log_vote(text)
	to_world("<font color='purple'><b>[text]</b>\nType <b>vote</b> or click <a href='?src=\ref[SSvote];vote_panel=1'>here</a> to place your votes.\nYou have [config.vote_period/10] seconds to vote.</font>")
	to_world(sound('sound/ambience/alarm4.ogg', repeat = 0, wait = 0, volume = 50, channel = GLOB.vote_sound_channel))

/datum/vote/proc/get_start_text()
	return "[capitalize(name)] vote started by [initiator]."

//Modifies the vote totals based on non-voting mobs.
/datum/vote/proc/handle_default_votes()
	if(!config.vote_no_default)
		return length(GLOB.clients) - length(voted) //Number of non-voters (might not be active, though; should be revisited if the config option is used. This is legacy code.)

/datum/vote/proc/tally_result()
	handle_default_votes()
	result = choices.Copy()
	shuffle(result) //This looks idiotic, but it will randomize the order in which winners are picked in the event of ties.
	sortTim(result, /proc/cmp_numeric_dsc, 1)
	if(length(result) > results_length)
		result.Cut(results_length + 1, 0)

// Truthy return indicates that either no one voted or there was another error.
/datum/vote/proc/report_result()
	if(!length(result))
		return 1

	var/text = get_result_announcement()
	log_vote(text)
	to_world("<font color='purple'>[text]</font>")	

	if(!(result[result[1]] > 0))
		return 1

/datum/vote/proc/get_result_announcement()
	var/list/text = list()
	if(!(result[result[1]] > 0)) // No one voted.
		text += "<b>Vote Result: Inconclusive - No Votes!</b>"
	else
		text += "<b>Vote Result: [display_choices[result[1]]]</b>"
		if(length(result) >= 2)
			text += "\nSecond place: [display_choices[result[2]]]"
		if(length(result) >= 3)
			text += ", third place: [display_choices[result[3]]]"

	return JOINTEXT(text)

// False return means vote was not changed for whatever reason.
/datum/vote/proc/submit_vote(var/mob/voter, var/vote, var/priority)
	if(mob_not_participating(voter))
		return
	if(vote && (vote in 1 to length(choices)) && priority && (priority in 1 to length(weights)))
		var/ckey = voter.ckey
		if(!voted[ckey]) //No vote yet; set up and vote.
			voted[ckey] = new /list(length(weights))
			voted[ckey][priority] = vote
			choices[choices[vote]] += weights[priority]
			return 1
		var/old_choice = voted[ckey][priority]
		if(old_choice == vote)
			return //OK, voted for the same thing again.
		if(old_choice)
			choices[choices[old_choice]] -= weights[priority] //Remove the old vote.
		for(var/i in 1 to length(weights)) //Look if we voted for this option before at a different priority
			if(voted[ckey][i] == vote)
				choices[choices[vote]] -= weights[i]
				voted[ckey][i] = null
		voted[ckey][priority] = vote  // Record our vote.
		choices[choices[vote]] += weights[priority]
		return 1

// Checks if the mob is participating in the round sufficiently to vote, as per config settings.
/datum/vote/proc/mob_not_participating(mob/voter)
	if(config.vote_no_dead && voter.stat == DEAD && !voter.client.holder)
		return 1

//null = no toggle set. This is for UI purposes; a text return will give a link (toggle; currently "return") in the vote panel.
/datum/vote/proc/check_toggle()

//Called when toggle is hit.
/datum/vote/proc/toggle(mob/user)

//Will be run by the SS while the vote is running.
/datum/vote/Process()
	if(status == VOTE_STATUS_ACTIVE)
		if(time_remaining > 0)
			time_remaining = round((start_time + config.vote_period - world.time)/10)
			return VOTE_PROCESS_ONGOING
		else
			status = VOTE_STATUS_COMPLETE
			return VOTE_PROCESS_COMPLETE
	return VOTE_PROCESS_ABORT

/datum/vote/proc/interface(mob/user)
	. = list()
	if(mob_not_participating(user))
		. += "<h2>You can't participate in this vote unless you're participating in the round.</h2><br>"
		return
	if(question)
		. += "<h2>Vote: '[question]'</h2>"
	else
		. += "<h2>Vote: [capitalize(name)]</h2>"
	. += "Time Left: [time_remaining] s<hr>"
	. += "<table width = '100%'><tr><td align = 'center'><b>Choices</b></td><td colspan='3' align = 'center'><b>Votex</b></td><td align = 'center'><b>Votes</b></td>"
	. += additional_header

	var/totalvotes = 0
	for(var/i = 1, i <= choices.len, i++)
		totalvotes += choices[choices[i]]

	for(var/j = 1, j <= choices.len, j++)
		var/choice = choices[j]
		var/number_of_votes = choices[choice] || 0
		var/votepercent = 0
		if(totalvotes)
			votepercent = round((number_of_votes/totalvotes)*100)

		. += "<tr><td>"
		. += "[display_choices[choice]]"
		. += "</td>"

		for(var/i = 1, i <= length(priorities), i++)
			. += "<td>"
			if(voted[user.ckey] && (voted[user.ckey][i] == j)) //We have this jth choice chosen at priority i.
				. += "<b><a href='?src=\ref[src];choice=[j];priority=[i]'>[priorities[i]]</a></b>"
			else
				. += "<a href='?src=\ref[src];choice=[j];priority=[i]'>[priorities[i]]</a>"
			. += "</td>"
		. += "</td><td align = 'center'>[votepercent]%</td>"
		if (additional_text[choice])
			. += "[additional_text[choice]]" //Note lack of cell wrapper, to allow for dynamic formatting.
		. += "</tr>"
	. += "</table><hr>"

/datum/vote/Topic(href, href_list, hsrc)
	var/mob/user = usr
	if(!istype(user) || !user.client)
		return

	var/choice = text2num(href_list["choice"])
	var/priority = text2num(href_list["priority"])
	if(!is_valid_index(choice, choices))
		return
	if(!is_valid_index(priority, weights))
		return // If the input was invalid, we don't continue recording the vote.

	submit_vote(user, choice, priority)