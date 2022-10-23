#define SPAN_AOOC(X) SPAN_CLASS("ooc", SPAN_CLASS("aooc", "[create_text_tag("aooc", "Antag-OOC:", target)] [X]"))


/singleton/communication_channel/aooc
	name = "AOOC"
	config_setting = "aooc_allowed"
	expected_communicator_type = /client
	flags = COMMUNICATION_LOG_CHANNEL_NAME|COMMUNICATION_ADMIN_FOLLOW
	log_proc = /proc/log_ooc
	mute_setting = MUTE_AOOC
	show_preference_setting = /datum/client_preference/show_aooc


/singleton/communication_channel/aooc/can_communicate(client/C, message)
	. = ..()
	if(!.)
		return

	if(!C.holder)
		if(isghost(C.mob))
			to_chat(src, SPAN_WARNING("You cannot use [name] while ghosting/observing!"))
			return FALSE
		if(!(C.mob?.mind?.special_role))
			to_chat(C, SPAN_DANGER("You must be an antag to use [name]."))
			return FALSE


/singleton/communication_channel/aooc/do_communicate(client/C, message)
	var/datum/admins/holder = C.holder

	for(var/client/target in GLOB.clients)
		if(check_rights(R_INVESTIGATE, FALSE, target))
			receive_communication(C, target, SPAN_AOOC("<EM>[get_options_bar(C, 0, 1, 1)]:</EM> [SPAN_CLASS("message linkify", "[message]")]"))
		else if(target.mob?.mind?.special_role)
			var/display_name = C.key
			var/player_display = holder ? "[display_name]([usr.client.holder.rank])" : display_name
			receive_communication(C, target, SPAN_AOOC("<EM>[player_display]:</EM> [SPAN_CLASS("message linkify", "[message]")]"))


/singleton/communication_channel/aooc/do_broadcast(message)
	for (var/client/target in GLOB.clients)
		if (check_rights(R_INVESTIGATE, FALSE, target) || target.mob?.mind?.special_role)
			receive_broadcast(target, SPAN_AOOC("<strong>SYSTEM BROADCAST:</strong> [SPAN_CLASS("message linkify", "[message]")]"))
