/**********
* Gravity *
**********/
/datum/admin_secret_item/random_event/gravity
	name = "Toggle Artificial Gravity"

/datum/admin_secret_item/random_event/gravity/can_execute(var/mob/user)
	if(GAME_STATE < RUNLEVEL_GAME)
		return 0
	return ..()

/datum/admin_secret_item/random_event/gravity/execute(var/mob/user)
	. = ..()
	if(!.)
		return

	var/choice = input(user, "Make Command Report?") in list("Yes", "No")
	gravity_is_on = !gravity_is_on
	for(var/area/A in world)
		A.gravitychange(gravity_is_on)

	SSstatistics.add_field("admin_secrets_fun_used",1)
	SSstatistics.add_field_details("admin_secrets_fun_used","Grav")
	log_and_message_admins("toggled gravity.")
	if(choice == "Yes")
		if(gravity_is_on)
			command_announcement.Announce("Gravity generators are again functioning within normal parameters. Sorry for any inconvenience.", "Gravity Restored")
		else
			command_announcement.Announce("Feedback surge detected in mass-distributions systems. Artificial gravity has been disabled whilst the system reinitializes.", "Gravity Failure")
