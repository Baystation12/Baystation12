/datum/admin_secret_item/admin_secret/alter_narise
	name = "Alter Nar-Sie"

/datum/admin_secret_item/admin_secret/alter_narise/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/choice = input(user, "How do you wish for Nar-Sie to interact with its surroundings?") as null|anything in list("CultStation13", "Nar-Singulo")
	if(choice == "CultStation13")
		log_and_message_admins("has set narsie's behaviour to \"CultStation13\".", user)
		narsie_behaviour = choice
	if(choice == "Nar-Singulo")
		log_and_message_admins("has set narsie's behaviour to \"Nar-Singulo\".", user)
		narsie_behaviour = choice
