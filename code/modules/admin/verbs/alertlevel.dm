/client/proc/alertlevel() // Some admin dickery that can probably be done better -- TLE
	set category = "Special Verbs"
	set name = "Set Alert Level"
	set desc = "Change Alert Level."
	var/list/choices = list("Green", "Blue", "Red", "Delta")
	var/choice = input("Which alert level would you like to change to?") in choices
	switch(choice)
		if(null)
			return 0
		if("Green")
			set_security_level(SEC_LEVEL_GREEN)
		if("Blue")
			set_security_level(SEC_LEVEL_BLUE)
		if("Red")
			set_security_level(SEC_LEVEL_RED)
		if("Delta")
			set_security_level(SEC_LEVEL_DELTA)
	message_admins("\blue [key_name_admin(usr)] changed alert level to Code [choice].")
	feedback_add_details("admin_verb","Alertlevel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
