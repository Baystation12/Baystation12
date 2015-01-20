proc/log_and_message_admins(var/message as text)
	log_admin(usr ? "[usr]([usr.ckey]) [message]" : "EVENT [message]")
	message_admins(usr ? "[usr]([usr.ckey]) [message]" : "EVENT [message]")

proc/admin_log_and_message_admins(var/message as text)
	log_admin(usr ? "[key_name(usr)] [message]" : "EVENT [message]")
	message_admins(usr ? "[key_name(usr)] [message]" : "EVENT [message]", 1)
