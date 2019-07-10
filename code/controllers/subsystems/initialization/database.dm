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
#ifdef USE_DMPG
		db = new /datum/database/dmpg(config.database_url)
#else
		CRASH("database URI supplied but not compiled with DMPG support")
#endif
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

	. = ..()

/datum/controller/subsystem/database/proc/LoadBanScopes()
	ban_scope_categories.Cut()

	ban_scope_categories["Server"] = list("server")

	var/list/department_scopes = list()

	for (var/dept in departments_by_name)
		var/list/category = list()
		department_scopes |= dept

		for (var/title in SSjobs.titles_by_department(departments_by_name[dept]))
			category |= title

		ban_scope_categories[dept] = category

	ban_scope_categories["Department"] = department_scopes

	var/list/branch_scopes = list()

	for (var/branchname in mil_branches.branches)
		var/datum/mil_branch/branch = mil_branches.branches[branchname]
		branch_scopes |= branch.name_short
		var/list/branch_ranks = list()
		for (var/rankname in branch.ranks)
			var/datum/mil_rank/rank = branch.ranks[rankname]
			if (rank.grade())
				branch_ranks |= "[branch.name_short]_[rank.grade()]" // must match check in is_rank_banned
			else
				branch_ranks |= "[branch.name_short]_[rank.name]"
		ban_scope_categories[branchname] = branch_ranks
	ban_scope_categories["Branch"] = branch_scopes

	var/list/antag_scopes = list()

	var/list/all_antag_types = GLOB.all_antag_types_
	for (var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		antag_scopes |= antag.id

	ban_scope_categories["Antag"] = antag_scopes

	var/list/channel_scopes = list()
	var/list/channel_types = decls_repository.get_decls_of_subtype(/decl/communication_channel)
	for (var/channel_type in channel_types)
		var/decl/communication_channel/channel = channel_types[channel_type]
		channel_scopes |= channel.name
	ban_scope_categories["Channel"] = channel_scopes

	var/list/other_scopes = list()
	other_scopes |= BAN_ANTAG
	other_scopes |= BAN_ERT
	other_scopes |= BAN_ROBOT
	other_scopes |= BAN_MAINTDRONE
	other_scopes |= BAN_ANIMAL
	other_scopes |= BAN_ANTAGHUD
	other_scopes |= BAN_AI
	other_scopes |= BAN_RECORDS
	other_scopes |= BAN_GRAFFITI
	other_scopes |= BAN_OFFSTATION
	other_scopes |= BAN_AGITATOR
	ban_scope_categories["Other"] = other_scopes

/datum/controller/subsystem/database/proc/RegisterBanScopes()
	for (var/category in ban_scope_categories)
		for (var/scope in ban_scope_categories[category])
			db.RegisterBanScope(scope, category, BAN_SCOPE_VERSION)

#undef BAN_SCOPE_VERSION
