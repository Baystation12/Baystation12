var/global/datum/ntnet/ntnet_global = new()


// This is the NTNet datum. There can be only one NTNet datum in game at once. Modular computers read data from this.
/datum/ntnet/
	var/list/relays = list()
	var/list/logs = list()
	var/list/available_station_software = list()
	var/list/available_software_by_category = list()
	var/list/available_antag_software = list()
	var/list/available_news = list()
	var/list/chat_channels = list()
	var/list/fileservers = list()
	/// Holds all the email accounts that exists. Hopefully won't exceed 999
	var/list/email_accounts = list()
	/// A list containing one of each available report datums, used for the report editor program.
	var/list/available_reports = list()
	var/list/banned_nids = list()
	/// A list of nid - os datum pairs. An OS in this list is not necessarily connected to NTNet or visible on it.
	var/list/registered_nids = list()
	/// Amount of log entries the system tries to keep in memory. Keep below 999 to prevent byond from acting weirdly. High values make displaying logs much laggier.
	var/setting_maxlogcount = 100

	/// Programs requiring NTNET_SOFTWAREDOWNLOAD won't work if this is set to FALSE and public-facing device they are connecting with is wireless.
	var/setting_softwaredownload = TRUE
	/// Programs requiring NTNET_PEERTOPEER won't work if this is set to FALSE and public-facing device they are connecting with is wireless.
	var/setting_peertopeer = TRUE
	/// Programs requiring NTNET_COMMUNICATION won't work if this is set to FALSE and public-facing device they are connecting with is wireless.
	var/setting_communication = TRUE
	/// Programs requiring NTNET_SYSTEMCONTROL won't work if this is set to FALSE and public-facing device they are connecting with is wireless.
	var/setting_systemcontrol = TRUE

	/// Setting to TRUE will disable all wireless connections, independently off relays status.
	var/setting_disabled = FALSE

	/// Whether the IDS warning system is enabled
	var/intrusion_detection_enabled = TRUE
	/// Set when there is an IDS warning due to malicious (antag) software.
	var/intrusion_detection_alarm = FALSE

// If new NTNet datum is spawned, it replaces the old one.
/datum/ntnet/New()
	if(ntnet_global && (ntnet_global != src))
		ntnet_global = src // There can be only one.
	for(var/obj/machinery/ntnet_relay/R in SSmachines.machinery)
		relays.Add(R)
		R.NTNet = src
	build_software_lists()
	build_emails_list()
	build_reports_list()
	add_log("NTNet logging system activated.")

/datum/ntnet/proc/add_log_with_ids_check(log_string, obj/item/stock_parts/computer/network_card/source = null, intrusion = TRUE)
	if(intrusion_detection_enabled)
		add_log("IDS NOTICE: " + log_string, source)
		if (intrusion)
			intrusion_detection_alarm = TRUE

/// Simplified logging: Adds a log. log_string is mandatory parameter, source is optional. Returns TRUE on success.
/datum/ntnet/proc/add_log(log_string, obj/item/stock_parts/computer/network_card/source = null)
	var/log_text = "[stationtime2text()] - "
	if(source)
		log_text += "[source.get_network_tag()] - "
	else
		log_text += "*SYSTEM* - "
	log_text += log_string
	logs.Add(log_text)

	if(logs.len > setting_maxlogcount)
		// We have too many logs, remove the oldest entries until we get into the limit
		for(var/L in logs)
			if(logs.len > setting_maxlogcount)
				logs.Remove(L)
			else
				break

	// Log entries are backed up on portable drives in every relay, if present.
	for(var/obj/machinery/ntnet_relay/R in ntnet_global.relays)
		var/obj/item/stock_parts/computer/hard_drive/portable/P = R.get_component_of_type(/obj/item/stock_parts/computer/hard_drive/portable)
		if(istype(P))
			P.update_data_file("ntnet_log", "[log_text]\[br\]", /datum/computer_file/data/logfile)
	return TRUE

/datum/ntnet/proc/get_os_by_nid(NID)
	return registered_nids["[NID]"]

/datum/ntnet/proc/register(NID, datum/extension/interactive/ntos/os)
	registered_nids["[NID]"] = os

