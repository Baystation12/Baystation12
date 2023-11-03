// SIERRA TODO: Переместить в коркод
/singleton/communication_channel/ooc/do_communicate(client/C, message)
	var/datum/admins/holder = C.holder
	var/is_stealthed = C.is_stealthed()

	var/ooc_style = "everyone"
	if(holder && !is_stealthed)
		ooc_style = "elevated"
		if(holder.rights & R_MOD)
			ooc_style = "moderator"
		if(holder.rights & R_DEBUG)
			ooc_style = "developer"
		if(holder.rights & R_ADMIN)
			ooc_style = "admin"

	var/can_badmin = !is_stealthed && can_select_ooc_color(C) && (C.prefs.ooccolor != initial(C.prefs.ooccolor))
	var/ooc_color = C.prefs.ooccolor


	var/ckey = C.donator_info.get_decorated_ooc_name(C)
	for(var/client/target in GLOB.clients)
		if(target.is_key_ignored(C.key)) // If we're ignored by this person, then do nothing.
			continue

		var/sent_message = "[create_text_tag("ooc", "OOC:", target)] <EM>[ckey]:</EM> [SPAN_CLASS("message linkify", "[message]")]"
		if(can_badmin)
			receive_communication(C, target, SPAN_COLOR(ooc_color, SPAN_CLASS("ooc", sent_message)))
		else
			receive_communication(C, target, SPAN_CLASS("ooc", SPAN_CLASS(ooc_style, sent_message)))
