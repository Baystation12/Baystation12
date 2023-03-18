/**
 * Checks for prior connections matching ckey, ip, or cid.
 *
 * Returns list of lists.
 */
/proc/_fetch_connections(ckey, ip, cid)
	RETURN_TYPE(/list)
	. = list()
	ckey = sql_sanitize_text(ckey)
	ip = sql_sanitize_text(ip)
	cid = sql_sanitize_text(cid)
	if (!ckey && !ip && !cid)
		return
	establish_db_connection()
	if (!dbcon.IsConnected())
		crash_with("Database connection failed.")
		return
	var/DBQuery/query = dbcon.NewQuery("\
		SELECT `datetime`, `ckey`, `ip`, `computerid`\
			FROM `erro_connection_log`\
			WHERE `ckey` = '[ckey]' OR `ip` = '[ip]' OR `computerid` = '[cid]'\
			GROUP BY `ckey`, `ip`, `computerid`\
			ORDER BY `datetime`\
	")
	query.Execute()
	while (query.NextRow())
		var/row = list(
			"datetime" = "[query.item[1]]",
			"ckey" = "[query.item[2]]",
			"ip" = "[query.item[3]]",
			"computerid" = "[query.item[4]]"
		)
		. += list(row)


/**
 * Checks for bans matching ckey, ip, or cid.
 *
 * Returns list of lists.
 */
/proc/_fetch_bans(ckey, ip, cid, include_inactive = FALSE)
	RETURN_TYPE(/list)
	. = list()
	ckey = sql_sanitize_text(ckey)
	ip = sql_sanitize_text(ip)
	cid = sql_sanitize_text(cid)
	if (!ckey && !ip && !cid)
		return
	establish_db_connection()
	if (!dbcon.IsConnected())
		crash_with("Database connection failed.")
		return
	var/DBQuery/query = dbcon.NewQuery("\
		SELECT `bantime`, `bantype`, `reason`, `job`, `duration`, `expiration_time`, `ckey`, `ip`, `computerid`, `a_ckey`, `unbanned`\
			FROM `erro_ban`\
			WHERE `ckey` = '[ckey]' OR `ip` = '[ip]' OR `computerid` = '[cid]'\
	")
	query.Execute()
	var/now = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")
	while (query.NextRow())
		var/row = list(
			"bantime" = query.item[1],
			"bantype" = query.item[2],
			"reason" = query.item[3],
			"job" = query.item[4],
			"duration" = query.item[5],
			"expiration_time" = query.item[6],
			"ckey" = query.item[7],
			"ip" = query.item[8],
			"computerid" = query.item[9],
			"a_ckey" = query.item[10],
			"unbanned" = query.item[11]
		)
		row["expired"] = ((row["bantype"] in list("TEMPBAN", "JOB_TEMPBAN")) && now > row["expiration_time"])
		if (include_inactive || !(row["expired"] || row["unbanned"]))
			. += list(row)


/proc/_find_bans_in_connections(ckey, ip, cid)
	RETURN_TYPE(/list)
	. = list()
	var/list/connections = _fetch_connections(ckey, ip, cid)
	if (!length(connections))
		return
	for (var/list/connection in connections)
		. |= _fetch_bans(ckey, ip, cid)


/client/proc/fetch_connections()
	RETURN_TYPE(/list)
	return _fetch_connections(ckey, address, computer_id)


/client/proc/fetch_bans()
	RETURN_TYPE(/list)
	return _fetch_bans(ckey, address, computer_id)


/mob/proc/fetch_connections()
	RETURN_TYPE(/list)
	if (client)
		return client.fetch_connections()
	return _fetch_connections(ckey ? ckey : last_ckey, lastKnownIP, computer_id)


/mob/proc/fetch_bans()
	RETURN_TYPE(/list)
	if (client)
		return client.fetch_bans()
	return _fetch_bans(ckey ? ckey : last_ckey, lastKnownIP, computer_id)
