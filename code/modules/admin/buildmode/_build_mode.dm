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

/datum/build_mode/proc/select_subpath(given_path, within_scope = /atom)
	var/desired_path = input("Enter full or partial typepath.","Typepath","[given_path]") as text|null
	if(!desired_path)
		return

	var/list/types = typesof(within_scope)
	var/list/matches = list()

	for(var/path in types)
		if(findtext("[path]", desired_path))
			matches += path

	if(!matches.len)
		alert("No results found. Sorry.")
		return

	if(matches.len==1)
		return matches[1]
	else
		return (input("Select a type", "Select Type", matches[1]) as null|anything in matches)

/datum/build_mode/CanUseTopic(mob/user)
	if (check_rights(R_BUILDMODE, TRUE, user))
		return STATUS_INTERACTIVE
	return ..()
