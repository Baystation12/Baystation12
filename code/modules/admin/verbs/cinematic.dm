/client/proc/cinematic(var/cinematic as anything in list("explosion",null))
	set name = "Cinematic"
	set category = "Fun"
	set desc = "Shows a cinematic."	// Intended for testing but I thought it might be nice for events on the rare occasion Feel free to comment it out if it's not wanted.

	if(!check_rights(R_FUN))
		return

	if(alert("Are you sure you want to run [cinematic]?","Confirmation","Yes","No")=="No") return
	if(!ticker)	return
	switch(cinematic)
		if("explosion")
			if(alert("The game will be over. Are you really sure?", "Confirmation" ,"Continue", "Cancel") == "Cancel")
				return
			var/parameter = input(src,"station_missed = ?","Enter Parameter",0) as num
			var/override
			switch(parameter)
				if(1)
					override = input(src,"mode = ?","Enter Parameter",null) as anything in list("mercenary","no override")
				if(0)
					override = input(src,"mode = ?","Enter Parameter",null) as anything in list("blob","mercenary","AI malfunction","no override")
			ticker.station_explosion_cinematic(parameter,override)

	log_admin("[key_name(src)] launched cinematic \"[cinematic]\"")
	message_admins("[key_name_admin(src)] launched cinematic \"[cinematic]\"", 1)

	return