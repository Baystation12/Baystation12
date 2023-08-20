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
	var/selection = list()
	if (ckey)
		selection += "`ckey` = '[ckey]'"
	if (ip)
		selection += "`ip` = '[ip]'"
	if (cid)
		selection += "`computerid` = '[cid]'"
	selection = english_list(selection, "", "", " OR ", " OR ")
	var/DBQuery/query = dbcon.NewQuery("\
		SELECT `bantype`, `reason`, `expiration_time`, `ckey`, `ip`, `computerid`, `a_ckey`, `unbanned`\
			FROM `erro_ban`\
			WHERE `bantype` IN ('PERMABAN', 'TEMPBAN') AND \
			([selection])\
	")
	query.Execute()
	var/now = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")
	while (query.NextRow())
		var/row = list(
			"bantype"         = query.item[1],
			"reason"          = query.item[2],
			"expiration_time" = query.item[3],
			"ckey"            = query.item[4],
			"ip"              = query.item[5],
			"computerid"      = query.item[6],
			"a_ckey"          = query.item[7],
			"unbanned"        = query.item[8]
		)
		row["expired"] = ((row["bantype"] in list("TEMPBAN", "JOB_TEMPBAN")) && now > row["expiration_time"])
		if (include_inactive || !(row["expired"] || row["unbanned"]))
			. += list(row)


/**
 * Returns a sorted list containing only each unique ckey present in a list of connections provided by `_fetch_connections()`.
 */
/proc/_unique_ckeys_from_bans(list/bans)
	RETURN_TYPE(/list)
	. = list()
	for (var/list/ban in bans)
		. |= ban["ckey"]
	return sortList(.)


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
		SELECT `bantype`, `reason`, `expiration_time`, `ckey`, `ip`, `computerid`, `a_ckey`, `unbanned`
			FROM `erro_ban`
			WHERE `bantype` IN ('PERMABAN', 'TEMPBAN') AND
			([english_list(final_query_components, "", "", " OR ", " OR ")])
	"})
	query.Execute()
	var/now = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")
	while (query.NextRow())
		var/row = list(
			"bantype"         = query.item[1],
			"reason"          = query.item[2],
			"expiration_time" = query.item[3],
			"ckey"            = query.item[4],
			"ip"              = query.item[5],
			"computerid"      = query.item[6],
			"a_ckey"          = query.item[7],
			"unbanned"        = query.item[8]
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
		<table class="data hover">
			<tbody>
	"}
	var/stripe = FALSE
	for (var/ckey in unique_ckeys)
		unique_ckeys_table += {"
				<tr[stripe ? " class='stripe'" : null]>
					<td[ckey == target_ckey ? " class='highlight'" : null]>[ckey]</td>
				</tr>
		"}
		stripe = !stripe
	unique_ckeys_table += {"
			</tbody>
		</table>
	"}

	// List of all bans
	var/all_bans_table = {"
		<table class="data hover">
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
	stripe = FALSE
	for (var/list/row in bans)
		// Row classes
		var/classes_row = list()
		if (stripe)
			classes_row += "stripe"

		// Ckey classes
		var/classes_ckey = ""
		var/ckey = row["ckey"]
		if (!row["ckey"])
			classes_ckey = "disabled"
			ckey = "(EMPTY)"
		else if (row["ckey"] == target_ckey)
			classes_ckey = "highlight"
		if (classes_ckey)
			classes_ckey = " class='[classes_ckey]'"

		// IP classes
		var/classes_ip = ""
		var/ip = row["ip"]
		if (!row["ip"])
			classes_ip = "disabled"
			ip = "(EMPTY)"
		else if (row["ip"] == target_ip)
			classes_ip = "highlight"
		if (classes_ip)
			classes_ip = " class='[classes_ip]'"

		// CID classes
		var/classes_cid = ""
		var/cid = row["computerid"]
		if (!row["computerid"])
			classes_cid = "disabled"
			cid = "(EMPTY)"
		else if (row["computerid"] == target_cid)
			classes_cid = "highlight"
		if (classes_cid)
			classes_cid = " class='[classes_cid]'"

		// Status cell
		var/status = "ACTIVE"
		if (row["expired"])
			status = row["unbanned"] ? "UNBANNED" : "EXPIRED"
			classes_row += "disabled"
		else
			switch (row["bantype"])
				if ("PERMABAN")
					status += " (PERMANENT)"
				if ("TEMPBAN")
					status += " (UNTIL [row["expiration_time"]])"

		// Combine row classes
		if (length(classes_row))
			classes_row = " class='[english_list(classes_row, "", "", " ", " ")]'"
		else
			classes_row = null

		// Build table row
		all_bans_table += {"
				<tr[classes_row]>
					<td[classes_ckey]>[ckey]</td>
					<td[classes_ip]>[ip]</td>
					<td[classes_cid]>[cid]</td>
					<td>[status]</td>
					<td>[row["a_ckey"]]</td>
				</tr>
				<tr[classes_row]>
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
		<h2>Queried Details</h2>
		<table class="data">
			<thead>
				<tr>
					<th style='width: 33%';>Ckey</th>
					<th style='width: 33%';>IP Address</th>
					<th style='width: 33%';>Computer ID</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td class='[target_ckey ? "highlight" : "disabled"]'>[target_ckey ? target_ckey : "(EMPTY)"]</td>
					<td class='[target_ip ? "highlight" : "disabled"]'>[target_ip ? target_ip : "(EMPTY)"]</td>
					<td class='[target_cid ? "highlight" : "disabled"]'>[target_cid ? target_cid : "(EMPTY)"]</td>
				</tr>
			</tbody>
		</table>
		<hr />

		<h2>Matching Banned Ckeys</h2>
		<p><small>Entries matching the current query are <span class='highlight'>highlighted</span>.</small></p>
		[unique_ckeys_table]
		<hr />

		<h2>All Matching Bans</h2>
		<p><small>Entries matching the current query are <span class='highlight'>highlighted</span>.</small></p>
		[all_bans_table]
	"}
	var/datum/browser/popup = new(user, "associatedbans", "Associated Bans ([target_ckey ? target_ckey : "NO CKEY"])", 700, 480)
	popup.set_content(final_body)
	popup.open()


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
