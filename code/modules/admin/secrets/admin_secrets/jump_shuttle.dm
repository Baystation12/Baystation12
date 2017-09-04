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

	var/list/destinations = list()
	for(var/obj/effect/shuttle_landmark/WP in world)
		destinations += WP

	var/obj/effect/shuttle_landmark/destination = input(user, "Select the destination for this jump.") as null|anything in destinations
	if (!destination) return

	var/long_jump = alert(user, "Is there a transition location for this jump?","", "Yes", "No")
	if (long_jump == "Yes")
		var/obj/effect/shuttle_landmark/transition = input(user, "Select transition location for this jump.") as null|anything in destinations
		if (!transition) return

		var/move_duration = input(user, "How many seconds will this jump take?") as num

		S.long_jump(destination, transition, move_duration)
		log_and_message_admins("has initiated a jump to [destination] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[destination.x];Y=[destination.y];Z=[destination.z]'>JMP</a>) lasting [move_duration] seconds in transit at [transition] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[transition.x];Y=[transition.y];Z=[transition.z]'>JMP</a>) for the [shuttle_tag] shuttle")
	else
		S.short_jump(destination)
		log_and_message_admins("has initiated a jump to [destination] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[destination.x];Y=[destination.y];Z=[destination.z]'>JMP</a>) for the [shuttle_tag] shuttle")
