#define SCHEMA_VERSION 1
#define CHECK_EXEC(x) if (!x.Execute()) CRASH(x.ErrorMsg())
#define RETURN_EXEC(x) if (!x.Execute()) return db_error(x.ErrorMsg())
/datum/database/sqlite
	var/database/db

	var/database/query/q = new

/datum/database/sqlite/proc/migrate_schema(var/oldver)
	if (isnull(oldver))
		create_schema()
	else
		CRASH("unsupported old version for sqlite migration")

/datum/database/sqlite/proc/create_schema()
	to_world_log("Creating sqlite schema")
	q.Add({"
	CREATE TABLE bs12_rank(
		id INTEGER NOT NULL PRIMARY KEY,
		name TEXT NOT NULL,
		permissions INTEGER NOT NULL,
		flags INTEGER NOT NULL DEFAULT 0
	)
	"})
	CHECK_EXEC(q)
	q.Add({"
	CREATE TABLE bs12_admin(
		id INTEGER NOT NULL PRIMARY KEY,
		ckey TEXT NOT NULL UNIQUE,
		rank INTEGER NOT NULL REFERENCES bs12_rank(id) ON DELETE CASCADE
	)
	"})
	CHECK_EXEC(q)
	q.Add({"
	CREATE TABLE bs12_library(
		id INTEGER NOT NULL PRIMARY KEY,
		ckey TEXT NOT NULL,
		category TEXT NOT NULL,
		author TEXT NOT NULL,
		title TEXT NOT NULL,
		content TEXT NOT NULL
	)
	"})
	CHECK_EXEC(q)
	q.Add({"
	CREATE TABLE bs12_whitelist(
		id INTEGER NOT NULL PRIMARY KEY,
		ckey TEXT NOT NULL,
		scope TEXT NOT NULL,
		UNIQUE(ckey, scope)
	)
	"})
	CHECK_EXEC(q)
	q.Add({"
	CREATE TABLE bs12_ban(
		id INTEGER PRIMARY KEY,
		ckey TEXT,
		ip TEXT,
		computerid INTEGER,
		scope TEXT NOT NULL,
		admin TEXT NOT NULL,
		reason TEXT NOT NULL,
		expiry TEXT
	)
	"})
	CHECK_EXEC(q)
	q.Add({"
	CREATE TABLE schema_version(
		id INTEGER NOT NULL PRIMARY KEY,
		version INTEGER NOT NULL,
		CHECK(id = 1)
	)
	"})
	CHECK_EXEC(q)
	q.Add("INSERT INTO schema_version(version) VALUES(?)", SCHEMA_VERSION)
	CHECK_EXEC(q)

/datum/database/sqlite/Init()
	db = new("data/bs12.db")
	var/ver = null
	q.Add("PRAGMA foreign_keys = on")
	q.Execute(db) // db needn't be passed after this
	q.Add("SELECT version FROM schema_version")
	q.Execute()
	if (q.NextRow())
		ver = q.GetRowData()["version"]
		to_world_log("Detected sqlite schema [ver]")
	if (isnull(ver) || ver < SCHEMA_VERSION)
		to_world_log("Detected outdated or nonexistent sqlite database (ver: [ver])")
		migrate_schema(ver)

/datum/database/sqlite/Connected()
	return !isnull(db)

/datum/database/sqlite/GetAdminRanks()
	q.Add("SELECT name, permissions, flags FROM bs12_rank")
	CHECK_EXEC(q)
	var/list/ranks = new
	while (q.NextRow())
		ranks += list(q.GetRowData())
	return ranks

/datum/database/sqlite/RecordAdminRank(var/name, var/permissions, var/flags)
	q.Add("INSERT INTO bs12_rank(name, permissions, flags) VALUES (?, ?, ?)", name, permissions, flags)
	RETURN_EXEC(q)
	. = 1

/datum/database/sqlite/UpdateAdminRank(var/oldname, var/name, var/permissions, var/flags)
	q.Add("UPDATE bs12_rank SET name=?, permissions=?, flags=? WHERE name=?", name, permissions, flags, oldname)
	RETURN_EXEC(q)
	. = 1

/datum/database/sqlite/RemoveAdminRank(var/name)
	q.Add("DELETE FROM bs12_rank WHERE name=?", name)
	RETURN_EXEC(q)
	. = 1

/datum/database/sqlite/GetAdmins()
	q.Add("SELECT ckey, name FROM bs12_admin INNER JOIN bs12_rank ON bs12_admin.rank = bs12_rank.id")
	CHECK_EXEC(q)
	var/list/admins = new
	while (q.NextRow())
		admins += list(q.GetRowData())
	return admins

/datum/database/sqlite/GetAdmin(var/ckey)
	q.Add("SELECT name, permissions, flags FROM bs12_admin INNER JOIN bs12_rank ON bs12_admin.rank = bs12_rank.id WHERE ckey = ?", ckey)
	CHECK_EXEC(q)
	. = null
	if (q.NextRow())
		var/list/data = q.GetRowData()
		return list(data["name"], data["permissions"], data["flags"])

/datum/database/sqlite/SetAdminRank(var/ckey, var/rank)
	q.Add("INSERT OR REPLACE INTO bs12_admin(ckey, rank) VALUES(?, (SELECT id FROM bs12_rank WHERE name = ?))", ckey, rank, rank)
	RETURN_EXEC(q)
	. = 1

/datum/database/sqlite/RemoveAdmin(var/ckey)
	q.Add("DELETE FROM bs12_admin WHERE ckey = ?", ckey)
	RETURN_EXEC(q)

/datum/database/sqlite/GetAllLibraryBooks()
	var/list/books = new
	q.Add("SELECT id, author, category, title, content FROM bs12_library")
	CHECK_EXEC(q)
	while (q.NextRow())
		var/list/data = q.GetRowData()
		books += list(data)
	log_and_message_admins("there are [books.len] books!")
	return books

/datum/database/sqlite/GetLibraryBook(var/id)
	q.Add("SELECT id, author, category, title, content FROM bs12_library WHERE id = ?", id)
	if (!q.Execute())
		return null
	if (q.NextRow())
		return q.GetRowData()

/datum/database/sqlite/CreateLibraryBook(var/ckey, var/category, var/author, var/title, var/content)
	q.Add("INSERT INTO bs12_library(ckey, author, category, title, content) VALUES (?, ?, ?, ?, ?)", ckey, author, category, title, content)
	RETURN_EXEC(q)
	. = 1

/datum/database/sqlite/GetWhitelists(var/ckey)
	var/list/scopes = new
	q.Add("SELECT scope FROM bs12_whitelist WHERE ckey = ?", ckey)
	CHECK_EXEC(q)
	while (q.NextRow())
		scopes += list(q.GetRowData()["scope"])
	return scopes

/datum/database/sqlite/SetWhitelist(var/ckey, var/scope)
	q.Add("INSERT INTO bs12_whitelist(ckey, scope) VALUES(?, ?)", ckey, scope)
	RETURN_EXEC(q)
	. = 1

/datum/database/sqlite/RemoveWhitelist(var/ckey, var/scope)
	q.Add("DELETE FROM bs12_whitelist WHERE ckey = ? AND scope = ?", ckey, scope)
	RETURN_EXEC(q)
	. = 1

/datum/database/sqlite/BannedForScope(var/scope, var/ckey, var/ip, var/cid)
	q.Add("SELECT admin, reason, expiry FROM bs12_ban WHERE (ckey = ? OR ip = ? OR computerid = ?) AND scope = ?", ckey, ip, cid, scope)
	CHECK_EXEC(q)
	if (q.NextRow())
		return q.GetRowData()
	return list()

/datum/database/sqlite/GetBan(var/id)
	q.Add("SELECT id, ckey, ip, computerid, admin, reason, expiry, scope, expiry <= DATETIME('now') AS expired FROM bs12_ban WHERE id = ?", id)
	if (!q.Execute())
		return null
	if (q.NextRow())
		return q.GetRowData()


/datum/database/sqlite/GetBans(var/ckey, var/ip, var/cid)
	var/list/bans = new
	q.Add("SELECT id, ckey, ip, computerid, admin, reason, expiry, scope, expiry <= DATETIME('now') AS expired FROM bs12_ban WHERE ckey = ? OR ip = ? OR computerid = ?", ckey, ip, cid)
	CHECK_EXEC(q)
	while (q.NextRow())
		bans += list(q.GetRowData())
	return bans

/datum/database/sqlite/RecordBan(var/scopes, var/setter_key, var/reason, var/expiry, var/ckey, var/ip, var/cid)
	for (var/scope in scopes)
		q.Add("INSERT INTO bs12_ban(ckey, ip, computerid, scope, admin, reason, expiry) VALUES (?, ?, ?, ?, ?, ?, DATETIME('now', ? || ' minutes'))", ckey, ip, cid, scope, setter_key, reason, expiry)
		CHECK_EXEC(q)
	. = 1

/datum/database/sqlite/RemoveBan(var/id, var/remover_ckey)
	q.Add("UPDATE bs12_ban SET expiry = DATETIME('now'), reason = reason || ' - Removed by ' || ? WHERE id = ?", remover_ckey, id)
	RETURN_EXEC(q)
	. = 1

#undef RETURN_EXEC
#undef CHECK_EXEC
#undef SCHEMA_VERSION
