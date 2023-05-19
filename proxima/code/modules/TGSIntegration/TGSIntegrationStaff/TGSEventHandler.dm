/datum/tgs_event_handler/impl
	var/datum/timedevent/reattach_timer

/datum/tgs_event_handler/impl/HandleEvent(event_code, ...)
	switch(event_code)
		if(TGS_EVENT_REBOOT_MODE_CHANGE)
			var/list/reboot_mode_lookup = list ("[TGS_REBOOT_MODE_NORMAL]" = "be normal", "[TGS_REBOOT_MODE_SHUTDOWN]" = "shutdown the server", "[TGS_REBOOT_MODE_RESTART]" = "hard restart the server")
			var/old_reboot_mode = args[2]
			var/new_reboot_mode = args[3]
			message_admins("TGS: Reboot will no longer [reboot_mode_lookup["[old_reboot_mode]"]], it will instead [reboot_mode_lookup["[new_reboot_mode]"]]")
		if(TGS_EVENT_PORT_SWAP)
			message_admins("TGS: Changing port from [world.port] to [args[2]]")
		if(TGS_EVENT_INSTANCE_RENAMED)
			message_admins("TGS: Instance renamed to from [world.TgsInstanceName()] to [args[2]]")
		if(TGS_EVENT_COMPILE_START)
			message_admins("TGS: Deployment started, new game version incoming...")
		if(TGS_EVENT_COMPILE_CANCELLED)
			message_admins("TGS: Deployment cancelled!")
		if(TGS_EVENT_COMPILE_FAILURE)
			message_admins("TGS: Deployment failed!")
		if(TGS_EVENT_DEPLOYMENT_COMPLETE)
			message_admins("TGS: Deployment complete!")
			to_world(FONT_LARGE(SPAN_BOLD("Сервер был обновлен, изменения применятся на следующем раунде...")))
		if(TGS_EVENT_WATCHDOG_DETACH)
			message_admins("TGS перезапускается...")
			reattach_timer = addtimer(CALLBACK(src, /datum/tgs_event_handler/impl/proc/LateOnReattach), 1 MINUTE, TIMER_STOPPABLE)
		if(TGS_EVENT_WATCHDOG_REATTACH)
			var/datum/tgs_version/old_version = world.TgsVersion()
			var/datum/tgs_version/new_version = args[2]
			if(!old_version.Equals(new_version))
				to_world(FONT_LARGE(SPAN_BOLD("TGS обновлен до версии v[new_version.deprefixed_parameter]")))
			else
				message_admins("TGS: Снова в сети")
			if(reattach_timer)
				deltimer(reattach_timer)
				reattach_timer = null
		if(TGS_EVENT_WATCHDOG_SHUTDOWN)
			to_world(FONT_LARGE(SPAN_DANGER(("Сервер немедленно выключается!"))))

/datum/tgs_event_handler/impl/proc/LateOnReattach()
	message_admins("Warning: TGS не уведомил нас о своем возвращении в течении минуты! Что то навернулось?")
