/datum/vote/window_screen/vote
	id = VOTE_WINDOW_VOTE_SCREEN
	var/datum/vote/setup/setup

/datum/vote/window_screen/vote/before_show(var/datum/vote/setup/setup)
	src.setup = setup

/datum/vote/window_screen/vote/screen_data(var/list/data, var/mob/user)
	data["description"] = setup.description
	data["status"] = setup.status()
