/mob/observer/ghost/say(var/message)
	if(config.persistent)
		to_chat(usr, SPAN_NOTICE("You attempt to call out, but your words are consumed by the void..."))
		return
	sanitize_and_communicate(/decl/communication_channel/dsay, client, message)
