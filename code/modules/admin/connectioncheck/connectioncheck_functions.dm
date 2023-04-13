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


/**
 * Checks a list of connections for bans matching any of the list entries.
 *
 * **Parameters**:
 * - `connections` (list) - List of connections. Should be the output of `_fetch_connections()`.
 * - `include_inactive` (boolean, default `FALSE`) - If set, includes inactive/expired bans in the list.
 *
 * Returns list of lists.
 */
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


/proc/_show_associated_connections(mob/user, list/connections, target_ckey, target_ip, target_cid)
	// Unique Ckeys
	var/list/unique_ckeys = _unique_ckeys_from_connections(connections)
	var/unique_ckeys_table = {"
		<table style='width: 100%;'>
			<tbody>
	"}
	for (var/ckey in unique_ckeys)
		unique_ckeys_table += {"
				<tr>
					<td[ckey == target_ckey ? " class='highlight'" : null]>[ckey]</td>
				</tr>
		"}
	unique_ckeys_table += {"
			</tbody>
		</table>
	"}

	// Unique IP Addresses
	var/list/unique_ips = _unique_ips_from_connections(connections)
	var/unique_ips_table = {"
		<table style='width: 100%;'>
			<tbody>
	"}
	for (var/ip in unique_ips)
		unique_ips_table += {"
				<tr>
					<td[ip == target_ip ? " class='highlight'" : null]>[ip]</td>
				</tr>
		"}
	unique_ips_table += {"
			</tbody>
		</table>
	"}

	// Unique CIDs
	var/list/unique_cids = _unique_cids_from_connections(connections)
	var/unique_cids_table = {"
		<table style='width: 100%;'>
			<tbody>
	"}
	for (var/cid in unique_cids)
		unique_cids_table += {"
				<tr>
					<td[cid == target_cid ? " class='highlight'" : null]>[cid]</td>
				</tr>
		"}
	unique_cids_table += {"
			</tbody>
		</table>
	"}

	// List of all connections
	var/all_connections_table = {"
		<table style='width: 100%;'>
			<thead>
				<tr>
					<th>First Seen</th>
					<th>Ckey</th>
					<th>IP Address</th>
					<th>Computer ID</th>
				</tr>
			</thead>
			<tbody>
	"}
	for (var/list/row in connections)
		all_connections_table += {"
				<tr>
					<td>[row["datetime"]]</td>
					<td[row["ckey"] == target_ckey ? " class='highlight'" : null]>[row["ckey"]]</td>
					<td[row["ip"] == target_ip ? " class='highlight'" : null]>[row["ip"]]</td>
					<td[row["computerid"] == target_cid ? " class='highlight'" : null]>[row["computerid"]]</td>
				</tr>
		"}
	all_connections_table += {"
			</tbody>
		</table>
	"}

	// Final layout
	var/final_body = {"
		<h1>Associated Connections</h1>
		<h2>Queried Details</h2>
		<table style='width: 100%;'>
			<thead>
				<tr>
					<th style='width: 33%;'>Ckey</th>
					<th style='width: 33%;'>IP Address</th>
					<th style='width: 33%;'>Computer ID</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>[target_ckey ? target_ckey : "N/A"]</td>
					<td>[target_ip ? target_ip : "N/A"]</td>
					<td>[target_cid ? target_cid : "N/A"]</td>
				</tr>
			</tbody>
		</table>

		<h2>Associated Ckeys, IP Addresses, and Computer IDs</h2>
		<p><small>NOTE: Rows in this table are not necessarily associated with eachother. This is simply a list of each category's entries for ease of information.<br />
			Entries matching the current query are <span class='highlight'>highlighted</span>.</small></p>
		<table style='width: 100%;'>
			<thead>
				<tr>
					<th style='width: 33%;'>Ckeys</th>
					<th style='width: 33%;'>IP Addresses</th>
					<th style='width: 33%;'>Computer IDs</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>[unique_ckeys_table]</td>
					<td>[unique_ips_table]</td>
					<td>[unique_cids_table]</td>
				</tr>
			</tbody>
		</table>

		<h2>All Unique Connections</h2>
		<p><small>NOTE: This table does not list every single connection ever made, only the first connection seen for each unique combination of ckey, IP, and CID.<br />
			Entries matching the current query are <span class='highlight'>highlighted</span>.</small></p>
		[all_connections_table]
	"}
	send_rsc(user, 'html/browser/common.css', "common.css")
	show_browser(user, html_page("Associated Connections ([target_ckey ? target_ckey : "NO CKEY"])", final_body), "window=associatedconnections;size=500x480;")


/client/proc/show_associated_connections(mob/user, list/connections)
	if (isnull(connections))
		connections = fetch_connections()
	_show_associated_connections(user, connections, ckey, address, computer_id)


/mob/proc/show_associated_connections(mob/user, list/connections)
	if (client)
		client.show_associated_connections(user, connections)
		return
	if (isnull(connections))
		connections = fetch_connections()
	_show_associated_connections(user, connections, ckey ? ckey : last_ckey, lastKnownIP, computer_id)


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


/client/proc/debug_fetch_bans()
	RETURN_TYPE(/list)
	return _debug_fetch_bans(ckey, address, computer_id)


/mob/proc/debug_fetch_bans()
	RETURN_TYPE(/list)
	if (client)
		return client.debug_fetch_bans()
	return _debug_fetch_bans(ckey ? ckey : last_ckey, lastKnownIP, computer_id)
