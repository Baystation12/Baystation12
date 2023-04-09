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
			WHERE `bantype` IN ('PERMABAN', 'TEMPBAN') AND \
			(`ckey` = '[ckey]' OR `ip` = '[ip]' OR `computerid` = '[cid]')\
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


/proc/_find_bans_in_connections(list/connections, include_inactive = FALSE)
	RETURN_TYPE(/list)
	. = list()

	var/list/ckeys = list()
	var/list/ips = list()
	var/list/cids = list()
	var/list/final_query_components = list()

	for (var/list/connection in connections)
		ckeys |= connection["ckey"]
		ips |= connection["ip"]
		cids |= connection["computerid"]

	var/empty_string = ""
	var/comma_separator = "', '"
	if (length(ckeys))
		final_query_components += "`ckey` IN ('[english_list(ckeys, empty_string, comma_separator, comma_separator, empty_string)]')"

	if (length(ips))
		final_query_components += "`ip` IN ('[english_list(ips, empty_string, comma_separator, comma_separator, empty_string)]')"

	if (length(cids))
		final_query_components += "`computerid` IN ('[english_list(cids, empty_string, comma_separator, comma_separator, empty_string)]')"

	if (!length(final_query_components))
		return

	establish_db_connection()
	if (!dbcon.IsConnected())
		crash_with("Database connection failed.")
		return
	var/DBQuery/query = dbcon.NewQuery({"
		SELECT `bantime`, `bantype`, `reason`, `job`, `duration`, `expiration_time`, `ckey`, `ip`, `computerid`, `a_ckey`, `unbanned`
			FROM `erro_ban`
			WHERE `bantype` IN ('PERMABAN', 'TEMPBAN') AND
			([english_list(final_query_components, "", "", " OR ", " OR ")])
	"})
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


/**
 * Returns a list containing only each unique ckey present in a list of connections provided by `_fetch_connections()`.
 */
/proc/_unique_ckeys_from_connections(list/connections)
	RETURN_TYPE(/list)
	. = list()
	for (var/list/connection in connections)
		. |= connection["ckey"]


/**
 * Returns a list containing only each unique CID present in a list of connections provided by `_fetch_connections()`.
 */
/proc/_unique_cids_from_connections(list/connections)
	RETURN_TYPE(/list)
	. = list()
	for (var/list/connection in connections)
		. |= connection["computerid"]


/**
 * Returns a list containing only each unique IP present in a list of connections provided by `_fetch_connections()`.
 */
/proc/_unique_ips_from_connections(list/connections)
	RETURN_TYPE(/list)
	. = list()
	for (var/list/connection in connections)
		. |= connection["ip"]


/client/proc/fetch_connections()
	RETURN_TYPE(/list)
	return _fetch_connections(ckey, address, computer_id)


/client/proc/fetch_bans()
	RETURN_TYPE(/list)
	return _find_bans_in_connections(fetch_connections())


/mob/proc/fetch_connections()
	RETURN_TYPE(/list)
	if (client)
		return client.fetch_connections()
	return _fetch_connections(ckey ? ckey : last_ckey, lastKnownIP, computer_id)


/mob/proc/fetch_bans()
	RETURN_TYPE(/list)
	return _find_bans_in_connections(fetch_connections())


// Temporary debugging and testing functions
/proc/_debug_fetch_connections(ckey, ip, cid)
	var/list/result = _fetch_connections(ckey, ip, cid)
	var/table = {"
		<table>
			<thead>
				<tr>
					<th>DATETIME</th>
					<th>CKEY</th>
					<th>IP</th>
					<th>COMPUTERID</th>
				</tr>
			</thead>
			<tbody>
	"}
	for (var/list/row in result)
		table += {"
				<tr>
					<td>[row["datetime"]]</td>
					<td>[row["ckey"]]</td>
					<td>[row["ip"]]</td>
					<td>[row["computerid"]]</td>
				</tr>
		"}
	table += {"
			</tbody>
		</table>
	"}
	show_browser(usr, table, "window=debug")


/proc/_debug_fetch_bans(ckey, ip, cid, include_inactive = FALSE)
	var/list/result = _find_bans_in_connections(_fetch_connections(ckey, ip, cid), include_inactive)
	var/table = {"
		<table>
			<thead>
				<tr>
					<th>BANTIME</th>
					<th>BANTYPE</th>
					<th>REASON</th>
					<th>JOB</th>
					<th>DURATION</th>
					<th>EXPIRATION_TIME</th>
					<th>CKEY</th>
					<th>IP</th>
					<th>COMPUTERID</th>
					<th>A_CKEY</th>
					<th>UNBANNED</th>
					<th>EXPIRED</th>
				</tr>
			</thead>
			<tbody>
	"}
	for (var/list/row in result)
		table += {"
				<tr>
					<td>[row["bantime"]]</td>
					<td>[row["bantype"]]</td>
					<td>[row["reason"]]</td>
					<td>[row["job"]]</td>
					<td>[row["duration"]]</td>
					<td>[row["expiration_time"]]</td>
					<td>[row["ckey"]]</td>
					<td>[row["ip"]]</td>
					<td>[row["computerid"]]</td>
					<td>[row["a_ckey"]]</td>
					<td>[row["unbanned"]]</td>
					<td>[row["expired"]]</td>
				</tr>
		"}
	table += {"
			</tbody>
		</table>
	"}
	show_browser(usr, table, "window=debug")


/client/proc/debug_fetch_connections()
	RETURN_TYPE(/list)
	return _debug_fetch_connections(ckey, address, computer_id)


/client/proc/debug_fetch_bans()
	RETURN_TYPE(/list)
	return _debug_fetch_bans(ckey, address, computer_id)


/mob/proc/debug_fetch_connections()
	RETURN_TYPE(/list)
	if (client)
		return client.debug_fetch_connections()
	return _debug_fetch_connections(ckey ? ckey : last_ckey, lastKnownIP, computer_id)


/mob/proc/debug_fetch_bans()
	RETURN_TYPE(/list)
	if (client)
		return client.debug_fetch_bans()
	return _debug_fetch_bans(ckey ? ckey : last_ckey, lastKnownIP, computer_id)
