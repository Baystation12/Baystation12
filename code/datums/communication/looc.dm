/decl/communication_channel/ooc/looc
	log_prefix = "LOCAL"
	ooc_type = "LOOC"
	show_preference_setting = /datum/client_preference/show_looc

/decl/communication_channel/ooc/looc/can_communicate(var/mob/communicator, var/message)
	. = ..()
	if(!.)
		return
	if(!get_turf(communicator))
		to_chat(communicator, "<span class='danger'>You cannot use [ooc_type] while in nullspace.</span>")
		return FALSE

/decl/communication_channel/ooc/looc/do_communicate(var/mob/communicator, var/message)
	var/client/C = communicator.client
	var/display_name = communicator.stat == DEAD ? C.key : communicator.name
	var/list/listening = clients_in_range(communicator)

	for(var/client/t in listening)
		if(!t.is_preference_enabled(/datum/client_preference/show_looc))
			continue
		var/admin_stuff = ""
		var/prefix = ""
		if(t in admins)
			admin_stuff += "/([C.key])"
			if(t != src)
				admin_stuff += "([admin_jump_link(communicator, t.holder)])"
		if(isEye(t.get_looc_source()))
			prefix = "(Eye) "
		to_chat(t, "<span class='ooc'><span class='looc'>" + create_text_tag("looc", "LOOC:", t) + " <span class='prefix'>[prefix]</span><EM>[display_name][admin_stuff]:</EM> <span class='message'>[message]</span></span></span>")

	for(var/client/adm in admins)	//Now send to all admins that weren't in range.
		if(!(adm in listening) && adm.is_preference_enabled(/datum/client_preference/show_looc) && adm.is_preference_enabled(/datum/client_preference/holder/show_rlooc))
			var/admin_stuff = "/([C.key])([admin_jump_link(communicator, adm.holder)])"
			var/prefix = "(R)"
			to_chat(adm, "<span class='ooc'><span class='looc'>" + create_text_tag("looc", "LOOC:", adm) + " <span class='prefix'>[prefix]</span><EM>[display_name][admin_stuff]:</EM> <span class='message'>[message]</span></span></span>")

/client/proc/get_looc_source()
	if(mob.eyeobj)
		return mob.eyeobj
	return mob
