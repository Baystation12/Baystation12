var/global/datum/ntnet/ntnet_global = new()


// This is the NTNet datum. There can be only one NTNet datum in game at once. Modular computers read data from this.
/datum/ntnet/
	var/list/relays = list()
	var/list/logs = list()
	var/list/available_station_software = list()
	var/list/available_antag_software = list()

	// Amount of logs the system tries to keep in memory. Keep below 999 to prevent byond from acting weirdly.
	// High values make displaying logs much laggier.
	var/setting_maxlogcount = 100

	var/setting_softwaredownload = 1
	var/setting_peertopeer = 1
	var/setting_communication = 1
	var/setting_systemcontrol = 1


// If new NTNet datum is spawned, it replaces the old one.
/datum/ntnet/New()
	if(ntnet_global && (ntnet_global != src))
		ntnet_global = src // There can be only one.
	for(var/obj/machinery/ntnet_relay/R in machines)
		relays.Add(R)
		R.NTNet = src
	build_software_lists()
	add_log("NTNet logging system activated.")

// Simplified logging: Adds a log. log_string is mandatory parameter, source is optional.
/datum/ntnet/proc/add_log(var/log_string, var/datum/computer_hardware/network_card/source = null)
	var/log_text = "[worldtime2text()] - "
	if(source)
		log_text += "[source.get_network_tag()] - "
	else
		log_text += " *SYSTEM* - "
	log_text += log_string
	logs.Add(log_text)

	if(logs.len > setting_maxlogcount)
		// We have too many logs, remove the oldest entries until we get into the limit
		for(var/L in logs)
			if(logs.len > setting_maxlogcount)
				logs.Remove(L)
			else
				break

// Checks whether NTNet operates. If parameter is passed checks whether specific function is enabled.
/datum/ntnet/proc/check_function(var/specific_action = 0)
	if(!relays || !relays.len) // No relays found. NTNet is down
		return 0

	var/operating = 0

	// Check all relays. If we have at least one working relay, network is up.
	for(var/obj/machinery/ntnet_relay/R in relays)
		if(R.is_operational())
			operating = 1
			break

	if(specific_action == NTNET_SOFTWAREDOWNLOAD)
		return (operating && setting_softwaredownload)
	if(specific_action == NTNET_PEERTOPEER)
		return (operating && setting_peertopeer)
	if(specific_action == NTNET_COMMUNICATION)
		return (operating && setting_communication)
	if(specific_action == NTNET_SYSTEMCONTROL)
		return (operating && setting_systemcontrol)
	return operating

// Builds lists that contain downloadable software.
/datum/ntnet/proc/build_software_lists()
	available_station_software = list()
	available_antag_software = list()
	for(var/F in typesof(/datum/computer_file/program))
		var/datum/computer_file/program/prog = new F
		// Invalid type (shouldn't be possible but just in case), invalid filetype (not executable program) or invalid filename (unset program)
		if(!prog || !istype(prog) || prog.filename == "UnknownProgram" || prog.filetype != "PRG")
			continue
		// Check whether the program should be available for station/antag download, if yes, add it to lists.
		if(prog.available_on_ntnet)
			available_station_software.Add(prog)
		if(prog.available_on_syndinet)
			available_antag_software.Add(prog)

// Attempts to find a downloadable file according to filename var
/datum/ntnet/proc/find_ntnet_file_by_name(var/filename)
	for(var/datum/computer_file/program/P in available_station_software)
		if(filename == P.filename)
			return P
	for(var/datum/computer_file/program/P in available_antag_software)
		if(filename == P.filename)
			return P













