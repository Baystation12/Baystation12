#define DSAY_CAN_COMMUNICATE 1
#define DSAY_ASK_BASE 2

/singleton/communication_channel/dsay
	name = "DSAY"
	config_setting = "dsay_allowed"
	expected_communicator_type = /client
	flags = COMMUNICATION_LOG_CHANNEL_NAME
	log_proc = /proc/log_say
	mute_setting = MUTE_DEADCHAT
	show_preference_setting = /datum/client_preference/show_dsay

/singleton/communication_channel/dsay/communicate(communicator, message, speech_method = /singleton/dsay_communication/say)
	..()

/singleton/communication_channel/dsay/can_communicate(client/communicator, message, speech_method_type)
	var/singleton/dsay_communication/speech_method = GET_SINGLETON(speech_method_type)
	switch(speech_method.can_communicate(communicator, message))
		if(DSAY_CAN_COMMUNICATE)
			return TRUE
		if(DSAY_ASK_BASE)
			return ..()

/singleton/communication_channel/dsay/do_communicate(client/communicator, message, speech_method_type)
	var/singleton/dsay_communication/speech_method = GET_SINGLETON(speech_method_type)

	speech_method.adjust_channel(src)

	for(var/mob/M in GLOB.player_list)
		if(!speech_method.can_receive(communicator, M))
			continue
		var/sent_message = speech_method.get_message(communicator, M, message)
		receive_communication(communicator, M, SPAN_CLASS("deadsay", "[create_text_tag("dead", "DEAD:", M.client)] [sent_message]"))

/singleton/dsay_communication/proc/can_communicate(client/communicator, message)
	if(!istype(communicator))
		return FALSE
	if(communicator.mob.stat != DEAD)
		to_chat(communicator, SPAN_WARNING("You're not sufficiently dead to use DSAY!"))
		return FALSE
	return DSAY_ASK_BASE

/singleton/dsay_communication/proc/can_receive(client/C, mob/M)
	if(istype(C) && C.mob == M)
		return TRUE
	if(M.get_preference_value(/datum/client_preference/show_dsay) == GLOB.PREF_HIDE)
		return FALSE
	if(istype(C) && M.is_key_ignored(C.key))
		return FALSE
	if (M.client && M.client.holder)
		return TRUE
	if(M.stat != DEAD)
		return FALSE
	if(isnewplayer(M))
		return FALSE
	return TRUE

/singleton/dsay_communication/proc/get_name(client/C, mob/M)
	var/name
	var/keyname

	keyname = C.key
	if(C.mob) //Most of the time this is the dead/observer mob; we can totally use him if there is no better name
		var/mindname
		var/realname = C.mob.real_name
		if(C.mob.mind)
			mindname = C.mob.mind.name
			if(C.mob.mind.original && C.mob.mind.original.real_name)
				realname = C.mob.mind.original.real_name
		if(mindname && mindname != realname)
			name = "[realname] died as [mindname]"
		else
			name = realname

	var/lname
	var/mob/observer/ghost/DM
	var/hide_deadchat_ckey = C.get_preference_value(/datum/client_preference/show_ckey_deadchat) == GLOB.PREF_HIDE

	if(isghost(C.mob))
		DM = C.mob
	if(M.client.holder) 							// What admins see
		lname = "[keyname][(DM && hide_deadchat_ckey) ? "*" : (DM ? "" : "^")] ([name])"
	else
		if(DM && hide_deadchat_ckey)						// If the person is actually observer they have the option to be anonymous
			lname = "Ghost of [name]"
		else if(DM)									// Non-anons
			lname = "[keyname] ([name])"
		else										// Everyone else (dead people who didn't ghost yet, etc.)
			lname = name
	return SPAN_CLASS("name", "[lname]")

/singleton/dsay_communication/proc/get_message(client/C, mob/M, message)
	var/say_verb = pick("complains","moans","whines","laments","blubbers")
	return "[get_name(C, M)] [say_verb], [SPAN_CLASS("message linkify", "\"[message]\"")]"

/singleton/dsay_communication/emote/get_message(client/C, mob/M, message)
	return "[get_name(C, M)] [SPAN_CLASS("message linkify", "[message]")]"

/singleton/dsay_communication/proc/adjust_channel(singleton/communication_channel/dsay)
	dsay.flags |= COMMUNICATION_ADMIN_FOLLOW|COMMUNICATION_GHOST_FOLLOW // Add admin and ghost follow

/singleton/dsay_communication/say/adjust_channel(singleton/communication_channel/dsay)
	dsay.log_proc = /proc/log_say
	..()

/singleton/dsay_communication/emote/adjust_channel(singleton/communication_channel/dsay)
	dsay.log_proc = /proc/log_emote
	..()

/singleton/dsay_communication/admin/can_communicate(client/communicator, message, singleton/communication_channel/dsay)
	if(!istype(communicator))
		return FALSE
	if(!communicator.holder)
		to_chat(communicator, SPAN_WARNING("You do not have sufficent permissions to use DSAY!"))
		return FALSE
	return DSAY_ASK_BASE

/singleton/dsay_communication/admin/get_message(client/communicator, mob/M, message)
	var/stafftype = uppertext(communicator.holder.rank)
	return "[SPAN_CLASS("name", "[stafftype]([communicator.key])")] says, [SPAN_CLASS("message linkify", "\"[message]\"")]"

/singleton/dsay_communication/admin/adjust_channel(singleton/communication_channel/dsay)
	dsay.log_proc = /proc/log_say
	dsay.flags |= COMMUNICATION_ADMIN_FOLLOW  // Add admin follow
	dsay.flags &= ~COMMUNICATION_GHOST_FOLLOW // Remove ghost follow

/singleton/dsay_communication/direct/adjust_channel(singleton/communication_channel/dsay, communicator)
	dsay.log_proc = /proc/log_say
	dsay.flags &= ~(COMMUNICATION_ADMIN_FOLLOW|COMMUNICATION_GHOST_FOLLOW) // Remove admin and ghost follow

/singleton/dsay_communication/direct/can_communicate()
	return DSAY_CAN_COMMUNICATE

/singleton/dsay_communication/direct/get_message(client/communicator, mob/M, message)
	return message

#undef DSAY_CAN_COMMUNICATE
#undef DSAY_ASK_BASE
