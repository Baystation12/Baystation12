#ifdef USE_DMPG

#include "..\..\..\lib\dmpg\dmapi\dmpg.dm"

#define CHECK_ERR(x) if(istext(x)) CRASH("db error: [x]")
#define RETURN_ERR(x) if (istext(x)) return db_error(x)

/datum/database/dmpg
	var/datum/DMPG/db
	var/list/ckey_cache
	var/list/cid_cache
	var/list/ip_cache

/datum/database/dmpg/Init()
	ckey_cache = list()
	cid_cache = list()
	ip_cache = list()
	to_world_log("Establishing connection using DMPG [db.Version()]")
	var/res = db.Connect(url)
	if (istext(res))
		CRASH(res)

/datum/database/dmpg/Connected()
	return db.IsConnected()

/datum/database/dmpg/GetAdminRanks()
	var/list/ranks = new
	var/list/res = db.Query("SELECT name, permissions, flags FROM bs12_rank")
	CHECK_ERR(res)
	for (var/rank in res)
		ranks += list(list(
			"name" = res[1],
			"permissions" = res[2],
			"flags" = res[3]
		))
	return ranks

/datum/database/dmpg/RecordAdminRank(var/name, var/permissions, var/flags)
	. = db.Execute("INSERT INTO bs12_rank(name, permissions, flags) VALUES ($1, $2, $3)", name, permissions, flags)
	RETURN_ERR(.)

/datum/database/dmpg/UpdateAdminRank(var/oldname, var/name, var/permissions, var/flags)
	. = db.Execute("UPDATE bs12_rank SET name=$1, permissions=$2, flags=$3 WHERE name=$4", name, permissions, flags, oldname)
	RETURN_ERR(.)

/datum/database/dmpg/GetAdmin(var/ckey)
	var/list/res = db.Query("SELECT name, permissions, flags FROM bs12_player INNER JOIN bs12_rank ON bs12_player.rank = bs12_rank.id WHERE ckey = $1", ckey)
	CHECK_ERR(res)
	if (res.len > 0)
		return res[1]
	return null

/datum/database/dmpg/SetAdminRank(var/ckey, var/rank)
	. = db.Execute("UPDATE bs12_player SET rank = (SELECT id FROM bs12_rank WHERE name = $2) WHERE ckey = $1", ckey, rank)
	RETURN_ERR(.)

/datum/database/dmpg/RecordRoundStart(var/roundid)
	. = db.Execute("INSERT INTO bs12_round(roundid) VALUES ($1)", roundid)
	CHECK_ERR(.)

/datum/database/dmpg/RecordRoundEnd(var/roundid)
	. = db.Execute("UPDATE bs12_round SET endts = CURRENT_TIMESTAMP WHERE roundid = $1", roundid)
	CHECK_ERR(.)

/datum/database/dmpg/proc/GetKey(var/ckey)
	if (ckey in ckey_cache)
		return ckey_cache[ckey]
	var/list/res = db.Query("SELECT id FROM bs12_player WHERE ckey = $1", ckey)
	CHECK_ERR(res)
	if (res.len > 0)
		ckey_cache[ckey] = res[1][1]
		return res[1][1]
	res = db.Query("INSERT INTO bs12_player(ckey) VALUES ($1) RETURNING id", ckey)
	CHECK_ERR(res)
	ckey_cache[ckey] = res[1][1]
	return res[1][1]

/datum/database/dmpg/proc/GetIP(var/ip)
	if (ip in ip_cache)
		return ip_cache[ip]
	var/list/res = db.Query("SELECT id FROM bs12_ip WHERE ip = $1", ip)
	CHECK_ERR(res)
	if (res.len > 0)
		ip_cache[ip] = res[1][1]
		return res[1][1]
	res = db.Query("INSERT INTO bs12_ip(ip) VALUES ($1) RETURNING id", ip)
	CHECK_ERR(res)
	ip_cache[ip] = res[1][1]
	return res[1][1]

