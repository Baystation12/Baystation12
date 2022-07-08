/datum/build_mode
	var/the_default = FALSE
	var/name
	var/icon_state
	var/datum/click_handler/build_mode/host
	var/datum/buildmode_overlay/overlay
	var/mob/user

/datum/build_mode/New(var/host)
	..()
	src.host = host
	user = src.host.owner?.mob

/datum/build_mode/Destroy()
	QDEL_NULL(overlay)
	host = null
	. = ..()

/datum/build_mode/proc/OnClick(var/atom/A, var/list/parameters)
	return

/datum/build_mode/proc/Configurate()
	return

/datum/build_mode/proc/Help()
	return

/datum/build_mode/proc/Selected()
	return

/datum/build_mode/proc/Unselected()
	return

/datum/build_mode/proc/TimerEvent()
	return

/datum/build_mode/proc/UpdateOverlay(atom/movable/M, turf/T)
	return

/datum/build_mode/proc/CreateOverlay(icon_state)
	overlay = new(user, src, icon_state)

/datum/build_mode/proc/Log(message)
	log_admin("BUILD MODE - [name] - [key_name(usr)] - [message]")

/datum/build_mode/proc/Warn(message)
	to_chat(user, "BUILD MODE - [name] - [message])")

/datum/build_mode/CanUseTopic(mob/user)
	if (check_rights(R_BUILDMODE, TRUE, user))
		return STATUS_INTERACTIVE
	return ..()

/datum/build_mode/proc/make_rectangle(turf/A, turf/B)
	if(!A || !B) // No coords
		return
	if(A.z != B.z) // Not same z-level
		return

	var/height = A.y - B.y
	var/width = A.x - B.x
	var/z_level = A.z

	var/turf/lower_left_corner = null
	// First, try to find the lowest part
	var/desired_y = 0
	desired_y = min(A.y, B.y)

	//Now for the left-most part.
	var/desired_x = 0
	desired_x = min(A.x, B.x)

	lower_left_corner = locate(desired_x, desired_y, z_level)

	// Now we can begin building the actual room.  This defines the boundries for the room.
	var/low_bound_x = lower_left_corner.x
	var/low_bound_y = lower_left_corner.y

	var/high_bound_x = lower_left_corner.x + abs(width)
	var/high_bound_y = lower_left_corner.y + abs(height)

	return list(low_bound_x, low_bound_y, high_bound_x, high_bound_y, z_level)
