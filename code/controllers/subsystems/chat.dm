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
	message = replacetext_char(message, "\improper", "")
	message = replacetext_char(message, "\proper", "")
	if (handle_whitespace)
		message = replacetext_char(message, "\n", "<br>")
		message = replacetext_char(message, "\t", "[FOURSPACES][FOURSPACES]")
	if (trailing_newline)
		message += "<br>"
	var/twiceEncoded = url_encode(url_encode(message)) // Double encode so that JS can consume utf-8
	if (islist(target))
		for(var/I in target)
			queuePartTwo(I, message, original_message, twiceEncoded)
	else
		queuePartTwo(target, message, original_message, twiceEncoded)


/datum/controller/subsystem/chat/proc/queuePartTwo(client/C, message, original, encoded)
	C = resolve_client(C)
	if (!C)
		return
	legacy_chat(C, original)
	if (!C?.chatOutput || C.chatOutput.broken)
		return
	if (!C.chatOutput.loaded)
		C.chatOutput.messageQueue += message
		return
	payload[C] += encoded


SUBSYSTEM_DEF(ping)
	name = "Ping"
	flags = SS_NO_INIT
	runlevels = RUNLEVELS_ALL
	wait = 30 SECONDS
	var/static/list/chats = list()


/datum/controller/subsystem/ping/fire(resumed)
	FOR_BLIND(chatOutput/O, chats)
		if (O.loaded && !O.broken)
			O.updatePing()
		if (MC_TICK_CHECK)
			return
