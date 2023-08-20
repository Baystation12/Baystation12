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
	var/selection = list()
	if (ckey)
		selection += "`ckey` = '[ckey]'"
	if (ip)
		selection += "`ip` = '[ip]'"
	if (cid)
		selection += "`computerid` = '[cid]'"
	selection = english_list(selection, "", "", " OR ", " OR ")
	var/DBQuery/query = dbcon.NewQuery("\
		SELECT `datetime`, `ckey`, `ip`, `computerid`\
			FROM `erro_connection_log`\
			WHERE [selection]\
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
 * Returns a sorted list containing only each unique ckey present in a list of connections provided by `_fetch_connections()`.
 */
/proc/_unique_ckeys_from_connections(list/connections)
	RETURN_TYPE(/list)
	. = list()
	for (var/list/connection in connections)
		. |= connection["ckey"]
	return sortList(.)


/**
 * Returns a sorted list containing only each unique CID present in a list of connections provided by `_fetch_connections()`.
 */
/proc/_unique_cids_from_connections(list/connections)
	RETURN_TYPE(/list)
	. = list()
	for (var/list/connection in connections)
		. |= connection["computerid"]
	return sortList(.)


/**
 * Returns a sorted list containing only each unique IP present in a list of connections provided by `_fetch_connections()`.
 */
/proc/_unique_ips_from_connections(list/connections)
	RETURN_TYPE(/list)
	. = list()
	for (var/list/connection in connections)
		. |= connection["ip"]
	return sortList(.)


/**
 * Aliases to `_fetch_connections()` with this client's ckey, address, and CID.
 *
 * Returns list of lists.
 */
/client/proc/fetch_connections()
	RETURN_TYPE(/list)
	return _fetch_connections(ckey, address, computer_id)


/**
 * Aliases to `_fetch_connections()` with this mob's client, if present, or this mob's ckey/last ckey, last IP, and last CID.
 *
 * Returns list of lists.
 */
/mob/proc/fetch_connections()
	RETURN_TYPE(/list)
	if (client)
		return client.fetch_connections()
	return _fetch_connections(ckey ? ckey : last_ckey, lastKnownIP, computer_id)


/**
 * Generates and displays an HTML window, displaying data from a `_fetch_connections()` call with the provided
 *   parameters.
 *
 * **WARNING: This proc makes no validation or access checks. Ensure `user` is a valid candidate to receive this
 *   information before calling.**
 *
 * Used by the `Check Connections` button in the player panel.
 *
 * **Parameters**:
 * - `user` - The mob requesing that the window is displayed to.
 * - `connections` - List generated from a `_fetch_connections()` call.
 * - `target_ckey` - If provided, highlights ckeys in the window that match this value.
 * - `target_ip` - If provided, highlights IP addresses in the window that match this value.
 * - `target_cid` - If provided, highlights CIDs in the window that match this value.
 *
 * Has no return value.
 */
/proc/_show_associated_connections(mob/user, list/connections, target_ckey, target_ip, target_cid)
	// Unique Ckeys
	var/list/unique_ckeys = _unique_ckeys_from_connections(connections)
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

	// Unique IP Addresses
	var/list/unique_ips = _unique_ips_from_connections(connections)
	var/unique_ips_table = {"
		<table class="data hover">
			<tbody>
	"}
	stripe = FALSE
	for (var/ip in unique_ips)
		unique_ips_table += {"
				<tr[stripe ? " class='stripe'" : null]>
					<td style='vertical-align: top;'[ip == target_ip ? " class='highlight'" : null]>[ip]</td>
				</tr>
		"}
		stripe = !stripe
	unique_ips_table += {"
			</tbody>
		</table>
	"}

	// Unique CIDs
	var/list/unique_cids = _unique_cids_from_connections(connections)
	var/unique_cids_table = {"
		<table class="data hover">
			<tbody>
	"}
	stripe = FALSE
	for (var/cid in unique_cids)
		unique_cids_table += {"
				<tr[stripe ? " class='stripe'" : null]>
					<td style='vertical-align: top;'[cid == target_cid ? " class='highlight'" : null]>[cid]</td>
				</tr>
		"}
		stripe = !stripe
	unique_cids_table += {"
			</tbody>
		</table>
	"}

	// List of all connections
	var/all_connections_table = {"
		<table class="data hover">
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
	stripe = FALSE
	for (var/list/row in connections)
		all_connections_table += {"
				<tr[stripe ? " class='stripe'" : null]>
					<td>[row["datetime"]]</td>
					<td[row["ckey"] == target_ckey ? " class='highlight'" : null]>[row["ckey"]]</td>
					<td[row["ip"] == target_ip ? " class='highlight'" : null]>[row["ip"]]</td>
					<td[row["computerid"] == target_cid ? " class='highlight'" : null]>[row["computerid"]]</td>
				</tr>
		"}
		stripe = !stripe
	all_connections_table += {"
			</tbody>
		</table>
	"}

	// Final layout
	var/final_body = {"
		<h2>Queried Details</h2>
		<table class="data hover">
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
		<hr />

		<h2>Associated Ckeys, IP Addresses, and Computer IDs</h2>
		<p><small>NOTE: Rows in this table are not necessarily associated with eachother. This is simply a list of each category's entries for ease of information.<br />
			Entries matching the current query are <span class='highlight'>highlighted</span>.</small></p>
		<table class="data"> <!-- Intentionally not set to hover. Nested tables hover instead. -->
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
		<hr />

		<h2>All Unique Connections</h2>
		<p><small>NOTE: This table does not list every single connection ever made, only the first connection seen for each unique combination of ckey, IP, and CID.<br />
			Entries matching the current query are <span class='highlight'>highlighted</span>.</small></p>
		[all_connections_table]
	"}
	var/datum/browser/popup = new(user, "associatedconnections", "Associated Connections ([target_ckey ? target_ckey : "NO CKEY"])", 500, 480)
	popup.set_content(final_body)
	popup.open()


/**
 * Aliases to `_show_associated_connections()` using this client's `fetch_connections()` result, ckey, IP address, and CID.
 *
 * Has no return value.
 */
/client/proc/show_associated_connections(mob/user, list/connections)
	if (isnull(connections))
		connections = fetch_connections()
	_show_associated_connections(user, connections, ckey, address, computer_id)


/**
 * Aliases to `_show_associated_connections()` using this mob's `fetch_connections()` result, ckey, IP address, and CID.
 *
 * Has no return value.
 */
/mob/proc/show_associated_connections(mob/user, list/connections)
	if (client)
		client.show_associated_connections(user, connections)
		return
	if (isnull(connections))
		connections = fetch_connections()
	_show_associated_connections(user, connections, ckey ? ckey : last_ckey, lastKnownIP, computer_id)
