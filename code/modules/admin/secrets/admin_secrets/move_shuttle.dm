/datum/admin_secret_item/admin_secret/move_shuttle
	name = "Move a Shuttle"

/datum/admin_secret_item/admin_secret/move_shuttle/can_execute(var/mob/user)
	if(!shuttle_controller) return 0
	return ..()

/datum/admin_secret_item/admin_secret/move_shuttle/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/confirm = alert("This command directly moves a shuttle from one area to another. DO NOT USE THIS UNLESS YOU ARE DEBUGGING A SHUTTLE AND YOU KNOW WHAT YOU ARE DOING.", "Are you sure?", "Ok", "Cancel")
	if (confirm == "Cancel")
		return

	var/shuttle_tag = input("Which shuttle do you want to jump?") as null|anything in shuttle_controller.shuttles
	if (!shuttle_tag) return

	var/datum/shuttle/S = shuttle_controller.shuttles[shuttle_tag]

	var/origin_area = input("Which area is the shuttle at now? (MAKE SURE THIS IS CORRECT OR THINGS WILL BREAK)") as null|area in world
	if (!origin_area) return

	var/destination_area = input("Which area is the shuttle at now? (MAKE SURE THIS IS CORRECT OR THINGS WILL BREAK)") as null|area in world
	if (!destination_area) return

	S.move(origin_area, destination_area)
	log_and_message_admins("[key_name_admin(usr)] moved the [shuttle_tag] shuttle", user)
