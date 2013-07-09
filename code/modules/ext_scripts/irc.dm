/proc/send2irc(var/channel, var/msg)
	if(config.use_irc_bot)
		ext_python("ircbot_message.py", "[channel] [msg]")
	return

/proc/send2mainirc(var/msg)
	if(config.use_irc_bot && config.main_irc)
		ext_python("ircbot_message.py", "[config.main_irc] [msg]")
	return

/proc/send2adminirc(var/msg)
	if(config.use_irc_bot && config.admin_irc)
		ext_python("ircbot_message.py", "[config.admin_irc] [msg]")
	return