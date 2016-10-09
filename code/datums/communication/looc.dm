/decl/communication_channel/ooc/looc
	log_prefix = "LOCAL"
	ooc_type = "LOOC"
	show_preference_setting = /datum/client_preference/show_looc

/decl/communication_channel/ooc/looc/can_communicate(var/mob/communicator, var/message)
	. = ..()
	if(!.)
		return
	if(!get_turf(communicator))
		to_chat(communicator, "<span class='danger'>You cannot use [ooc_type] while in in nullspace.</span>")
		return FALSE

/decl/communication_channel/ooc/looc/do_communicate(var/mob/communicator, var/message)
	var/mob/source = communicator.get_looc_source()

	var/client/C = communicator.client

	var/display_name = C.key
	if(communicator.stat != DEAD)
		display_name = communicator.name

	var/turf/T = get_turf(source)
	var/list/listening = list()
	listening |= src	// We can always hear ourselves.
	var/list/listening_obj = list()
	var/list/eye_heard = list()

	// This is essentially a copy/paste from living/say() the purpose is to get mobs inside of objects without recursing through
	// the contents of every mob and object in get_mobs_or_objects_in_view() looking for PAI's inside of the contents of a bag inside the
	// contents of a mob inside the contents of a welded shut locker we essentially get a list of turfs and see if the mob is on one of them.

	if(T)
		var/list/hear = hear(7,T)
		var/list/hearturfs = list()

		for(var/I in hear)
			if(ismob(I))
				var/mob/M = I
				listening |= M.client
				hearturfs += M.locs[1]
			else if(isobj(I))
				var/obj/O = I
				hearturfs |= O.locs[1]
				listening_obj |= O

		for(var/mob/M in player_list)
			if(isAI(M))
				var/mob/living/silicon/ai/A = M
				if(A.eyeobj && (A.eyeobj.locs[1] in hearturfs))
					eye_heard |= M.client
					listening |= M.client
					continue

			if(M.loc && M.locs[1] in hearturfs)
				listening |= M.client


	for(var/client/t in listening)
		if(!t.is_preference_enabled(/datum/client_preference/show_looc))
			continue
		var/admin_stuff = ""
		var/prefix = ""
		if(t in admins)
			admin_stuff += "/([C.key])"
			if(t != src)
				admin_stuff += "([admin_jump_link(communicator, t.holder)])"
		if(isAI(t.mob))
			if(t in eye_heard)
				prefix = "(Eye) "
			else
				prefix = "(Core) "
		to_chat(t, "<span class='ooc'><span class='looc'>" + create_text_tag("looc", "LOOC:", t) + " <span class='prefix'>[prefix]</span><EM>[display_name][admin_stuff]:</EM> <span class='message'>[message]</span></span></span>")

	for(var/client/adm in admins)	//Now send to all admins that weren't in range.
		if(!(adm in listening) && adm.is_preference_enabled(/datum/client_preference/show_looc) && adm.is_preference_enabled(/datum/client_preference/holder/show_rlooc))
			var/admin_stuff = "/([C.key])([admin_jump_link(communicator, adm.holder)])"
			var/prefix = "(R)"

			to_chat(adm, "<span class='ooc'><span class='looc'>" + create_text_tag("looc", "LOOC:", adm) + " <span class='prefix'>[prefix]</span><EM>[display_name][admin_stuff]:</EM> <span class='message'>[message]</span></span></span>")

/mob/proc/get_looc_source()
	return src

/mob/living/silicon/ai/get_looc_source()
	if(eyeobj)
		return eyeobj
	return src