/datum/ntnet/proc/unregister(NID)
	registered_nids -= "[NID]"

/datum/ntnet/proc/check_banned(NID)
	if(!relays || !relays.len)
		return FALSE

	for(var/obj/machinery/ntnet_relay/R in relays)
		if(R.operable())
			return (NID in banned_nids)

	return FALSE

/// Checks whether NTNet operates.
/datum/ntnet/proc/check_function()
	if(!relays || !relays.len) // No relays found. NTNet is down for wireless devices
		return FALSE

	var/operating = FALSE
	// Check all relays. If we have at least one working relay, network is up.
	for(var/obj/machinery/ntnet_relay/R in relays)
		if(R.operable())
			operating = TRUE
			break

	if(setting_disabled)
		return FALSE
	return operating

/// Checks whether NTNet allows a specific action over wireless connections
/datum/ntnet/proc/check_capability(specific_action)
	switch(specific_action)
		if(NTNET_SOFTWAREDOWNLOAD)
			return setting_softwaredownload
		if(NTNET_PEERTOPEER)
			return setting_peertopeer
		if(NTNET_COMMUNICATION)
			return setting_communication
		if(NTNET_SYSTEMCONTROL)
			return setting_systemcontrol
	return FALSE

/// Builds lists that contain downloadable software.
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
			var/list/category_list = available_software_by_category[prog.category]
			if(!category_list)
				category_list = list()
				available_software_by_category[prog.category] = category_list
			ADD_SORTED(available_station_software, prog, /proc/cmp_program)
			ADD_SORTED(category_list, prog, /proc/cmp_program)
		if(prog.available_on_syndinet)
			ADD_SORTED(available_antag_software, prog, /proc/cmp_program)

/// Generates service email list.
/datum/ntnet/proc/build_emails_list()
	for(var/F in subtypesof(/datum/computer_file/data/email_account/service))
		new F()

/// Builds report list.
/datum/ntnet/proc/build_reports_list()
	available_reports = list()
	for(var/F in typesof(/datum/computer_file/report))
		var/datum/computer_file/report/type = F
		if(initial(type.available_on_ntnet))
			available_reports += new type

/datum/ntnet/proc/fetch_reports(access)
	if(!access)
		return available_reports
	. = list()
	for(var/datum/computer_file/report/report in available_reports)
		if(report.verify_access_edit(access))
			. += report

/// Attempts to find a downloadable file according to filename var
/datum/ntnet/proc/find_ntnet_file_by_name(filename)
	for(var/datum/computer_file/program/P in available_station_software)
		if(filename == P.filename)
			return P
	for(var/datum/computer_file/program/P in available_antag_software)
		if(filename == P.filename)
			return P

/// Resets the IDS alarm
/datum/ntnet/proc/resetIDS()
	intrusion_detection_alarm = 0
	add_log("-!- INTRUSION DETECTION ALARM RESET BY SYSTEM OPERATOR -!-")

/// Toggle IDS on or off
/datum/ntnet/proc/toggleIDS()
	resetIDS()
	intrusion_detection_enabled = !intrusion_detection_enabled
	add_log("Configuration Updated. Intrusion Detection [intrusion_detection_enabled ? "enabled" : "disabled"].")

/// Removes all logs
/datum/ntnet/proc/purge_logs()
	logs = list()
	add_log("-!- LOGS DELETED BY SYSTEM OPERATOR -!-")

/// Updates maximal amount of stored logs. Use this instead of setting the number, it performs required checks. Returns TRUE if number is updated. FALSE otherwise.
/datum/ntnet/proc/update_max_log_count(lognumber)
	if(!lognumber)
		return FALSE
	// Trim the value if necessary
	lognumber = clamp(lognumber, MIN_NTNET_LOGS, MAX_NTNET_LOGS)
	setting_maxlogcount = lognumber
	add_log("Configuration Updated. Now keeping [setting_maxlogcount] log entries in system memory.")
	return TRUE

