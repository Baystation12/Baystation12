/datum/build_mode/copypaste
	name = "Copy & Paste"
	icon_state = "mode_copypaste"
	var/datum/stored

/datum/build_mode/copypaste/Help()
	to_chat(usr, SPAN_NOTICE("***** Build Mode: Copy & Paste ******"))
	to_chat(usr, SPAN_NOTICE("Left Mouse Button on obj/turf/mob - Spawn a Copy of selected target"))
	to_chat(usr, SPAN_NOTICE("Right Mouse Button on obj/mob     - Select target to copy"))
	to_chat(usr, SPAN_NOTICE("************************************"))

/datum/build_mode/copypaste/Destroy()
	stored = null
	return ..()

/datum/build_mode/copypaste/proc/get_location(var/atom/A)
	return "[A.loc.name]([A.x],[A.y],[A.z]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[A.x];Y=[A.y];Z=[A.z]'>JMP</a>)"

/datum/build_mode/copypaste/OnClick(var/atom/object, var/list/parameters)
	if(parameters["left"])
		var/turf/T = get_turf(object)
		if(stored)
			DuplicateObjectDeep(stored, perfectcopy=1, sameloc=0, newloc=T)
			log_and_message_admins("Build Mode: [usr.ckey] copied [stored] ([stored.type]) to [get_location(T)]")
			to_chat(SPAN_NOTICE("Successfully copied [stored] ([stored.type]) to [T.loc.name]!"))
		else
			to_chat(usr, SPAN_DANGER("No template! You have to select something using RMB."))
	if (parameters["right"])
		if(ismovable(object)) // No copying turfs
			to_chat(usr, SPAN_NOTICE("[object] ([object.type]) set as template."))
			stored = object