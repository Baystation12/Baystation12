/datum/build_mode/build
	the_default = TRUE
	name = "Build Mode"
	icon_state = "mode_build"
	var/static/help_text = {"\
	***********Build Mode***********
	Left Click = Create Atom
	Right Click = Delete Atom
	Middle Click = Copy Atom Path
	Left Click + Ctrl = Copy Atom Path
	Right Click on Mode Button = Choose Path Dialog
	Directional Arrow Button = Direction On Creation
	********************************
	"}
	var/build_type

/datum/build_mode/build/Help()
	to_chat(user, help_text)

/datum/build_mode/build/Configurate()
	build_type = select_subpath(build_type || /obj/item/latexballon)
	to_chat(user, "Selected Type [build_type]")

/datum/build_mode/build/OnClick(atom/target, list/parameters)
	if (!target)
		return
	if (parameters["middle"] || parameters["ctrl"] && parameters["left"])
		if (ispath(target.type, /atom))
			to_chat(user, "Selected Type [target.type]")
			build_type = target.type
			return
	var/turf/location = get_turf(target)
	if (parameters["right"])
		if (isturf(target))
			return
		if (isobserver(target)) // don't delete ghosts because it causes very weird things to happen
			return
		if (ismob(target))
			var/mob/M = target
			if (M.ckey && !QDELETED(M))
				var/alert_result = alert(user, "[M] is a player-controlled mob. Confirm?", "Build Mode", "Yes, Delete", "Cancel")
				if (alert_result != "Yes, Delete" || QDELETED(M))
					return
			to_chat(M, SPAN_DEBUG(FONT_LARGE("OOC: You have been deleted by an admin using build mode. If this seems to be in error, please adminhelp and let them know.")))
			M.ghostize()
		qdel(target)
	else if (parameters["left"])
		if (!build_type)
			to_chat(user, SPAN_WARNING("Select a type to construct."))
			return
		if (!location)
			return
		else if (ispath(build_type, /turf))
			location.ChangeTurf(build_type)
		else
			var/atom/instance = new build_type (location)
			instance.set_dir(host.dir)

/datum/build_mode/build/CanUseTopic(mob/user)
	if (!isadmin(user))
		return STATUS_CLOSE
	return ..()

/datum/build_mode/build/Topic(href, list/href_list)
	if (!length(href_list))
		return
	if (href_list["jump"])
		var/turf/location = locate(href_list["jump"])
		if (!location)
			return
		if (!isghost(user))
			var/client/user_client = user.client
			if (!user_client)
				return
			user_client.admin_ghost()
			user_client.mob.jumpTo(location)
		else
			user.jumpTo(location)
