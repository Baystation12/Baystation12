/datum/configuration
	var/usewhitelist_database = FALSE
	var/overflow_server_url
	var/minimum_byondacc_age

/mob/new_player/proc/whitelist_check()
	// Admins are immune to overflow rerouting
	if(!config.usewhitelist_database)
		return TRUE
	if(check_rights(rights_required = 0, show_msg = 0))
		return TRUE
	establish_db_connection()
	// Whitelisted people are immune to overflow rerouting.
	if(dbcon.IsConnected())
		var/dbckey = sql_sanitize_text(src.ckey)
		var/DBQuery/find_ticket = dbcon.NewQuery({"
			SELECT `ckey`
				FROM `ckey_whitelist`
				WHERE `ckey`='[dbckey]'
					AND `is_valid` = true
					AND `port` = [world.port]
					AND `date_start` <= NOW()
					AND (NOW() < `date_end` OR `date_end` IS NULL)
		"})
		if(!find_ticket.Execute())
			log_error(dbcon.ErrorMsg())
			return FALSE
		if(!find_ticket.NextRow())
			return FALSE
		return TRUE
	return FALSE