/datum/database/dmpg/proc/GetCID(var/cid)
	if (cid in cid_cache)
		return cid_cache[cid]
	var/list/res = db.Query("SELECT id FROM bs12_computerid WHERE computerid = $1", cid)
	CHECK_ERR(res)
	if (res.len > 0)
		cid_cache[cid] = res[1][1]
		return res[1]
	res = db.Query("INSERT INTO bs12_computerid(computerid) VALUES ($1) RETURNING id", cid)
	CHECK_ERR(res)
	cid_cache[cid] = res[1][1]
	return res[1][1]

/datum/database/dmpg/RecordLogin(var/ckey, var/ip, var/cid, var/round)
	var/ckey_id = GetKey(ckey)
	var/ip_id = GetIP(ip)
	var/cid_id = GetCID(cid)
	. = db.Execute("INSERT INTO bs12_login(player, ip, computerid) VALUES ($1, $2, $3)", ckey_id, ip_id, cid_id)
	CHECK_ERR(.)

/datum/database/dmpg/GetPlayerAge(var/ckey)
	var/list/res = db.Query("SELECT EXTRACT(DAY FROM CURRENT_TIMESTAMP - first_seen) FROM bs12_player WHERE ckey = $1", ckey)
	CHECK_ERR(res)
	return res[1][1]

/datum/database/dmpg/GetStaffwarn(var/ckey)
	var/ckey_id = GetKey(ckey)
	var/list/res = db.Query("SELECT staffwarn FROM bs12_player WHERE ckey = $1", ckey_id)
	CHECK_ERR(res)
	return res[1]

/datum/database/dmpg/SetStaffwarn(var/ckey, var/msg)
	. = db.Execute("UPDATE bs12_player SET staffwarn = $2 WHERE ckey = $1", ckey, msg)
	CHECK_ERR(.)

/datum/database/dmpg/ClearStaffwarn(var/ckey)
	. = db.Execute("UPDATE bs12_player SET staffwarn = NULL WHERE ckey = $1", ckey)

/datum/database/dmpg/GetAllLibraryBooks()
	var/list/books = new
	var/list/res = db.Query("SELECT id, author, category, title, content FROM bs12_library")
	CHECK_ERR(res)

	for (var/book in res)
		books += list(list("id"=book[1],"author"=book[2],"category"=book[3],"title"=book[4],"content"=book[5]))

	return books

/datum/database/dmpg/GetLibraryBook(var/id)
	var/list/book = db.Query("SELECT id, author, category, title, content FROM bs12_library WHERE id = $1", id)
	RETURN_ERR(book)

	return list("id"=book[1],"author"=book[2],"category"=book[3],"title"=book[4],"content"=book[5])

/datum/database/dmpg/CreateLibraryBook(var/ckey, var/category, var/author, var/title, var/content)
	var/ckey_id = GetKey(ckey)
	. = db.Execute("INSERT INTO bs12_library(author_id, category, author, title, content VALUES ($1, $2, $3, $4, $5)", ckey_id, category, author, title, content)
	CHECK_ERR(.)

/datum/database/dmpg/GetWhitelists(var/ckey)
	var/list/wl = new
	var/ckey_id = GetKey(ckey)
	var/list/res = db.Query("SELECT scope FROM bs12_whitelist WHERE player = $1", ckey_id)
	CHECK_ERR(res)
	for (var/ent in res)
		wl += ent[1]
	return wl

/datum/database/dmpg/SetWhitelist(var/ckey, var/scope)
	var/ckey_id = GetKey(ckey)
	. = db.Execute("INSERT INTO bs12_whitelist(player, scope) VALUES ($1, $2)", ckey_id, scope)

/datum/database/dmpg/RemoveWhitelist(var/ckey, var/scope)
	var/ckey_id = GetKey(ckey)
	. = db.Execute("DELETE FROM bs12_whitelist WHERE player = $1 AND scope = $2", ckey_id, scope)

