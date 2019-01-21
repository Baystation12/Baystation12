SUBSYSTEM_DEF(database)
	name = "Database"
	init_order = SS_INIT_DB
	flags = SS_NO_FIRE

	var/database_url

	var/datum/database/db

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