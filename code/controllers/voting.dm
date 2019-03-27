var/datum/controller/subsystem/vote/vote
GLOBAL_LIST_EMPTY(voting)

#define VOTE_INACTIVE 0
#define VOTE_ACTIVE 1
#define VOTE_FINISH 2

SUBSYSTEM_DEF(vote)
	name = "Voting"
	flags = SS_NO_FIRE

	var/mode = null
	var/auto_muted = 0
	var/list/active_votes = list()
	var/list/inactive_votes = list()
	var/list/all_votes = list()
	var/list/active_votes_ui = list()

	var/list/voting = list()

/datum/controller/subsystem/vote/New()
	if(vote != src)
		if(istype(vote))
			qdel(vote)
		vote = src

/datum/controller/subsystem/vote/proc/autotransfer()
	//initiate_vote("crew_transfer","the server", 1)
	//call_vote("crew_transfer")
	call_vote("end_round_early")		//a generic replacement

/datum/controller/subsystem/vote/proc/autogamemode()
	//initiate_vote("gamemode","the server", 1)
	call_vote("gamemode")

/datum/controller/subsystem/vote/proc/automap()
	//initiate_vote("map","the server", 1)
	call_vote("mapswitch")

/datum/controller/subsystem/vote/proc/autoaddantag()
	//auto_add_antag = 1
	//initiate_vote("add_antagonist","the server", 1)
	call_vote("autoaddantag")

/datum/controller/subsystem/vote/proc/call_vote(var/vote_name)

	var/datum/vote/curvote = all_votes[vote_name]
	if(curvote)
		var/result = curvote.initiate_vote("the server", 1)
		if(result)
			log_debug(result)
	else
		log_debug("ERROR: The server attempted to call nonexistent vote: '[vote_name]'.")

/datum/controller/subsystem/vote/proc/time_remaining(var/vote_id)
	log_debug("datum/controller/subsystem/vote/proc/time_remaining([vote_id])")

/datum/controller/subsystem/vote/New()
	. = ..()
	for(var/curtype in typesof(/datum/vote) - /datum/vote)
		var/datum/vote/curvote = new curtype()
		all_votes[curvote.name] = curvote
		if(!curvote.hidden && !curvote.round_start_hidden)
			inactive_votes.Add(curvote)

/datum/controller/subsystem/vote/Initialize()
	. = ..()

	for(var/votename in all_votes)
		var/datum/vote/curvote = all_votes[votename]
		curvote.Initialize()

// Helper proc for determining whether addantag vote can be called.
/datum/controller/subsystem/vote/proc/is_addantag_allowed(var/automatic)
	// Gamemode has to be determined before we can add antagonists, so we can respect gamemode's add antag vote settings.
	if(!ticker || (ticker.current_state <= 2) || !ticker.mode)
		return 0
	if(automatic)
		return (ticker.mode.addantag_allowed & ADDANTAG_AUTO) && !antag_add_finished
	if(check_rights(R_ADMIN, 0))
		return ticker.mode.addantag_allowed & (ADDANTAG_ADMIN|ADDANTAG_PLAYER)
	else
		return (ticker.mode.addantag_allowed & ADDANTAG_PLAYER) && !antag_add_finished

/datum/controller/subsystem/vote/proc/process()
	for(var/datum/vote/curvote in active_votes)
		curvote.process()

/datum/controller/subsystem/vote/proc/vote_start(var/datum/vote/curvote)
	inactive_votes -= curvote
	active_votes += curvote

	update_clients_browsing()

/datum/controller/subsystem/vote/proc/vote_finish(var/datum/vote/curvote)
	active_votes -= curvote

	if(!curvote.hidden)
		if(!curvote.round_start_hidden || ticker.current_state > GAME_STATE_SETTING_UP)
			inactive_votes.Add(curvote)

	update_clients_browsing()

/mob/verb/vote()
	set category = "OOC"
	set name = "Vote"

	if(vote)
		show_browser(client, vote.interface(client), "window=vote")

/datum/controller/subsystem/vote/proc/interface(var/client/C)
	voting |= C
	if(active_votes.len)
		. += "<h2>Currently active votes:</h2>"
		for(var/datum/vote/active_vote in active_votes)
			. += "\t(<a href='?src=\ref[active_vote];view_vote=1'>[active_vote.name]</a>)"
	else
		. += "<h2>No currently active votes</h2>"

	. += "<hr>"

	if(inactive_votes.len)
		. += "<h2>Start a vote:</h2>"
		for(var/datum/vote/cur_vote in inactive_votes)
			if(cur_vote.disabled)
				if(check_rights(R_ADMIN))
					. += "\t<a href='?src=\ref[cur_vote];start_vote=1'>[cur_vote.name]</a> (ADMIN OVERRIDE)"
				else
					. += "\t[cur_vote.name] ([cur_vote.disable_reason ? cur_vote.disable_reason : "disabled"])"
			else
				. += "\t<a href='?src=\ref[cur_vote];start_vote=1'>[cur_vote.name]</a>"
			. += "<br>"
	else
		. += "<h2>No votes available to be started</h2>"
	. += "<br><br>"
	. += "<a href='?src=\ref[src];client=\ref[C];close=1'>(Close)</a>"

/datum/controller/subsystem/vote/proc/delay_round_start()
	. = 0
	for(var/datum/vote/active_vote in active_votes)
		if(active_vote.delay_round_start)
			return 1

/datum/controller/subsystem/vote/proc/delay_round_end()
	. = 0
	for(var/datum/vote/active_vote in active_votes)
		if(active_vote.delay_round_end)
			return 1

/datum/controller/subsystem/vote/Topic(href,href_list[],hsrc)
	if(!usr || !usr.client)	return	//not necessary but meh...just in-case somebody does something stupid

	if(href_list["close"])
		voting -= usr.client
		show_browser(usr.client, null, "window=vote")

/datum/controller/subsystem/vote/proc/update_clients_browsing()
	for(var/client/C in GLOB.voting)
		show_browser(C, interface(C), "window=vote")
