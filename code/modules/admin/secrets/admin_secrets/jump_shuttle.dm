/datum/admin_secret_item/admin_secret/jump_shuttle
	name = "Jump a Shuttle"

/datum/admin_secret_item/admin_secret/jump_shuttle/can_execute(var/mob/user)
	if(!shuttle_controller) return 0
	return ..()

/datum/admin_secret_item/admin_secret/jump_shuttle/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/shuttle_tag = input(user, "Which shuttle do you want to jump?") as null|anything in shuttle_controller.shuttles
	if (!shuttle_tag) return

	var/datum/shuttle/S = shuttle_controller.shuttles[shuttle_tag]

	var/origin_area = input(user, "Which area is the shuttle at now? (MAKE SURE THIS IS CORRECT OR THINGS WILL BREAK)") as null|area in world
	if (!origin_area) return

	var/destination_area = input(user, "Which area is the shuttle at now? (MAKE SURE THIS IS CORRECT OR THINGS WILL BREAK)") as null|area in world
	if (!destination_area) return

	var/long_jump = alert(user, "Is there a transition area for this jump?","", "Yes", "No")
	if (long_jump == "Yes")
		var/transition_area = input(user, "Which area is the transition area? (MAKE SURE THIS IS CORRECT OR THINGS WILL BREAK)") as null|area in world
		if (!transition_area) return

		var/move_duration = input(user, "How many seconds will this jump take?") as num

		S.long_jump(origin_area, destination_area, transition_area, move_duration)
		message_admins("<span class='notice'>[key_name_admin(user)] has initiated a jump from [origin_area] to [destination_area] lasting [move_duration] seconds for the [shuttle_tag] shuttle</span>", 1)
		log_admin("[key_name_admin(user)] has initiated a jump from [origin_area] to [destination_area] lasting [move_duration] seconds for the [shuttle_tag] shuttle")
	else
		S.short_jump(origin_area, destination_area)
		message_admins("<span class='notice'>[key_name_admin(user)] has initiated a jump from [origin_area] to [destination_area] for the [shuttle_tag] shuttle</span>", 1)
		log_admin("[key_name_admin(user)] has initiated a jump from [origin_area] to [destination_area] for the [shuttle_tag] shuttle")
