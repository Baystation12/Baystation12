/datum/admin_secret_item/final_solution/summon_narsie
	name = "Summon Nar-Sie"

/datum/admin_secret_item/final_solution/summon_narsie/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/choice = input(user, "You sure you want to end the round and summon Nar-Sie at your location? Misuse of this could result in removal of flags or hilarity.") in list("PRAISE SATAN", "Cancel")
	if(choice == "PRAISE SATAN")
		new /obj/singularity/narsie/large(get_turf(user))
		log_and_message_admins("has summoned Nar-Sie and brought about a new realm of suffering.", user)
