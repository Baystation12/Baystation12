/datum/vote/window_screen/setup
	id = VOTE_WINDOW_SETUP_SCREEN

/datum/vote/window_screen/setup/CanUseTopic(var/mob/user)
	if(!may_start_vote(user))
		return STATUS_CLOSE
	return ..()

/datum/vote/window_screen/setup/Topic(href, href_list)
	if(..())
		return TRUE


/datum/vote/window_screen/setup/screen_data(var/list/data, var/mob/user)
