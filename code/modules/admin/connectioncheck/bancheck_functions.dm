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
 * Returns a list containing only each unique ckey present in a list of connections provided by `_fetch_connections()`.
 */
/proc/_unique_ckeys_from_bans(list/bans)
	RETURN_TYPE(/list)
	. = list()
	for (var/list/ban in bans)
		. |= ban["ckey"]


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
 * Aliases to `_find_bans_in_connections()` with this client's `fetch_connections()` result.
 *
 * Returns list of lists.
 */
/client/proc/fetch_bans()
	RETURN_TYPE(/list)
	return _find_bans_in_connections(fetch_connections())


/**
 * Aliases to `_find_bans_in_connections()` with this mob's `fetch_connections()` result.
 *
 * Returns list of lists.
 */
/mob/proc/fetch_bans()
	RETURN_TYPE(/list)
	return _find_bans_in_connections(fetch_connections())


/proc/_show_associated_bans(mob/user, list/bans, target_ckey, target_ip, target_cid)
	// Unique Ckeys
	var/list/unique_ckeys = _unique_ckeys_from_bans(bans)
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

	// List of all bans
	var/all_bans_table = {"
		<table style='width: 100%;'>
			<thead>
				<tr>
					<th>Banned Ckey</th>
					<th>IP Address</th>
					<th>Computer ID</th>
					<th>Status</th>
					<th>Banning Admin</th>
				</tr>
			</thead>
			<tbody>
				"}
	for (var/list/row in bans)
		var/status = "ACTIVE"
		if (row["expired"])
			status = row["unbanned"] ? "UNBANNED" : "EXPIRED"
		else
			switch (row["bantype"])
				if ("PERMABAN")
					status += " (PERMANENT)"
				if ("TEMPBAN")
					status += " (UNTIL [row["expiration_time"]])"
		all_bans_table += {"
				<tr[row["expired"] ? " style='color: gray;'" : null]>
					<td[row["ckey"] == target_ckey ? " class='highlight'" : null]>[row["ckey"] ? row["ckey"] : "<span class='color: gray;'>N/A</span>"]</td>
					<td[row["ip"] == target_ip ? " class='highlight'" : null]>[row["ip"] ? row["ip"] : "<span class='color: gray;'>N/A</span>"]</td>
					<td[row["computerid"] == target_cid ? " class='highlight'" : null]>[row["computerid"] ? row["computerid"] : "<span class='color: gray;'>N/A</span>"]</td>
					<td>[status]</td>
					<td>[row["a_ckey"]]</td>
				</tr>
				<tr[row["expired"] ? " style='color: gray;'" : null]>
					<th>Reason</th>
					<td colspan='4'>[row["reason"]]</td>
				</tr>
		"}
	all_bans_table +={"
			</tbody>
		</table>
	"}

	// Final layout
	var/final_body = {"
		<h1>Associated Bans</h1>
		<h2>Queried Details</h2>
		<table stype='width: 100%;'>
			<thead>
				<tr>
					<th style='width: 33%';>Ckey</th>
					<th style='width: 33%';>IP Address</th>
					<th style='width: 33%';>Computer ID</th>
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

		<h2>Matching Banned Ckeys</h2>
		<p><small>Entries matching the current query are <span class='highlight'>highlighted</span>.</small></p>
		[unique_ckeys_table]

		<h2>All Matching Bans</h2>
		<p><small>Entries matching the current query are <span class='highlight'>highlighted</span>.</small></p>
		[all_bans_table]
	"}
	send_rsc(user, 'html/browser/common.css', "common.css")
	show_browser(user, html_page("Associated Bans ([target_ckey ? target_ckey : "NO CKEY"])", final_body), "window=associatedbans;size=700x480;")


/**
 * Aliases to `_show_associated_bans()` using this client's `fetch_bans()` result, ckey, IP address, and CID.
 *
 * Has no return value.
 */
/client/proc/show_associated_bans(mob/user, list/bans)
	if (isnull(bans))
		bans = fetch_bans()
	_show_associated_bans(user, bans, ckey, address, computer_id)


/**
 * Aliases to `_show_associated_bans()` using this mob's `fetch_bans()` result, ckey, IP address, and CID.
 *
 * Has no return value.
 */
/mob/proc/show_associated_bans(mob/user, list/bans)
	if (client)
		client.show_associated_bans(user, bans)
		return
	if (isnull(bans))
		bans = fetch_bans()
	_show_associated_bans(user, bans, ckey ? ckey : last_ckey, lastKnownIP, computer_id)
