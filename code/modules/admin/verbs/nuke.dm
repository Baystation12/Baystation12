/client/proc/nuke()
	set category = "Admin"
	set name = "Nuke the Station"

	if(!holder)
		src << "Only administrators may use this command."
		return

	if(alert("This will destroy the station with a nuke. Are you sure you wish to kill everyone?",,"Yes","No")=="No")
		return

	if(!ticker)
		alert("huh...what are you doing...the game hasn't even started yet...")
		return
	if(!ticker.mode)
		alert("huh...what are you doing...the game hasn't even started yet...")
		return
	else



		message_admins("\red [ckey] decided to blow up the station.")
		set_security_level("gamma")
		for(var/mob/M in player_list)
			if(!istype(M,/mob/new_player))
				M << sound('sound/ai/spanomalies.ogg')

		sleep(201)

		ticker.mode:explosion_in_progress = 1
		for(var/mob/M in player_list)
			M << 'sound/machines/Alarm.ogg'
		world << " "
		world << "\red Impact in 10"
		for (var/i=9 to 1 step -1)
			sleep(10)
			var/msg = i
			world << "\red[msg]"
		sleep(10)
		if(ticker)
			ticker.station_explosion_cinematic(0,null)
			if(ticker.mode)
				ticker.mode:station_was_nuked = 1
				ticker.mode:explosion_in_progress = 0