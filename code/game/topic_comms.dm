/* * *
* topic_comms.dm
* Utilities and handlers for topic api calls.
*/

#define TOPIC_LEVEL_PUBLIC 0
#define TOPIC_LEVEL_SECURE 1
#define TOPIC_LEVEL_ADMIN 2

#define TOPIC_NOT_ENABLED "Not enabled"
#define TOPIC_NOT_ALLOWED "Not allowed"
#define TOPIC_THROTTLED "Not allowed (throttled)"

#define TOPIC_SUCCESS "Action successful"
#define TOPIC_ERR_PARAMS "Bad params"
#define TOPIC_ERR_INIT "Server not ready"
#define TOPIC_ERR_DATABASE "Database connection failed or not connected"

#define TOPIC_ANTISPAM_MIN_INTERVAL 50

var/topic_antispam_remote = "0.0.0.0" //TODO: make antispam_remote assoc to prevent multi-remote shenanigans
var/topic_antispam_time = world.timeofday


/* * *
* topic_disallow_spam
* pass: a string password to test against the configuration privileged password
* return: a string reason if the topic should not proceed, or false if it should
*/
/proc/topic_disallow_spam(remote)
	if (topic_antispam_remote == remote)
		var/interval = topic_antispam_time - world.time
		interval = (interval < 0) ? 0 : interval
		if (interval < TOPIC_ANTISPAM_MIN_INTERVAL)
			spawn(TOPIC_ANTISPAM_MIN_INTERVAL)
				topic_antispam_time = world.time
				return TOPIC_THROTTLED
	return FALSE


/* * *
* topic_disallow_staff
* pass: a string password to test against the configuration privileged password
* return: a string reason if the topic should not proceed, or false if it should
*/
/proc/topic_disallow_staff(try_password)
	if (!config.comms_password)
		return TOPIC_NOT_ENABLED
	if (config.comms_password != try_password)
		return TOPIC_NOT_ALLOWED
	return FALSE


/* * *
* topic_disallow_admin
* pass: a string password to test against the configuration administrative password
* return: a string reason if the topic should not proceed, or false if it should
*/
/proc/topic_disallow_admin(try_password)
	if (!config.ban_comms_password)
		return TOPIC_NOT_ENABLED
	if (config.ban_comms_password != try_password)
		return TOPIC_NOT_ALLOWED
	return FALSE


/* * *
* topic_disallow_request
* need_level: in [ TOPIC_LEVEL_* ]; minimum level that allows this call
* request: raw result of params2list from world topic
*
* Returns a truthy value when a topic call should NOT be handled
*/
/proc/topic_disallow_request(need_level, remote, list/request)
	if (need_level == TOPIC_LEVEL_PUBLIC)
		return FALSE

	var/result = topic_disallow_admin(request["bankey"])

	if (result && (need_level == TOPIC_LEVEL_SECURE))
		result = topic_disallow_staff(request["key"])

	if (result)
		var/throttled = topic_disallow_spam(remote)
		result = throttled ? throttled : result

	return result


/* * *
* topic_handle_ping
*   Public topic action. Fetches current connected player count.

* _arguments_
*   remote: remote IP the request originated from.
*   request: request query parameters as an associative list.

* _request entries_
*   n/a

* _response_
*   Failure message or current connected player count.
*/

/proc/topic_handle_ping(list/request)
	var/disallowed = topic_disallow_request(TOPIC_LEVEL_PUBLIC, request)
	if (disallowed)
		return disallowed

	var/count = 1

	for (var/client/C)
		count++

	return count


/* * *
* topic_handle_players
*   Public topic action. Fetches current in-round player count.

* _arguments_
*   remote: remote IP the request originated from.
*   request: request query parameters as an associative list.

* _request entries_
*   n/a

* _response_
*   Failure message or current in-round player count.
*/

/proc/topic_handle_players(remote, list/request)
	var/disallowed = topic_disallow_request(TOPIC_LEVEL_PUBLIC, remote, request)
	if (disallowed)
		return disallowed

	var/count = 0

	for (var/mob/M in GLOB.player_list)
		++count

	return count


/* * *
* topic_handle_status
*   Public topic action. Fetches current public game state information.

* _arguments_
*   remote: remote IP the request originated from.
*   request: request query parameters as an associative list.

* _request entries_
*   n/a

* _response_
*   Failure message or current public game state.
*/

