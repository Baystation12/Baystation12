/datum/game_mode/blob/check_finished()
	if(!declared)//No blobs have been spawned yet
		return 0
	if(blobwincount <= blobs.len)//Blob took over
		return 1
	if(!blob_cores.len) // blob is dead
		return 1
	if(station_was_nuked)//Nuke went off
		return 1
	return 0


/datum/game_mode/blob/declare_completion()
	if(blobwincount <= blobs.len)
		feedback_set_details("round_end_result","loss - blob took over")
		world << "<FONT size = 3><B>The blob has taken over the station!</B></FONT>"
		world << "<B>The entire station was eaten by the Blob</B>"
		log_game("Blob mode was lost.")

	else if(station_was_nuked)
		feedback_set_details("round_end_result","halfwin - nuke")
		world << "<FONT size = 3><B>Partial Win: The station has been destroyed!</B></FONT>"
		world << "<B>Directive 7-12 has been successfully carried out preventing the Blob from spreading.</B>"
		log_game("Blob mode was tie (station destroyed).")

	else if(!blob_cores.len)
		feedback_set_details("round_end_result","win - blob eliminated")
		world << "<FONT size = 3><B>The staff has won!</B></FONT>"
		world << "<B>The alien organism has been eradicated from the station</B>"

		var/datum/station_state/end_state = new /datum/station_state()
		end_state.count()
		var/percent = round( 100.0 *  start_state.score(end_state), 0.1)
		world << "<B>The station is [percent]% intact.</B>"
		log_game("Blob mode was won with station [percent]% intact.")
		world << "\blue Rebooting in 30s"
	..()
	return 1

datum/game_mode/proc/auto_declare_completion_blob()
	if(istype(ticker.mode,/datum/game_mode/blob) )
		var/datum/game_mode/blob/blob_mode = src
		if(blob_mode.infected_crew.len)
			var/text = "<FONT size = 2><B>The blob[(blob_mode.infected_crew.len > 1 ? "s were" : " was")]:</B></FONT>"

			for(var/datum/mind/blob in blob_mode.infected_crew)
				text += "<br><b>[blob.key]</b> was <b>[blob.name]</b>"
			world << text
		return 1
