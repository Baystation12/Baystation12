SUBSYSTEM_DEF(chat)
	name = "Chat"
	wait = 1
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	priority = SS_PRIORITY_CHAT
	init_order = SS_INIT_CHAT
	var/static/list/payload = list()


/datum/controller/subsystem/chat/fire(resumed)
	FOR_BLIND(client/C, payload)
		send_output(C, payload[C], "browseroutput:output")
		payload -= C
		if (MC_TICK_CHECK)
			return


/datum/controller/subsystem/chat/proc/queue(target, message, handle_whitespace = TRUE, trailing_newline = TRUE)
	if (!target || !message)
		return
	if (!istext(message))
		CRASH("to_chat called with invalid input type")
	if (target == world)
		target = GLOB.clients
	var/original_message = message //Some macros resist parsing elsewhere; strip them here
	message = replacetext(message, "\improper", "")
	message = replacetext(message, "\proper", "")
	if (handle_whitespace)
		message = replacetext(message, "\n", "<br>")
		message = replacetext(message, "\t", "[FOURSPACES][FOURSPACES]")
	if (trailing_newline)
		message += "<br>"
	var/twiceEncoded = url_encode(url_encode(message)) // Double encode so that JS can consume utf-8
	if (islist(target))
		for(var/I in target)
			var/client/C = resolve_client(I)
			if (!C)
				return
			legacy_chat(C, original_message) //Send it to the old style output window.
			if (!C?.chatOutput || C.chatOutput.broken) //A player who hasn't updated his skin file.
				continue
			if (!C.chatOutput.loaded) //Client still loading, put their messages in a queue
				C.chatOutput.messageQueue += message
				continue
			payload[C] += twiceEncoded
	else
		var/client/C = resolve_client(target)
		if (!C)
			return
		legacy_chat(C, original_message) //Send it to the old style output window.
		if (!C?.chatOutput || C.chatOutput.broken) //A player who hasn't updated his skin file.
			return
		if (!C.chatOutput.loaded) //Client still loading, put their messages in a queue
			C.chatOutput.messageQueue += message
			return
		payload[C] += twiceEncoded


SUBSYSTEM_DEF(ping)
	name = "Ping"
	flags = SS_NO_INIT
	runlevels = RUNLEVELS_ALL
	wait = 30 SECONDS
	var/static/list/chats = list()


/datum/controller/subsystem/ping/fire(resumed)
	FOR_BLIND(datum/chatOutput/O, chats)
		if (O.loaded && !O.broken)
			O.updatePing()
		if (MC_TICK_CHECK)
			return