/proc/topic_handle_status(remote, list/request)
	var/disallowed = topic_disallow_request(TOPIC_LEVEL_PUBLIC, remote, request)
	if (disallowed)
		return disallowed

	var/legacy = request["status"] != "2"
	var/list/players = list()
	var/list/admins = list()
	var/active_players = 0

	var/list/result = list(
		"version" = game_version,
		"mode" = PUBLIC_GAME_MODE,
		"respawn" = config.abandon_allowed,
		"enter" = config.enter_allowed,
		"vote" = config.allow_vote_mode,
		"ai" = config.allow_ai,
		"host" = host ? host : null,
		"players" = 0, //players must be entry 8 for spacestation13.com banner compatibility.
		"stationtime" = stationtime2text(),
		"roundduration" = roundduration2text(),
		"map" = GLOB.using_map.full_name,
		"admins" = 0
	)

	for (var/client/C in GLOB.clients)
		if (C.holder && !C.is_stealthed())
			admins[C.key] = C.holder.rank
		if (legacy)
			result["player[players.len]"] = C.key
		players += C.key
		if (isliving(C.mob))
			++active_players

	result["players"] = players.len
	result["admins"] = admins.len

	if (!legacy)
		result["playerlist"] = list2params(players)
		result["adminlist"] = list2params(admins)
		result["active_players"] = active_players

	return list2params(result)


/* * *
* topic_handle_manifest
*   Public topic action. Fetches current active mobs by manifest department.

* _arguments_
*   remote: remote IP the request originated from.
*   request: request query parameters as an associative list.

* _request entries_
*   n/a

* _response_
*   Failure message or department active mob counts.
*/

/proc/topic_handle_manifest(remote, list/request)
	var/disallowed = topic_disallow_request(TOPIC_LEVEL_PUBLIC, remote, request)
	if (disallowed)
		return disallowed

	var/list/result = list()
	var/list/manifest = nano_crew_manifest()

	for (var/dept in manifest)
		var/list/crew = manifest[dept]
		if (crew.len)
			result[dept] = list()
			for (var/list/person in crew)
				result[dept][person["name"]] = person["rank"]

	for (var/entry in result)
		result[entry] = list2params(result[entry])

	return list2params(result)


/* * *
* topic_handle_revision
*   Public topic action. Fetches current game build revision and server version information.

* _arguments_
*   remote: remote IP the request originated from.
*   request: request query parameters as an associative list.

* _request entries_
*   n/a

* _response_
*   Failure message or revision information.
*/

/proc/topic_handle_revision(remote, list/request)
	var/disallowed = topic_disallow_request(TOPIC_LEVEL_PUBLIC, remote, request)
	if (disallowed)
		return disallowed

	var/list/result = list(
		"gameid" = game_id,
		"dm_version" = DM_VERSION,
		"dd_version" = world.byond_version,
		"revision" = "unknown"
	)

	if (revdata.revision)
		result["revision"] = revdata.revision
		result["branch"] = revdata.branch
		result["date"] = revdata.date

	return list2params(result)


/* * *
* topic_handle_laws
*   Secure topic action. Fetches laws for the specified silicon mob.

* _arguments_
*   remote: remote IP the request originated from.
*   request: request query parameters as an associative list.

* _request entries_
*   laws: Required. Key(s) / ckey(s) of target silicon(s).

* _response_
*   Failure message OR laws for the target silicon(s) OR the list of matches if there is more than one match.
*/

/proc/topic_handle_laws(remote, list/request)
	var/disallowed = topic_disallow_request(TOPIC_LEVEL_SECURE, remote, request)
	if (disallowed)
		return disallowed

	var/target_keys = request["laws"]
	if (!target_keys)
		return TOPIC_ERR_PARAMS

	var/list/match = text_find_mobs(target_keys, /mob/living/silicon)
	if (!match.len)
		return TOPIC_ERR_PARAMS

	var/list/result = list()

	if (match.len == 1)
		var/mob/living/silicon/S = match[1]
		result["name"] = S.name
		result["key"] = S.key

		if (isrobot(S))
			var/mob/living/silicon/robot/R = S
			result["master"] = R.connected_ai?.name
			result["sync"] = R.lawupdate

		if (!S.laws)
			result["laws"] = null

		else
			var/list/lawset = list(
				"ion" = S.laws.ion_laws,
				"inherent" = S.laws.inherent_laws,
				"supplied" = S.laws.supplied_laws
			)
			for (var/type in lawset)
				var/laws = list()
				for (var/datum/ai_law/L in lawset[type])
					laws += L.law
				result[type] = list2params(laws)
			result["zero"] = S.laws.zeroth_law ? S.laws.zeroth_law.law : null

	else // more than 1 match
		for (var/mob/M in match)
			result[M.key] = M.name

	return list2params(result)