/datum/ntnet/proc/toggle_function(function)
	if(!function)
		return
	function = text2num(function)
	switch(function)
		if(NTNET_SOFTWAREDOWNLOAD)
			setting_softwaredownload = !setting_softwaredownload
			add_log("Configuration Updated. Wireless network firewall now [setting_softwaredownload ? "allows" : "disallows"] connection to software repositories.")
		if(NTNET_PEERTOPEER)
			setting_peertopeer = !setting_peertopeer
			add_log("Configuration Updated. Wireless network firewall now [setting_peertopeer ? "allows" : "disallows"] peer to peer network traffic.")
		if(NTNET_COMMUNICATION)
			setting_communication = !setting_communication
			add_log("Configuration Updated. Wireless network firewall now [setting_communication ? "allows" : "disallows"] instant messaging and similar communication services.")
		if(NTNET_SYSTEMCONTROL)
			setting_systemcontrol = !setting_systemcontrol
			add_log("Configuration Updated. Wireless network firewall now [setting_systemcontrol ? "allows" : "disallows"] remote control of [station_name()]'s systems.")

/// Returns email account matching login. Otherwise null
/datum/ntnet/proc/find_email_by_name(login)
	for(var/datum/computer_file/data/email_account/A in ntnet_global.email_accounts)
		if(A.login == login)
			return A

/// Used when a mob or robot is renamed. Not intended to be used by any ingame computer systems
/datum/ntnet/proc/rename_email(mob/user, old_login, desired_name, domain)
	var/datum/computer_file/data/email_account/account = find_email_by_name(old_login)
	var/new_login = sanitize_for_email(desired_name)
	new_login += "@[domain]"
	if(new_login == old_login)
		return	//If we aren't going to be changing the login, we quit silently.
	if(find_email_by_name(new_login))
		to_chat(user, "Your email could not be updated: the new username is invalid.")
		return
	account.login = new_login
	to_chat(user, "Your email account address has been changed to <b>[new_login]</b>. This information has also been placed into your notes.")
	add_log("Email address changed for [user]: [old_login] changed to [new_login]")
	if(user.mind)
		user.mind.initial_email_login["login"] = new_login
		user.StoreMemory("Your email account address has been changed to [new_login].", /decl/memory_options/system)
	if(issilicon(user))
		var/mob/living/silicon/S = user
		var/datum/nano_module/email_client/my_client = S.get_subsystem_from_path(/datum/nano_module/email_client)
		if(my_client)
			my_client.stored_login = new_login

/// Used for initial email generation. Not intended to be used by any ingame computer systems
/datum/ntnet/proc/create_email(mob/user, desired_name, domain, assignment, desired_password)
	desired_name = sanitize_for_email(desired_name)
	var/login = "[desired_name]@[domain]"
	// It is VERY unlikely that we'll have two players, in the same round, with the same name and branch, but still, this is here.
	// If such conflict is encountered, a random number will be appended to the email address. If this fails too, no email account will be created.
	if(find_email_by_name(login))
		login = "[desired_name][random_id(/datum/computer_file/data/email_account/, 100, 999)]@[domain]"
	// If even fallback login generation failed, just don't give them an email. The chance of this happening is astronomically low.
	if(find_email_by_name(login))
		to_chat(user, "You were not assigned an email address.")
		user.StoreMemory("You were not assigned an email address.", /decl/memory_options/system)
	else
		var/datum/computer_file/data/email_account/EA = new/datum/computer_file/data/email_account(login, user.real_name, assignment)
		EA.password = desired_password ? desired_password : GenerateKey()
		if(user.mind)
			user.mind.initial_email_login["login"] = EA.login
			user.mind.initial_email_login["password"] = EA.password
			user.StoreMemory("Your email account address is [EA.login] and the password is [EA.password].", /decl/memory_options/system)
		if(issilicon(user))
			var/mob/living/silicon/S = user
			var/datum/nano_module/email_client/my_client = S.get_subsystem_from_path(/datum/nano_module/email_client)
			if(my_client)
				my_client.stored_login = EA.login
				my_client.stored_password = EA.password

/mob/proc/create_or_rename_email(newname, domain)
	if(!mind)
		return
	var/old_email = mind.initial_email_login["login"]
	if(!old_email)
		ntnet_global.create_email(src, newname, domain)
	else
		ntnet_global.rename_email(src, old_email, newname, domain)
