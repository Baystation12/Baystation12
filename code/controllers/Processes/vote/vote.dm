var/datum/controller/process/vote/new_vote = new()

/datum/controller/process/vote
	var/list/votes = list()
	var/list/presets_
	var/list/windows_per_ckey = list()

/datum/controller/process/vote/setup()
	name = "vote"
	schedule_interval = 10 // every second

/datum/controller/process/vote/doWork()
	vote.process()

/client/verb/debug_vote()
	new_vote.new_vote()

/datum/controller/process/vote/proc/new_vote()
	if(!usr)
		return

	var/datum/vote/window/window = get_window(usr.ckey)
	window.interact(usr)
	window.ui_interact(usr)
	window.tg_ui_interact(usr)

/datum/controller/process/vote/proc/get_window(var/ckey)
	. = windows_per_ckey[ckey]
	if(!.)
		. = new /datum/vote/window()
		windows_per_ckey[ckey] = .

/datum/controller/process/vote/proc/get_presets()
	if(!presets_)
		presets_ = list()
		for(var/preset in subtypesof(/datum/vote/preset))
			dd_insertObjectList(presets_, new preset())
	return presets_

/datum/controller/process/vote/proc/get_votes()
	if(!votes.len)
		/*
			DEBUG
		*/
		var /datum/vote/setup/setup1 = new/datum/vote/setup()
		var /datum/vote/setup/setup2 = new/datum/vote/setup()
		var /datum/vote/setup/setup3 = new/datum/vote/setup()
		var /datum/vote/setup/setup4 = new/datum/vote/setup()
		var /datum/vote/setup/setup5 = new/datum/vote/setup()
		var /datum/vote/setup/setup6 = new/datum/vote/setup()
		var /datum/vote/setup/setup7 = new/datum/vote/setup()

		setup1.description = "One"
		setup1.status = 1
		setup1.vote_progress = new/datum/vote/progress(setup1)
		setup2.description = "Two"
		setup2.status = 2
		setup3.description = "Three"
		setup3.status = 3
		setup4.description = "Four"
		setup4.status = 4
		setup5.description = "Five"
		setup5.status = 5
		setup6.description = "Six"
		setup6.status = 6
		setup7.description = "Seven"
		setup7.status = 7

		votes += setup1
		votes += setup2
		votes += setup3
		votes += setup4
		votes += setup5
		votes += setup6
		votes += setup7

	return votes

/datum/vote
	var/description
	var/datum/vote/setup/vote_setup

/datum/vote/New(var/vote_setup)
	src.vote_setup = vote_setup

/datum/vote/dd_SortValue()
	return description

/datum/vote/CanUseTopic()
	return STATUS_INTERACTIVE