/* * *
* topic_handle_info
*   Secure topic action. Fetches current state info for the specified mob(s).

* _arguments_
*   remote: remote IP the request originated from.
*   request: request query parameters as an associative list.

* _request entries_
*   info: Required. Key(s) / ckey(s) of target mob(s).

* _response_
*   Failure message OR current state info for the target mob(s) OR the list of matches if there is more than one match.
*/

/proc/topic_handle_info(remote, list/request)
	var/disallowed = topic_disallow_request(TOPIC_LEVEL_SECURE, remote, request)
	if (disallowed)
		return disallowed

	var/target_keys = request["info"]
	if (!target_keys)
		return TOPIC_ERR_PARAMS

	var/list/match = text_find_mobs(target_keys)
	if (!match.len)
		return TOPIC_ERR_PARAMS
	
	if (match.len == 1)
		var/mob/M = match[1]
		var/turf/T = get_turf(M)
		var/list/result = list(
			"key" = M.key,
			"name" = (M.name == M.real_name) ? M.name : "[M.name] ([M.real_name])",
			"role" = M.mind ? (M.mind.assigned_role ? M.mind.assigned_role : "No role") : "No mind",
			"loc" = M.loc ? "[M.loc]" : "null",
			"turf" = T ? "[T] @ [T.x], [T.y], [T.z]" : "null",
			"area" = T ? "[T.loc]" : "null",
			"antag" = M.mind ? (M.mind.special_role ? M.mind.special_role : "Not antag") : "No mind",
			"hasbeenrev" = M.mind ? M.mind.has_been_rev : "No mind",
			"stat" = M.stat,
			"type" = M.type,
			"gender" = M.gender
		)

		if (isliving(M))
			var/mob/living/L = M
			result["damage"] = list2params(list(
				oxy = L.getOxyLoss(),
				tox = L.getToxLoss(),
				fire = L.getFireLoss(),
				brute = L.getBruteLoss(),
				clone = L.getCloneLoss(),
				brain = L.getBrainLoss()
			))

			if (ishuman(M))
				var/mob/living/carbon/human/H = M
				result["species"] = H.species.name
			else
				result["species"] = "non-human"
		
		else
			result["damage"] = "non-living"
			result["species"] = "non-human"

		return list2params(result)

	else // more than 1 match
		var/list/result = list()
		for (var/mob/M in match)
			result[M.key] = M.name

		return list2params(result)


/* * *
* topic_handle_adminmsg
*   Secure topic action. Sends an admin PM to a target client and online staff.

* _arguments_
*   remote: remote IP the request originated from.
*   request: request query parameters as an associative list.

* _request entries_
*   adminmsg: Required. Key / ckey of message recipient.
*   sender: Required. Name to use as the originating staff member.
*   rank: Optional. Rank of the originating staff member. If not supplied, uses "Staff".
*   msg: Required. Message to show to recipient and online staff.

* _response_
*   Failure message or success message.
*/

/proc/topic_handle_adminmsg(remote, list/request)
	var/disallowed = topic_disallow_request(TOPIC_LEVEL_SECURE, remote, request)
	if (disallowed)
		return disallowed

	var/message = request["msg"]
	var/sender = request["sender"]
	var/target_ckey = ckey(request["adminmsg"])
	if (!target_ckey || !message || !sender)
		return TOPIC_ERR_PARAMS

	var/rank = request["rank"]
	if (!rank || rank == "Unknown")
		rank = "Staff"

	var/client/target_client = client_by_ckey(target_ckey)
	if (!target_client)
		return TOPIC_ERR_PARAMS

	to_chat(target_client, SPAN_STAFF_PM("[rank] PM from [ANCHOR(sender, sender)]: [message]"))
	message_staff("[rank] PM from [ANCHOR(sender, sender)] to [key_name(target_client)]: [message]")

	target_client.received_irc_pm = world.time
	target_client.irc_admin = sender

	return TOPIC_SUCCESS


