// Epic Anti-Multiaccount System

/datum/configuration/var/EAMSallowedCountries = list("ru", "am", "az", "by", "kz", "kg", "mb", "ti", "uz", "ua", "tm")

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
		[player.whitelisted ? "<A href='?src=\ref[source];removefromwhitelist=\ref[player]'>Yes</A>" : "<A href='?src=\ref[source];addtowhitelist=\ref[player]'>No</A>"]
		"}
	return result

/proc/EAMS_AdminTopicProcess(var/datum/admins/source, var/list/href_list)
	var/client/player = null
	if (href_list["addtowhitelist"])
		player = locate(href_list["addtowhitelist"])
		if (EAMS_SetWhitelistedToDB(player, TRUE))
			player.whitelisted = TRUE
	else if (href_list["removefromwhitelist"])
		player = locate(href_list["removefromwhitelist"])
		if (EAMS_SetWhitelistedToDB(player, FALSE))
			player.whitelisted = FALSE
	else
		return

	source.show_player_panel(player.mob) // update panel

//
//	Sync client.whitelisted with database
//

// return whitelisted from DB or false if we can't get it
/proc/EAMS_GetWhitelistedFromDB(var/client/player)
	if(!dbcon || !dbcon.IsConnected())  //Database wasn't connected
		return FALSE

	var/DBQuery/query = dbcon.NewQuery("SELECT ckey FROM whitelist_ckey WHERE ckey = \"[player.ckey]\" LIMIT 0,1")
	if (!query.Execute())
		EAMS_DBError(4)
		return FALSE

	if (query.NextRow())
		return TRUE

	return FALSE

// return true if success
/proc/EAMS_SetWhitelistedToDB(var/client/player, var/value)
	if (!config.eams)	// EAMS doesn't active
		return FALSE

	if(!dbcon || !dbcon.IsConnected())  //Database wasn't connected
		EAMS_DBError(5)
		return FALSE

	var/DBQuery/query = null

	if (value)
		log_and_message_admins("added [player.ckey] to EAMS whitelist!")
		query = dbcon.NewQuery("INSERT INTO whitelist_ckey (ckey) VALUES ('[player.ckey]')")
	else
		log_and_message_admins("removed [player.ckey] from EAMS whitelist!")
		query = dbcon.NewQuery("DELETE FROM whitelist_ckey WHERE ckey='[player.ckey]'")

	if (!query.Execute())
		EAMS_DBError(4)
		return FALSE

	return TRUE

//
//	Check IP before joining the game
//

// return TRUE if user IP is allowed
/mob/new_player/proc/EAMS_CheckIP()
	if (!config.eams)	// EAMS isn't active
		return TRUE

	if(!lastKnownIP || client.holder) // admin or host
		return TRUE

	// check whitelist
	if (client.whitelisted)
		return TRUE

	// check country
	var/list/http = world.Export("http://ip-api.com/json/[lastKnownIP]?fields=country,countryCode,status,message")

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

	var/countryCode = response["countryCode"]

	if (countryCode in config.EAMSallowedCountries)
		return TRUE

	// Bad IP and player isn't whitelisted.. so create a warning
	var/country = response["country"]

	if (country == "")
		country = "unknown"

	usr << "<span class='warning'>You were blocked by EAMS! Please, contact Administrators.</span>"
	log_and_message_admins("<span class='adminnotice'>Failed join the game: [key] ([lastKnownIP]) connected from [country] ([countryCode]) </span>", 0)
	return FALSE
