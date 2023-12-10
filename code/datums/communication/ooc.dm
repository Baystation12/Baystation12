/singleton/communication_channel/ooc
	name = "OOC"
	config_setting = "ooc_allowed"
	expected_communicator_type = /client
	flags = COMMUNICATION_NO_GUESTS
	log_proc = /proc/log_ooc
	mute_setting = MUTE_OOC
	show_preference_setting = /datum/client_preference/show_ooc

/singleton/communication_channel/ooc/can_communicate(client/C, message)
	. = ..()
	if(!.)
		return

	if(!C.holder)
		if(!config.dooc_allowed && (C.mob.stat == DEAD))
			to_chat(C, SPAN_DANGER("[name] for dead mobs has been turned off."))
			return FALSE

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

	// [SIERRA-ADD] - DON_LOADOUT
	var/ckey_prefix = C.donator_info.get_decorated_message(C, "<EM>[C.key]:</EM>")
	// [/SIERRA-ADD]
	for(var/client/target in GLOB.clients)
		if(target.is_key_ignored(C.key)) // If we're ignored by this person, then do nothing.
			continue
		// [SIERRA-EDIT] - DON_LOADOUT
		// var/sent_message = "[create_text_tag("ooc", "OOC:", target)] <EM>[C.key]:</EM> [SPAN_CLASS("message linkify", "[message]")]" // SIERRA-EDIT - ORIGINAL
		var/sent_message = "[create_text_tag("ooc", "OOC:", target)] [ckey_prefix] [SPAN_CLASS("message linkify", "[message]")]"
		// [/SIERRA-EDIT]
		if(can_badmin)
			receive_communication(C, target, SPAN_COLOR(ooc_color, SPAN_CLASS("ooc", sent_message)))
		else
			receive_communication(C, target, SPAN_CLASS("ooc", SPAN_CLASS(ooc_style, sent_message)))
