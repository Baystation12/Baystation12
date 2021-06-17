SUBSYSTEM_DEF(chat)
	name = "Chat"
	wait = 1
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	priority = SS_PRIORITY_CHAT
	init_order = SS_INIT_CHAT
	var/list/payload = list()

/datum/controller/subsystem/chat/fire()
	for(var/i in payload)
		var/client/C = i
		to_target(C, output(payload[C], "browseroutput:output"))
		payload -= C

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/chat/proc/queue(target, message, handle_whitespace = TRUE, trailing_newline = TRUE)
	if(!target || !message)
		return

	if(!istext(message))
		CRASH("to_chat called with invalid input type")

	if(target == world)
		target = GLOB.clients

	//Some macros remain in the string even after parsing and fuck up the eventual output
	var/original_message = message
	message = replacetext(message, "\improper", "")
	message = replacetext(message, "\proper", "")
	if(handle_whitespace)
		message = replacetext(message, "\n", "<br>")
		message = replacetext(message, "\t", "[FOURSPACES][FOURSPACES]")
	if (trailing_newline)
		message += "<br>"


	//url_encode it TWICE, this way any UTF-8 characters are able to be decoded by the Javascript.
	//Do the double-encoding here to save nanoseconds
	var/twiceEncoded = url_encode(url_encode(message))

	if(islist(target))
		for(var/I in target)
			var/client/C = CLIENT_FROM_VAR(I) //Grab us a client if possible

			if(!C)
				return

			//Send it to the old style output window.
			legacy_chat(C, original_message)

			if(!C?.chatOutput || C.chatOutput.broken) //A player who hasn't updated his skin file.
				continue

			if(!C.chatOutput.loaded) //Client still loading, put their messages in a queue
				C.chatOutput.messageQueue += message
				continue

			payload[C] += twiceEncoded

	else
		var/client/C = CLIENT_FROM_VAR(target) //Grab us a client if possible

		if(!C)
			return

		//Send it to the old style output window.
		legacy_chat(C, original_message)

		if(!C?.chatOutput || C.chatOutput.broken) //A player who hasn't updated his skin file.
			return

		if(!C.chatOutput.loaded) //Client still loading, put their messages in a queue
			C.chatOutput.messageQueue += message
			return

		payload[C] += twiceEncoded