/* * *
* topic_handle_notes
*   Secure topic action. Fetches notes for a target client if they are available.

* _arguments_
*   remote: remote IP the request originated from.
*   request: request query parameters as an associative list.

* _request entries_
*   notes: Required. Key / ckey of target to fetch notes of.

* _response_
*   Failure message, or the notes of the specified ckey.
*/

/proc/topic_handle_notes(remote, list/request)
	var/disallowed = topic_disallow_request(TOPIC_LEVEL_SECURE, remote, request)
	if (disallowed)
		return disallowed

	var/target_ckey = ckey(request["notes"])
	return show_player_info_irc(target_ckey)


/* * *
* topic_handle_prometheus_metrics
*   Secure topic action. 

* _arguments_
*   remote: remote IP the request originated from.
*   request: request query parameters as an associative list.

* _request entries_
*   n/a

* _response_
*   Failure message, or collected metrics.
*/

/proc/topic_handle_prometheus_metrics(remote, list/request)
	var/disallowed = topic_disallow_request(TOPIC_LEVEL_SECURE, remote, request)
	if (disallowed)
		return disallowed

	if (!GLOB || !GLOB.prometheus_metrics)
		return TOPIC_ERR_INIT

	return GLOB.prometheus_metrics.collect()


/* * *
* topic_handle_age
*   Secure topic action. Fetches the age, in days since first connection, of a target client if they exist.

* _arguments_
*   remote: remote IP the request originated from.
*   request: request query parameters as an associative list.

* _request entries_
*   age: Required. Key / ckey of target to fetch age of.

* _response_
*   Failure message, or the age of the specified ckey.
*/

/proc/topic_handle_age(remote, list/request)
	var/disallowed = topic_disallow_request(TOPIC_LEVEL_SECURE, remote, request)
	if (disallowed)
		return disallowed

	var/target_ckey = ckey(request["age"])
	var/age = get_player_age(target_ckey)

	if (!isnum(age))
		return TOPIC_ERR_DATABASE
	if (age < 0)
		return TOPIC_ERR_PARAMS
	return "[age]"


/* * *
* topic_handle_placepermaban
*   Admin topic action. Applies a non-expiring ban to a target client.

* _arguments_
*   remote: remote IP the request originated from.
*   request: request query parameters as an associative list.

* _request entries_
*   target: Required. Key / ckey of target to ban.
*   id: Required. Key / ckey of banning admin.
*   reason: Required. Reason text to show to banned client.

* _response_
*   Failure message or success message.
*/

/proc/topic_handle_placepermaban(remote, list/request)
	var/disallowed = topic_disallow_request(TOPIC_LEVEL_ADMIN, remote, request)
	if (disallowed)
		return disallowed

	var/id = request["id"]
	var/reason = request["reason"]
	var/target_ckey = ckey(request["target"])
	if (!id || !reason || !target_ckey)
		return TOPIC_ERR_PARAMS

	var/client/target_client = client_by_ckey(target_ckey)
	if (!target_client)
		return TOPIC_ERR_PARAMS

	if (!_DB_ban_record(id, "0", "127.0.0.1", 1, target_client.mob, -1, reason))
		return TOPIC_ERR_DATABASE

	ban_unban_log_save("[id] has permabanned [target_ckey]. - Reason: [reason] - This is a ban until appeal.")
	notes_add(target_ckey, "[id] has permabanned [target_ckey]. - Reason: [reason] - This is a ban until appeal.", id)
	qdel(target_client)


#undef TOPIC_LEVEL_PUBLIC
#undef TOPIC_LEVEL_SECURE
#undef TOPIC_LEVEL_ADMIN
#undef TOPIC_NOT_ENABLED
#undef TOPIC_NOT_ALLOWED
#undef TOPIC_THROTTLED
#undef TOPIC_SUCCESS
#undef TOPIC_ERR_PARAMS
#undef TOPIC_ERR_INIT
#undef TOPIC_ERR_DATABASE
#undef TOPIC_ANTISPAM_MIN_INTERVAL
