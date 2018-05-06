// Epic Anti-Multiaccount System

/datum/configuration/var/EAMSallowedCountries = list("RU", "AM", "AZ", "BY", "KZ", "KG", "MB", "TI", "UZ", "UA", "TM")

/datum/eams_info
	var/loaded 			= FALSE
	var/whitelisted 	= FALSE

	var/ip_as
	var/ip_isp
	var/ip_org
	var/ip_country
	var/ip_countryCode
	var/ip_region
	var/ip_regionCode
	var/ip_city
	var/ip_lat
	var/ip_lon
	var/ip_timezone
	var/ip_zip
	var/ip_reverse
	var/ip_mobile
	var/ip_proxy

/proc/EAMS_DBError()
	config.eams = 0
	log_and_message_admins("The Database Error has occured! Epic Anti-Multiaccount System was deactivated!", 0)

//
//	Toggle Verb
//

/client/proc/EAMS_toggle()
	set category = "Server"
	set name = "Toggle EAMS"

	if (!dbcon || !dbcon.IsConnected())
		usr << "<span class='adminnotice'>The Database is not connected!</span>"
		return

	config.eams = !config.eams
	log_and_message_admins("has [config.eams ? "enabled" : "disabled"] the Epic Anti-Multiaccount System!")

//
//	Player Panel Button
//

/proc/EAMS_GetPlayerPannelButton(var/datum/admins/source, var/client/player)
	var/result = {"<br><br><b>EAMS whitelisted:</b>
		[player.eams_info.whitelisted ? "<A href='?src=\ref[source];removefromwhitelist=\ref[player]'>Yes</A>" : "<A href='?src=\ref[source];addtowhitelist=\ref[player]'>No</A>"]
		"}
	return result

/proc/EAMS_AdminTopicProcess(var/datum/admins/source, var/list/href_list)
	var/client/player = null
	if (href_list["addtowhitelist"])
		player = locate(href_list["addtowhitelist"])
		player.EAMS_SetWhitelistedToDB(TRUE)
	else if (href_list["removefromwhitelist"])
		player = locate(href_list["removefromwhitelist"])
		player.EAMS_SetWhitelistedToDB(FALSE)
	else
		return

	source.show_player_panel(player.mob) // update panel

//
//	Sync eams_info.whitelisted with database
//

// return whitelisted from DB or false if we can't get it
/client/proc/EAMS_GetWhitelistedFromDB()
	if(!dbcon || !dbcon.IsConnected())  //Database wasn't connected
		EAMS_DBError()
		return FALSE

	var/DBQuery/query = dbcon.NewQuery("SELECT ckey FROM whitelist_ckey WHERE ckey = \"[ckey]\" LIMIT 0,1")
	if (!query.Execute())
		EAMS_DBError()
		return FALSE

	if (query.NextRow())
		return TRUE

	return FALSE

// return true if success
/client/proc/EAMS_SetWhitelistedToDB(var/value)
	if (!config.eams)	// EAMS doesn't active
		return

	if(!dbcon || !dbcon.IsConnected())  //Database wasn't connected
		EAMS_DBError()
		return

	var/DBQuery/query = null

	if (value)
		query = dbcon.NewQuery("INSERT INTO whitelist_ckey (ckey) VALUES ('[ckey]')")
	else
		query = dbcon.NewQuery("DELETE FROM whitelist_ckey WHERE ckey='[ckey]'")

	if (!query.Execute())
		EAMS_DBError()
		return

	if (value)
		log_and_message_admins("added [ckey] to EAMS whitelist!")
	else
		log_and_message_admins("removed [ckey] from EAMS whitelist!")

	eams_info.whitelisted = value
	return

//
//	Collect all necessary data on joining the game
//

/client/proc/EAMS_CollectData()
	if (!config.eams)	// EAMS isn't active
		return

	//
	// get whitelisted flag from DB
	//
	eams_info.whitelisted = EAMS_GetWhitelistedFromDB()

	//
	// load IP info
	//
	if (!address || address == "127.0.0.1")
		return

	// check country
	var/list/http = world.Export("http://ip-api.com/json/[address]?fields=262143")

	if(!http)
		log_and_message_admins("EAMS could not check [key]: connection failed")
		return TRUE

	var/list/response
	try
		response = json_decode(file2text(http["CONTENT"]))
	catch (var/exception/e)
		log_and_message_admins("EAMS could not check [key]: json decode failed: [e.name]")
		return TRUE

	if (response["status"] == "fail")
		log_and_message_admins("EAMS could not check [key]: [response["message"]]")
		return TRUE

	eams_info.ip_as			 	= response["as"]
	eams_info.ip_isp			= response["isp"]
	eams_info.ip_org			= response["org"]
	eams_info.ip_country		= response["country"]
	eams_info.ip_countryCode 	= response["countryCode"]
	eams_info.ip_region		 	= response["regionName"]
	eams_info.ip_regionCode	 	= response["region"]
	eams_info.ip_city		 	= response["city"]
	eams_info.ip_lat 			= response["lat"]
	eams_info.ip_lon 			= response["lon"]
	eams_info.ip_timezone	 	= response["timezone"]
	eams_info.ip_zip 			= response["zip"]
	eams_info.ip_reverse 		= response["reverse"]
	eams_info.ip_mobile 		= response["mobile"]
	eams_info.ip_proxy 			= response["proxy"]

	eams_info.loaded = TRUE
	return

//
//	Check for access before joining the game
//

/client/proc/EAMS_CheckForAccess()
	if (!config.eams)	// EAMS isn't active
		return TRUE

	if(!address || holder) // admin or host
		return TRUE

	if (eams_info.whitelisted) // check whitelist
		return TRUE

	if (eams_info.loaded)
		if (eams_info.ip_countryCode in config.EAMSallowedCountries)
			return TRUE

		// Bad IP and player isn't whitelisted.. so create a warning
		if (eams_info.ip_country == "")
			eams_info.ip_country = "unknown"

		usr << "<span class='warning'>You were blocked by EAMS! Please, contact Administrators.</span>"
		log_and_message_admins("Failed join the game: [key] ([address]) connected from [eams_info.ip_country] ([eams_info.ip_countryCode])", 0)

		return FALSE

	log_and_message_admins("EAMS failed to load info for [key]", 0)
	return TRUE
