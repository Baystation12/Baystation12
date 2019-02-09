#define BAN_SCOPE_VERSION 1

SUBSYSTEM_DEF(database)
	name = "Database"
	init_order = SS_INIT_DB
	flags = SS_NO_FIRE

	var/database_url

	var/datum/database/db

	var/list/ban_scope_categories = list()

/datum/controller/subsystem/database/PreInit()
	loadConfig()
	if (!database_url)
		db = new /datum/database/sqlite("")
	else
		db = new /datum/database/dmpg(config.database_url)
	db.Init()
	. = ..()

/datum/controller/subsystem/database/proc/loadConfig()
	var/list/lines = file2list("config/db.txt")

	for (var/l in lines)
		if(!l)	continue

		l = trim(l)
		if (length(l) == 0)
			continue
		else if (copytext(l, 1, 2) == "#")
			continue

		var/pos = findtext(l, "=")
		var/name = null
		var/value = null

		if (!pos)
			CRASH("invalid line in config/db.txt")
		name = lowertext(copytext(l, 1, pos))
		value = copytext(l, pos + 1)
		if (!name)
			CRASH("invalid line in config/db.txt")

		switch (name)
			if ("database_url")
				database_url = splittext(value, " ")
			else
				CRASH("invalid line in config/db.txt")

/datum/controller/subsystem/database/stat_entry()
	..(db.Connected() ? "connected" : "not connected")

/datum/controller/subsystem/database/Initialize()
	LoadBanScopes()

	var/current_schema = db.GetBanScopeSchemaVersion()

	if (isnull(current_schema) || (current_schema < BAN_SCOPE_VERSION && current_schema != -1)) // -1 means this isn't used
		RegisterBanScopes()

/datum/controller/subsystem/database/proc/LoadBanScopes()
	ban_scope_categories.Cut()

	ban_scope_categories["Server"] = list("server")

	for (var/dept in departments_by_name)
		var/list/category = list()

		for (var/title in SSjobs.titles_by_department(departments_by_name[dept]))
			category |= title

		ban_scope_categories[dept] = category

	var/list/other_scopes = list()
	other_scopes |= BAN_ERT
	other_scopes |= BAN_ROBOT
	other_scopes |= BAN_MAINTDRONE
	other_scopes |= BAN_ANIMAL
	other_scopes |= BAN_ANTAGHUD
	other_scopes |= BAN_AI
	other_scopes |= BAN_RECORDS
	other_scopes |= BAN_GRAFFITI
	other_scopes |= BAN_OFFSTATION
	other_scopes |= BAN_XENO
	ban_scope_categories["Other"] = other_scopes

/datum/controller/subsystem/database/proc/RegisterBanScopes()
	for (var/category in ban_scope_categories)
		for (var/scope in ban_scope_categories[category])
			db.RegisterBanScope(scope, category, BAN_SCOPE_VERSION)

#undef BAN_SCOPE_VERSION
