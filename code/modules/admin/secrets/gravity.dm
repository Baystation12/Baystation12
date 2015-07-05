/**********
* Gravity *
**********/
/datum/admin_secret_item/random_event/gravity
	name = "Toggle station artificial gravity"

/datum/admin_secret_item/random_event/gravity/execute(var/mob/user)
	. = ..()
	if(!.)
		return

	if(!(ticker && ticker.mode))
		user << "Please wait until the game starts!  Not sure how it will work otherwise."
		return

	gravity_is_on = !gravity_is_on
	for(var/area/A in world)
		A.gravitychange(gravity_is_on,A)

	feedback_inc("admin_secrets_fun_used",1)
	feedback_add_details("admin_secrets_fun_used","Grav")
	if(gravity_is_on)
		log_admin("[key_name(usr)] toggled gravity on.", 1)
		message_admins("\blue [key_name_admin(usr)] toggled gravity on.", 1)
		command_announcement.Announce("Gravity generators are again functioning within normal parameters. Sorry for any inconvenience.")
	else
		log_admin("[key_name(usr)] toggled gravity off.", 1)
		message_admins("\blue [key_name_admin(usr)] toggled gravity off.", 1)
		command_announcement.Announce("Feedback surge detected in mass-distributions systems. Artificial gravity has been disabled whilst the system reinitializes. Further failures may result in a gravitational collapse and formation of blackholes. Have a nice day.")
