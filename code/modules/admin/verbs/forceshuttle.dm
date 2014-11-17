
/client/proc/forceshuttles()
	set category = "Special Verbs"
	set name = "Force a shuttle"

	if(!holder)
		src << "Only administrators may use this command."
		return

	var/list/valid_shuttles = list()
	for (var/shuttle_tag in shuttle_controller.shuttles)
		if (istype(shuttle_controller.shuttles[shuttle_tag], /datum/shuttle/ferry))
			valid_shuttles += shuttle_tag

	var/shuttle_tag = input("Which shuttle's launch do you want to force?") as null|anything in valid_shuttles

	if (!shuttle_tag)
		return

	var/datum/shuttle/ferry/S = shuttle_controller.shuttles[shuttle_tag]
	if (S.can_force())
		S.force_launch(usr)
		message_admins("\blue [key_name_admin(usr)] has forced the [shuttle_tag] shuttle launch", 1)
		log_admin("[key_name(usr)] has forced the [shuttle_tag] shuttle launch")
		log_admin_single("[key_name(usr)] has forced the [shuttle_tag] shuttle launch")
	else
		alert("The [shuttle_tag] shuttle launch cannot be forced at this time. It's busy, or hasn't been launched yet.")