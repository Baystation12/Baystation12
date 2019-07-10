/* This is a facade type that enables a real underlying database to be used, now that one is required */

/datum/database
	var/url

/datum/database/New(var/url)
	src.url = url

/datum/database/proc/Init()
	return 0

/datum/database/proc/Connected()
	return 1

/datum/database/proc/GetAdminRanks()
	return list()

/datum/database/proc/RecordAdminRank(var/name, var/permissions, var/flags)
	return 0

/datum/database/proc/UpdateAdminRank(var/oldname, var/name, var/permissions, var/flags)
	return 0

/datum/database/proc/RemoveAdminRank(var/name)
	return 0

/datum/database/proc/GetAdmins()
	return list()

/datum/database/proc/GetAdmin(var/ckey)
	return null

/datum/database/proc/SetAdminRank(var/ckey, var/rank)
	return null

/datum/database/proc/RemoveAdmin(var/ckey)
	return 0

/datum/database/proc/RecordRoundStart(var/roundid)
	return 0

/datum/database/proc/RecordRoundEnd(var/roundid)
	return 0

/datum/database/proc/GetStaffwarn(var/ckey)
	return null

/datum/database/proc/SetStaffwarn(var/ckey, var/msg)
	return 0

/datum/database/proc/ClearStaffwarn(var/ckey)
	return 0

/datum/database/proc/RecordLogin(var/ckey, var/ip, var/cid, var/round)
	return 0

/datum/database/proc/GetPlayerAge(var/ckey)
	return null

/datum/database/proc/GetAllLibraryBooks()
	return list()

/datum/database/proc/GetLibraryBook(var/id)
	return null

/datum/database/proc/CreateLibraryBook(var/ckey, var/category, var/author, var/title, var/content)
	return 0

/datum/database/proc/GetWhitelists(var/ckey)
	return list()

/datum/database/proc/SetWhitelist(var/ckey, var/scope)
	return 0

/datum/database/proc/RemoveWhitelist(var/ckey, var/scope)
	return 0

/datum/database/proc/BannedForScope(var/scope, var/ckey, var/ip, var/cid)
	return 0

/datum/database/proc/GetBan(var/id)
	return null

/datum/database/proc/GetBans(var/ckey, var/ip, var/cid)
	return list()

/datum/database/proc/RecordBan(var/scopes, var/setter_key, var/reason, var/expiry, var/ckey, var/ip, var/cid)
	return 0

/datum/database/proc/RemoveBan(var/id, var/remover_ckey)
	return 0

/datum/database/proc/GetBanScopeSchemaVersion()
	return -1

/datum/database/proc/RegisterBanScope(var/scope, var/category, var/version)
	log_world("REGISTER: [scope] - [category] - [version]")
	return 0

/datum/database/proc/db_error(var/error)
	log_world("DB error: [error]")
	return 0
