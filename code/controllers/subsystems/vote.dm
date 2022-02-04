SUBSYSTEM_DEF(vote)
	name = "Voting"
	wait = 1 SECOND
	priority = SS_PRIORITY_VOTE
	flags = SS_NO_TICK_CHECK | SS_KEEP_TIMING
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/last_started_time        //To enforce delay between votes.
	var/antag_added              //Enforces a maximum of one added antag per round.

	var/datum/vote/active_vote   //The current vote. This handles most voting activity.
	var/list/old_votes           //Stores completed votes for reference.
	var/queued_auto_vote         //Used if a vote queues another vote to happen after it.

	var/list/voting = list()     //Clients recieving UI updates.
	var/list/vote_prototypes     //To run checks on whether they are available.

/datum/controller/subsystem/vote/Initialize()
	vote_prototypes = list()
	for(var/vote_type in subtypesof(/datum/vote))
		var/datum/vote/fake_vote = vote_type
		if(initial(fake_vote.manual_allowed))
			vote_prototypes[vote_type] = new vote_type
	return ..()

/datum/controller/subsystem/vote/fire(resumed = 0)
	if(!active_vote)
		if(queued_auto_vote)
			initiate_vote(queued_auto_vote, automatic = 1)
			queued_auto_vote = null
		return

	switch(active_vote.Process())
		if(VOTE_PROCESS_ABORT)
			QDEL_NULL(active_vote)
			reset()
			return
		if(VOTE_PROCESS_COMPLETE)
			active_vote.tally_result()      // Does math to figure out who won. Data is stored on the vote datum.
			active_vote.report_result()     // Announces the result; possibly alerts other entities of the result.
			LAZYADD(old_votes, active_vote) // Store the datum for future reference.
			reset()
			return
		if(VOTE_PROCESS_ONGOING)
			for(var/client/C in voting)
				show_panel(C.mob)

/datum/controller/subsystem/vote/stat_entry(text, force)
	IF_UPDATE_STAT
		force = TRUE
		text = "[text] | Vote: [active_vote ? "[active_vote.name], [active_vote.time_remaining]" : "None"]"
	..(text, force)

/datum/controller/subsystem/vote/Recover()
	last_started_time = SSvote.last_started_time
	antag_added = SSvote.antag_added
	active_vote = SSvote.active_vote
	queued_auto_vote = SSvote.queued_auto_vote

/datum/controller/subsystem/vote/proc/reset()
	active_vote = null
	for(var/client/C in voting)
		close_panel(C.mob)
	voting.Cut()

//A false return means that a vote couldn't be started.
/datum/controller/subsystem/vote/proc/initiate_vote(vote_type, mob/creator, automatic = 0)
	if(active_vote)
		return FALSE
	if(!automatic && (!istype(creator) || !creator.client))
		return FALSE

	if(last_started_time != null && !(isadmin(creator) || automatic))
		var/next_allowed_time = (last_started_time + config.vote_delay)
		if(next_allowed_time > world.time)
			return FALSE

	var/datum/vote/new_vote = new vote_type
	if(!new_vote.setup(creator, automatic))
		return FALSE

	active_vote = new_vote
	last_started_time = world.time
	return TRUE

/datum/controller/subsystem/vote/proc/interface(client/C)
	if(!C)
		return
	var/admin = isadmin(C)
	voting |= C

	. = list()
	. += "<html><meta charset=\"UTF-8\"><head><title>Voting Panel</title></head><body>"
	if(active_vote)
		. += active_vote.interface(C.mob)
		if(admin)
			. += "(<a href='?src=\ref[src];cancel=1'>Cancel Vote</a>) "
	else
		. += "<h2>Start a vote:</h2><hr><ul>"
		for(var/vote_type in vote_prototypes)
			var/datum/vote/vote_datum = vote_prototypes[vote_type]
			. += "<li><a href='?src=\ref[src];vote=\ref[vote_datum.type]'>"
			if(vote_datum.can_run(C.mob))
				. += "[capitalize(vote_datum.name)]"
			else
				. += "<font color='grey'>[capitalize(vote_datum.name)] (Disallowed)</font>"
			. += "</a>"
			var/toggle = vote_datum.check_toggle()
			if(admin && toggle)
				. += "\t(<a href='?src=\ref[src];toggle=1;vote=\ref[vote_datum.type]'>toggle; currently [toggle]</a>)"
			. += "</li>"
		. += "</ul><hr>"

	. += "<a href='?src=\ref[src];close=1' style='position:absolute;right:50px'>Close</a></body></html>"
	return JOINTEXT(.)

/datum/controller/subsystem/vote/proc/show_panel(mob/user)
	var/win_x = 450
	var/win_y = 740
	if(active_vote)
		win_x = active_vote.win_x
		win_y = active_vote.win_y
	show_browser(user, interface(user.client),"window=vote;size=[win_x]x[win_y]")
	onclose(user, "vote", src)

/datum/controller/subsystem/vote/proc/close_panel(mob/user)
	show_browser(user, null, "window=vote")
	if(user)
		voting -= user.client

/datum/controller/subsystem/vote/proc/cancel_vote(mob/user)
	if(!isadmin(user))
		return
	active_vote.report_result() // Will not make announcement, but do any override failure reporting tasks.
	QDEL_NULL(active_vote)
	reset()

/datum/controller/subsystem/vote/Topic(href,href_list[],hsrc)
	if(!usr || !usr.client)
		return	//not necessary but meh...just in-case somebody does something stupid

	if(href_list["vote_panel"])
		show_panel(usr)
		return
	if(href_list["cancel"])
		cancel_vote(usr)
		return
	if(href_list["close"])
		close_panel(usr)
		return

	if(href_list["vote"])
		var/vote_path = locate(href_list["vote"])
		if(!ispath(vote_path, /datum/vote))
			return

		if(href_list["toggle"])
			var/datum/vote/vote_datum = vote_prototypes[vote_path]
			if(!vote_datum)
				return
			vote_datum.toggle(usr)
			show_panel(usr)
			return

		initiate_vote(vote_path, usr, 0) // Additional permission checking happens in here.

//Helper for certain votes.
/datum/controller/subsystem/vote/proc/restart_world()
	set waitfor = FALSE

	to_world("World restarting due to vote...")
	sleep(50)
	log_game("Rebooting due to restart vote")
	world.Reboot()

// Helper proc for determining whether addantag vote can be called.
/datum/controller/subsystem/vote/proc/is_addantag_allowed(mob/creator, automatic)
	if(!config.allow_extra_antags)
		return 0
	// Gamemode has to be determined before we can add antagonists, so we can respect gamemode's add antag vote settings.
	if((GAME_STATE <= RUNLEVEL_SETUP) || !SSticker.mode)
		return 0
	if(automatic)
		return (SSticker.mode.addantag_allowed & ADDANTAG_AUTO) && !antag_added
	if(isadmin(creator))
		return SSticker.mode.addantag_allowed & (ADDANTAG_ADMIN|ADDANTAG_PLAYER)
	else
		return (SSticker.mode.addantag_allowed & ADDANTAG_PLAYER) && !antag_added

/mob/verb/vote()
	set category = "OOC"
	set name = "Vote"

	if(GAME_STATE < RUNLEVEL_LOBBY)
		to_chat(src, "It's too soon to do any voting!")
		return
	SSvote.show_panel(src)
