#define DSAY_CAN_COMMUNICATE 1
#define DSAY_ASK_BASE 2

/decl/communication_channel/dsay
	name = "DSAY"
	config_setting = "dsay_allowed"
	expected_communicator_type = /client
	flags = COMMUNICATION_LOG_CHANNEL_NAME
	log_proc = /proc/log_say
	mute_setting = MUTE_DEADCHAT
	show_preference_setting = /datum/client_preference/show_dsay

/decl/communication_channel/dsay/communicate(communicator, message, speech_method = /decl/dsay_communication/say)
	..()

/decl/communication_channel/dsay/can_communicate(var/client/communicator, var/message, var/speech_method_type)
	var/decl/dsay_communication/speech_method = decls_repository.get_decl(speech_method_type)
	switch(speech_method.can_communicate(communicator, message))
		if(DSAY_CAN_COMMUNICATE)
			return TRUE
		if(DSAY_ASK_BASE)
			return ..()

/decl/communication_channel/dsay/do_communicate(var/client/communicator, var/message, var/speech_method_type)
	var/decl/dsay_communication/speech_method = decls_repository.get_decl(speech_method_type)

	speech_method.adjust_channel(src)

	if(communicator.is_shadowbanned())
		var/msg = "SHADOWBAN: [log_info_line(communicator)] tried to communicate: [name] - [message]"
		log_admin(msg)
		message_admins(msg)

	for(var/mob/M in player_list)
		if(!speech_method.can_receive(communicator, M) || (communicator.is_shadowbanned() && communicator.mob && communicator.mob != M))
			continue
		var/sent_message = speech_method.get_message(communicator, M, message)
		receive_communication(communicator, M, "<span class='deadsay'>" + create_text_tag("dead", "DEAD:", M.client) + " [sent_message]</span>")

/decl/dsay_communication/proc/can_communicate(var/client/communicator, var/message)
	if(!istype(communicator))
		return FALSE
	if(communicator.mob.stat != DEAD)
		to_chat(communicator, "<span class='warning'>You're not sufficiently dead to use DSAY!</span>")
		return FALSE
	return DSAY_ASK_BASE

/decl/dsay_communication/proc/can_receive(var/client/C, var/mob/M)
	if(istype(C) && C.mob == M)
		return TRUE
	if(M.is_preference_disabled(/datum/client_preference/show_dsay))
		return FALSE
	if(istype(C) && M.is_key_ignored(C.key))
		return FALSE
	if(M.client.holder && !is_mentor(M.client))
		return TRUE
	if(M.stat != DEAD)
		return FALSE
	if(isnewplayer(M))
		return FALSE
	return TRUE

/decl/dsay_communication/proc/get_name(var/client/C, var/mob/M)
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
	if(isghost(C.mob))
		DM = C.mob
	if(M.client.holder) 							// What admins see
		lname = "[keyname][(DM && DM.anonsay) ? "*" : (DM ? "" : "^")] ([name])"
	else
		if(DM && DM.anonsay)						// If the person is actually observer they have the option to be anonymous
			lname = "Ghost of [name]"
		else if(DM)									// Non-anons
			lname = "[keyname] ([name])"
		else										// Everyone else (dead people who didn't ghost yet, etc.)
			lname = name
	return "<span class='name'>[lname]</span>"

/decl/dsay_communication/proc/get_message(var/client/C, var/mob/M, var/message)
	var say_verb = pick("complains","moans","whines","laments","blubbers")
	return "[get_name(C, M)] [say_verb], <span class='message'>\"[message]\"</span>"

/decl/dsay_communication/emote/get_message(var/client/C, var/mob/M, var/message)
	return "[get_name(C, M)] <span class='message'>[message]</span>"

/decl/dsay_communication/proc/adjust_channel(var/decl/communication_channel/dsay)
	dsay.flags |= COMMUNICATION_ADMIN_FOLLOW|COMMUNICATION_GHOST_FOLLOW // Add admin and ghost follow

/decl/dsay_communication/say/adjust_channel(var/decl/communication_channel/dsay)
	dsay.log_proc = /proc/log_say
	..()

/decl/dsay_communication/emote/adjust_channel(var/decl/communication_channel/dsay)
	dsay.log_proc = /proc/log_emote
	..()

/decl/dsay_communication/admin/can_communicate(var/client/communicator, var/message, var/decl/communication_channel/dsay)
	if(!istype(communicator))
		return FALSE
	if(!communicator.holder)
		to_chat(communicator, "<span class='warning'>You do not have sufficent permissions to use DSAY!</span>")
		return FALSE
	return DSAY_ASK_BASE

/decl/dsay_communication/admin/get_message(var/client/communicator, var/mob/M, var/message)
	var/stafftype = uppertext(communicator.holder.rank)
	return "<span class='name'>[stafftype]([communicator.key])</span> says, <span class='message'>\"[message]\"</span>"

/decl/dsay_communication/admin/adjust_channel(var/decl/communication_channel/dsay)
	dsay.log_proc = /proc/log_say
	dsay.flags |= COMMUNICATION_ADMIN_FOLLOW  // Add admin follow
	dsay.flags &= ~COMMUNICATION_GHOST_FOLLOW // Remove ghost follow

/decl/dsay_communication/direct/adjust_channel(var/decl/communication_channel/dsay, var/communicator)
	dsay.log_proc = /proc/log_say
	dsay.flags &= ~(COMMUNICATION_ADMIN_FOLLOW|COMMUNICATION_GHOST_FOLLOW) // Remove admin and ghost follow

/decl/dsay_communication/direct/can_communicate()
	return DSAY_CAN_COMMUNICATE

/decl/dsay_communication/direct/get_message(var/client/communicator, var/mob/M, var/message)
	return message

#undef DSAY_CAN_COMMUNICATE
#undef DSAY_ASK_BASE
