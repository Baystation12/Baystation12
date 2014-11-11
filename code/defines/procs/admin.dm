proc/log_and_message_admins(var/message as text)
	log_admin("[usr]([usr.ckey]) " + message)
	message_admins("[usr]([usr.ckey]) " + message)
