GLOBAL_LIST_INIT(exonets, new)

/datum/exonet
	var/ennid										// This is the name of the network. Its unique ID.
	var/list/network_devices 	= list()			// Devices utilizing the network.
	var/list/mainframes 		= list()			// File servers serving files.
	var/list/modems				= list()			// Modems capable of connecting to PLEXUS, the space internet.
	var/list/broadcasters		= list()			// A list of anything broadcasting the good signal. Only one will be the /router.

	var/obj/machinery/exonet/mainframe/log_server	// A mainframe that's the chosen main-log server.
	var/obj/machinery/exonet/broadcaster/router/router // The router that hosts the network. There can be only ONE!

/datum/exonet/New(var/new_ennid)
	ennid = new_ennid

/datum/exonet/proc/add_device(var/device, var/keydata)
	if(!router)
		return 0 // Uh?? No router? Guess the network is busted.
	if(router.lockdata != keydata)
		return 0 // Authentication failed.

	if(istype(device, /obj/machinery/exonet/mainframe))
		LAZYDISTINCTADD(mainframes, device)
	else if(istype(device, /obj/machinery/exonet/broadcaster))
		LAZYDISTINCTADD(broadcasters, device)
	else if(istype(device, /obj/machinery/exonet/modem))
		LAZYDISTINCTADD(modems, device)
	else if(istype(device, /obj/machinery/exonet/broadcaster/router) && !router)
		router = device // Special setty-uppy-timy for routers.
	LAZYDISTINCTADD(network_devices, device)

/datum/exonet/proc/remove_device(var/device)
	if(istype(device, /obj/machinery/exonet/mainframe))
		LAZYREMOVE(mainframes, device)
	else if(istype(device, /obj/machinery/exonet/broadcaster))
		LAZYREMOVE(broadcasters, device)
	else if(istype(device, /obj/machinery/exonet/modem))
		LAZYREMOVE(modems, device)
	LAZYREMOVE(network_devices, device)

/datum/exonet/proc/set_router(var/device)
	router = device
	LAZYADD(network_devices, device)
	LAZYADD(broadcasters, device)

// Simplified logging: Adds a log. log_string is mandatory parameter, source is optional.
/datum/exonet/proc/add_log(var/log_string, var/obj/item/weapon/stock_parts/computer/network_card/source = null)
	if(!log_server)
		return // No log server? No logs.
	var/datum/computer_file/data/logfile/logfile = log_server.get_log_file()
	if(!istype(logfile))
		return // No log file, or no space to create one. Or some other error.

	var/log_text = "[stationtime2text()] - "
	if(source)
		log_text += "[source.get_network_tag()] - "
	else
		log_text += "*SYSTEM* - "
	log_text += log_string
	var/list/logs = splittext(logfile.stored_data, "\[br\]")
	if(length(logs) >= log_server.setting_max_log_count)
		logs.Cut(1, 2)
	logs.Add(log_text)
	logfile.stored_data = jointext(logs, "\[br\]")

/datum/exonet/proc/get_signal_strength(var/obj/device, var/netspeed)
	var/best_signal = -1
	var/turf/device_turf = get_turf(device)
	if(!device_turf)
		return best_signal
	for(var/obj/machinery/exonet/broadcaster/broadcaster in broadcasters)
		if(broadcaster.z != device_turf.z || !broadcaster.operable())
			continue // We only check same level.
		var/strength = (broadcaster.signal_strength * netspeed) - get_dist(broadcaster, device_turf)
		if(strength <= 0)
			continue
		best_signal = max(strength, best_signal)
	return best_signal