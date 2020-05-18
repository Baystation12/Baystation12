/datum/admin_secret_item/admin_secret/launch_shuttle
	name = "Launch a Shuttle"

/datum/admin_secret_item/admin_secret/launch_shuttle/can_execute(var/mob/user)
	if(!SSshuttle) return 0
	return ..()

/datum/admin_secret_item/admin_secret/launch_shuttle/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/list/valid_shuttles = list()
	for (var/shuttle_tag in SSshuttle.shuttles)
		if (istype(SSshuttle.shuttles[shuttle_tag], /datum/shuttle/autodock/ferry))
			valid_shuttles += shuttle_tag

	var/shuttle_tag = input(user, "Which shuttle do you want to launch?") as null|anything in valid_shuttles
	if (!shuttle_tag)
		return

	var/datum/shuttle/autodock/ferry/S = SSshuttle.shuttles[shuttle_tag]
	if (S.can_launch())
		S.launch(user)
		log_and_message_admins("launched the [shuttle_tag] shuttle", user)
	else
		alert(user, "The [shuttle_tag] shuttle cannot be launched at this time. It's probably busy.")
