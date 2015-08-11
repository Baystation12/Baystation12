/datum/controller/process/inactivity/setup()
	name = "inactivity"
	schedule_interval = 600 // Once every minute (approx.)

/datum/controller/process/inactivity/doWork()
	if(config.kick_inactive)
		for(var/client/C in clients)
			if(!C.holder && C.is_afk(config.kick_inactive MINUTES))
				if(!istype(C.mob, /mob/dead))
					log_access("AFK: [key_name(C)]")
					C << "<SPAN CLASS='warning'>You have been inactive for more than [config.kick_inactive] minute\s and have been disconnected.</SPAN>"
					del(C)	// Don't qdel, cannot override finalize_qdel behaviour for clients.
			scheck()
