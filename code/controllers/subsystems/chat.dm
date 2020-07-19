SUBSYSTEM_DEF(chat)
	name = "Chat"
	flags = SS_TICKER
	wait = 1 // SS_TICKER means this runs every tick
	priority = SS_PRIORITY_CHAT
	init_order = SS_INIT_CHAT

	var/list/msg_queue = list()

/datum/controller/subsystem/chat/PreInit()
	spawn(0)
		init_vchat()
	. = ..()
	

/datum/controller/subsystem/chat/Initialize(timeofday)
	//init_vchat()
	..()

/datum/controller/subsystem/chat/fire()
	var/list/msg_queue = src.msg_queue // Local variable for sanic speed.
	for(var/i in msg_queue)
		var/client/C = i
		var/list/messages = msg_queue[C]
		msg_queue -= C
		if (C)
			to_target(C, output(jsEncode(messages), "htmloutput:putmessage"))

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/chat/stat_entry()
	..("C:[msg_queue.len]")

/datum/controller/subsystem/chat/proc/queue(target, time, message, handle_whitespace = TRUE)
	if(!target || !message)
		return

	if(!istext(message))
		CRASH("to_chat called with invalid input type")

	// Currently to_chat(world, ...) gets sent individually to each client.  Consider.
	if(target == world)
		target = GLOB.clients

	//Some macros remain in the string even after parsing and fuck up the eventual output
	var/original_message = message
	message = replacetext(message, "\n", "<br>")
	message = replacetext(message, "\improper", "")
	message = replacetext(message, "\proper", "")

	if(isnull(time))
		time = world.time

	var/list/messageStruct = list("time" = time, "message" = message);

	if(islist(target))
		for(var/I in target)
			var/client/C = CLIENT_FROM_VAR(I) //Grab us a client if possible

			if(!C)
				continue // No client? No care.
			
			legacy_chat(C, original_message)

			if(!C?.chatOutput || C.chatOutput.broken) //A player who hasn't updated his skin file.
				//Send it to the old style output window.
				to_target(C, original_message)
				continue

			// Client still loading, put their messages in a queue - Actually don't, logged already in database.
			 if(!C.chatOutput.loaded && C.chatOutput.message_queue && islist(C.chatOutput.message_queue))
			 	C.chatOutput.message_queue[++C.chatOutput.message_queue.len] = messageStruct
				continue
			
			LAZYINITLIST(msg_queue[C])
			msg_queue[C] += list(messageStruct)
	else
		var/client/C = CLIENT_FROM_VAR(target) //Grab us a client if possible

		if(!C)
			return
		
		legacy_chat(C, original_message)

		if(!C?.chatOutput || C.chatOutput.broken) //A player who hasn't updated his skin file.
			return

		LAZYINITLIST(msg_queue[C])
		msg_queue[C] += list(messageStruct)