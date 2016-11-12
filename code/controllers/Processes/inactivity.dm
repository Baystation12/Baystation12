/datum/controller/process/inactivity/setup()
	name = "inactivity"
	schedule_interval = 600 // Once every minute (approx.)

/datum/controller/process/inactivity/doWork()
	if(config.kick_inactive)
		for(last_object in clients)
			var/client/C = last_object
			if(!C.holder && C.is_afk(config.kick_inactive MINUTES))
				if(!isobserver(C.mob))
					log_access("AFK: [key_name(C)]")
					to_chat(C, "<SPAN CLASS='warning'>You have been inactive for more than [config.kick_inactive] minute\s and have been disconnected.</SPAN>")
					del(C)	// Don't qdel, cannot override finalize_qdel behaviour for clients.
			SCHECK
