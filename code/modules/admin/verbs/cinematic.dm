/client/proc/cinematic(var/cinematic as anything in list("explosion",null))
	set name = "Cinematic"
	set category = "Fun"
	set desc = "Shows a cinematic."	// Intended for testing but I thought it might be nice for events on the rare occasion Feel free to comment it out if it's not wanted.

	if(!check_rights(R_FUN))
		return

	if(alert("Are you sure you want to run [cinematic]?","Confirmation","Yes","No")=="No")
		return
	switch(cinematic)
		if("explosion")
			if(alert("The game will be over. Are you really sure?", "Confirmation" ,"Continue", "Cancel") == "Cancel")
				return
			var/parameter = input(src,"station_missed = ? (0 for hit, 1 for near miss, 2 for not close)","Enter Parameter",0) as num
			var/datum/game_mode/override
			var/name = input(src,"Override mode = ?","Enter Parameter",null) as null|anything in gamemode_cache
			override = gamemode_cache[name]
			if(!istype(override))
				override = null
			GLOB.cinematic.station_explosion_cinematic(parameter,override)

	log_and_message_admins("launched cinematic \"[cinematic]\"", src)