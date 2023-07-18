/mob/Stat()
	..()
	. = (is_client_active(5 MINUTES))
	if (!.)
		return

	if(statpanel("Status"))
		stat("Round ID", game_id)
