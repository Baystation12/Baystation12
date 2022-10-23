/mob/observer/ghost/say(message)
	sanitize_and_communicate(/singleton/communication_channel/dsay, client, message)
