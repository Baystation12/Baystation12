/client/proc/nuke()
	set category = "Special Verbs"
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
		message_admins("\red [ckey] decided to kill everyone with a nuke!")
		command_announcement.Announce("Alert, proximity sensors have detected a rogue nuclear missile on collision course with the station. Brace for impact!", "Nuclear Device Detected", new_sound = 'sound/misc/notice1.ogg');
		set_security_level("delta")

		sleep(201)

		ticker.mode:explosion_in_progress = 1
		for(var/mob/M in world)
			if(M.client)
				M << 'sound/machines/Alarm.ogg'
		world << "\blue<b>Incoming missile detected. Impact in 10...</b>"
		for (var/i=9 to 1 step -1)
			sleep(10)
			world << "\blue<b>[i]...</b>"
		sleep(10)
		enter_allowed = 0
		if(ticker)
			ticker.station_explosion_cinematic(0,null)
			if(ticker.mode)
				ticker.mode:station_was_nuked = 1
				ticker.mode:explosion_in_progress = 0
		return

/client/proc/artillery()
	set category = "Special Verbs"
	set name = "Fire Bluespace Artillery"

	if(!holder)
		src << "Only administrators may use this command."
		return

	if(alert("You are firing on the phoenix.. Continue?",,"Yes","No")=="No")
		return

	if(!ticker)
		alert("huh...what are you doing...the game hasn't even started yet...")
		return
	if(!ticker.mode)
		alert("huh...what are you doing...the game hasn't even started yet...")
		return


	else
		var/A
		A = input("Area to jump bombard", "Open Fire", A) in teleportlocs
		var/area/thearea = teleportlocs[A]
		command_announcement.Announce("Bluespace artillery fire detected. Brace for impact.","Incoming Bombardment")
		message_admins("[key_name_admin(usr)] has launched an artillery strike.", 1)
		sleep(30)
		var/list/L = list()
		for(var/turf/T in get_area_turfs(thearea.type))
			L+=T
		var/loc = pick(L)
		explosion(loc,2,5,11)