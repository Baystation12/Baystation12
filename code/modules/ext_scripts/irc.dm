/proc/send2irc(var/channel, var/msg)
	if(config.use_irc_bot && config.irc_bot_host)
		if(config.irc_bot_export)
			export2irc(list(type="msg", mesg=msg, chan=channel, pwd=config.comms_password))
		else
			if(config.use_lib_nudge)
				var/nudge_lib
				if(world.system_type == MS_WINDOWS)
					nudge_lib = "lib\\nudge.dll"
				else
					nudge_lib = "lib/nudge.so"

				spawn(0)
					call(nudge_lib, "nudge")("[config.comms_password]","[config.irc_bot_host]","[channel]","[msg]")
			else
				spawn(0)
					ext_python("ircbot_message.py", "[config.comms_password] [config.irc_bot_host] [channel] [msg]")
	return

/proc/export2irc(params)
	if(config.use_irc_bot && config.irc_bot_export && config.irc_bot_host)
		spawn(-1) // spawn here prevents hanging in the case that the bot isn't reachable
			world.Export("http://[config.irc_bot_host]:45678?[list2params(params)]")

/proc/runtimes2irc(runtimes, revision)
	export2irc(list(pwd=config.comms_password, type="runtime", runtimes=runtimes, revision=revision))

/proc/send2mainirc(var/msg)
	if(config.main_irc)
		send2irc(config.main_irc, msg)
	return

/proc/send2adminirc(var/msg)
	if(config.admin_irc)
		send2irc(config.admin_irc, msg)
	return

/proc/adminmsg2adminirc(client/source, client/target, msg)
	if(config.admin_irc)
		if(config.irc_bot_export)
			var/list/params[0]

			params["pwd"] = config.comms_password
			params["chan"] = config.admin_irc
			params["msg"] = msg
			params["src_key"] = source.key
			params["src_char"] = source.mob.real_name || source.mob.name
			if(!target)
				params["type"] = "adminhelp"
			else if(istext(target))
				params["type"] = "ircpm"
				params["target"] = target
				params["rank"] = source.holder ? source.holder.rank : "Player"
			else
				params["type"] = "adminpm"
				params["trg_key"] = target.key
				params["trg_char"] = target.mob.real_name || target.mob.name

			export2irc(params)
		else
			if(istype(target))
				send2adminirc("Reply: [key_name(source)]->[key_name(target)]: [msg]")
			else if(istext(target))
				var/rank = source.holder ? source.holder.rank : "Player"
				send2adminirc("[rank] PM to [target] from [key_name(source)]: [msg]")
			else
				send2adminirc("HELP from [key_name(source)]: [msg]")

/hook/startup/proc/ircNotify()
	send2mainirc("Server starting up on byond://[config.serverurl ? config.serverurl : (config.server ? config.server : "[world.address]:[world.port]")]")
	return 1

