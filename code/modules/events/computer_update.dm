/datum/event/computer_update/start()
	commence_updates(severity)

/proc/commence_updates(severity)
	var/updates_to_install = 0
	switch(severity)
		if(EVENT_LEVEL_MUNDANE)
			updates_to_install = rand(10000, 100000)
		if(EVENT_LEVEL_MODERATE)
			updates_to_install = rand(100000, 500000)
		if(EVENT_LEVEL_MAJOR)
			updates_to_install = rand(500000, 1000000)

	for(var/obj/C in (SSobj.processing + SSmachines.machinery))
		if((C.z in GLOB.using_map.station_levels))
			var/datum/extension/interactive/ntos/os = get_extension(C, /datum/extension/interactive/ntos)
			if(os && os.get_ntnet_status() && os.receives_updates)
				os.updates = updates_to_install
