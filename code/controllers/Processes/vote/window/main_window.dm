/datum/vote/window_screen/main
	id = VOTE_WINDOW_MAIN_SCREEN

/datum/vote/window_screen/main/CanUseTopic(var/mob/user, var/datum/topic_state/state, var/href_list = list())
	if(href_list["new_vote"] && !check_rights(R_ADMIN, 0, user))
		return STATUS_CLOSE
	return ..()

/datum/vote/window_screen/main/Topic(href, href_list)
	if(..())
		return TRUE
	if(href_list["open_vote"])
		var/datum/vote/setup/setup = locate(href_list["open_vote"]) in new_vote.get_votes()
		if(!setup)
			return
		window.set_screen(/datum/vote/window_screen/vote, setup)
		return TRUE
	if(href_list["new_vote"])
		if(may_start_vote(usr))
			window.set_screen(/datum/vote/window_screen/setup, new/datum/vote/setup())
			return TRUE
	if(href_list["new_vote_preset"])
		if(may_start_vote(usr))
			var/datum/vote/preset/vote_preset = locate(href_list["new_vote_preset"]) in new_vote.get_presets()
			if(vote_preset)
				window.set_screen(/datum/vote/window_screen/setup, vote_preset.build())
				return TRUE

/datum/vote/window_screen/main/screen_data(var/list/data, var/mob/user)
	var/votes[0]
	for(var/vote in new_vote.get_votes())
		var/datum/vote/setup/setup = vote
		votes[++votes.len] = list("description" = setup.description, "status" = setup.status(), "ref" = "\ref[setup]")
	data["votes"] = votes
	data["may_start_vote"] = may_start_vote(user)

	if(data["may_start_vote"])
		var/presets[0]
		for(var/preset in new_vote.get_presets())
			var/datum/vote/preset/vote_preset = preset
			presets[++presets.len] = list("description" = vote_preset.description, "ref" = "\ref[preset]")
		data["presets"] = presets