/datum/database/dmpg/BannedForScope(var/scope, var/ckey, var/ip, var/cid)
	var/list/res = db.Query("SELECT p.ckey, b.reason, TEXT(DATE_TRUNC('minute', b.expiry AT TIME ZONE 'UTC')) FROM bs12_active_ban AS b INNER JOIN bs12_player AS p ON b.admin = p.id WHERE $4 = ANY(b.scope) AND ($1 = ANY(b.target_ckey) OR $2 = ANY(b.target_ip) OR $3 = ANY(b.target_computerid))", ckey, ip, cid, scope)
	CHECK_ERR(res)
	if (res.len > 0)
		return list(
			"admin" = res[1][1],
			"reason" = res[1][2],
			"expires" = res[1][3]
		)
	return list()

/datum/database/dmpg/GetBans(var/ckey, var/ip, var/cid)
	var/list/bans = new
	var/list/res = db.Query("SELECT b.id, p.ckey, b.reason, TEXT(DATE_TRUNC('minute', b.expiry AT TIME ZONE 'UTC')), b.scope FROM bs12_active_ban AS b INNER JOIN bs12_player AS p ON b.admin = p.id WHERE $1 = ANY(b.target_ckey) OR $2 = ANY(b.target_ip) OR $3 = ANY(b.target_computerid)", ckey, ip, cid)
	CHECK_ERR(res)
	for (var/ban in res)
		bans += list(list(
			"id" = res[1],
			"admin" = res[2],
			"reason" = res[3],
			"expires" = res[4],
			"scope" = res[5]
		))
	return bans

/datum/database/dmpg/RecordBan(var/scopes, var/setter_key, var/reason, var/expiry, var/ckey, var/ip, var/cid)
	var/admin_id = GetKey(setter_key)
	var/list/res = db.Query("INSERT INTO bs12_ban(admin) VALUES ($1) RETURNIING id", admin_id)
	CHECK_ERR(res)
	var/ban = res[1][1]

	. = db.Execute("INSERT INTO bs12_ban_reason (ban, admin, reason) VALUES ($1, $2, $3)", ban, admin_id, reason)
	CHECK_ERR(.)
	. = db.Execute("INSERT INTO bs12_ban_scope (ban, admin, scope) VALUES ($1, $2, $3)", ban, admin_id, scopes)
	CHECK_ERR(.)
	. = db.Execute("INSERT INTO bs12_ban_expiry (ban, admin, expiry) VALUES ($1, $2, CURRENT_TIMESTAMP + $3)", ban, admin_id, reason)
	if (istext(.))
		db.Execute("DELETE FROM bs12_ban WHERE id = $1", ban)
		return
	. = db.Execute("INSERT INTO bs12_ban_target (ban, admin, target_ip, target_ckey, target_computerid) VALUES ($1, $2, CASE WHEN $3 IS NULL THEN NULL ELSE ARRAY\[$3], CASE WHEN $3 IS NULL THEN NULL ELSE ARRAY\[$4], CASE WHEN $3 IS NULL THEN NULL ELSE ARRAY\[$5])", ban, admin_id, ckey, ip, cid)
	CHECK_ERR(.)

/datum/database/dmpg/RemoveBan(var/id, var/remover_ckey)
	var/admin_id = GetKey(remover_ckey)
	. = db.Execute("INSERT INTO bs12_ban_expiry (ban, admin, expiry) VALUES ($1, $2, CURRENT_TIMESTAMP)", id, admin_id)
	CHECK_ERR(.)

/datum/database/dmpg/GetBanScopeSchemaVersion()
	var/list/res = db.Query("SELECT MAX(version) FROM bs12_valid_scope")
	CHECK_ERR(res)

	if (res.len == 0)
		return null

	return res[1][1]

/datum/database/dmpg/RegisterBanScope(var/scope, var/category, var/version)
	. = db.Execute("INSERT INTO bs12_valid_scope(scope, category, version) VALUES ($1, $2, $3)", scope, category, version)
	CHECK_ERR(.)

#undef RETURN_ERR
#undef CHECK_ERR
#endif
