// Epic Anti-Multiaccount System

/datum/configuration/var/EAMSallowedCountries = list("ru", "am", "az", "by", "kz", "kg", "mb", "ti", "uz", "ua", "tm")

/proc/EAMS_DBError(num)
	config.eams = 0
	log_and_message_admins("The Database Error #[num] has occured! Epic Anti-Multiaccount System was deactivated!", 0)

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
	if (!config.eams)	// EAMS doesn't active
		return TRUE

	if(!dbcon || !dbcon.IsConnected())  //Database wasn't connected
		EAMS_DBError(1)
		return TRUE

	if(!lastKnownIP || client.holder) // admin or host
		return TRUE

	// check country
	var/DBQuery/query = dbcon.NewQuery("SELECT country FROM ip2nation WHERE ip < INET_ATON(\"[lastKnownIP]\") ORDER BY ip DESC LIMIT 0,1")
	if (!query.Execute())
		EAMS_DBError(2)
		return TRUE

	if (!query.NextRow())
		EAMS_DBError(3)
		return TRUE

	var/country = ""
	var/countryCode = query.item[1]

	if (countryCode in config.EAMSallowedCountries)
		return TRUE

	// check whitelist
	if (client.whitelisted)
		return TRUE

	
	// Bad IP and player doesn't whitelisted.. so create Warning
	query = dbcon.NewQuery("SELECT country FROM ip2nationcountries WHERE code = \"[countryCode]\" LIMIT 1")
	if (query.Execute())
		if (query.NextRow())
			country = query.item[1]

	usr << "<span class='warning'>You was blocked by EAMS! Please, contact Administrators.</span>"
	log_and_message_admins("<span class='adminnotice'>Failed join the game: [key] ([lastKnownIP]) connected from [country] ([countryCode]) </span>", 0)
	return FALSE
