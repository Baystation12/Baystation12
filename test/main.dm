/proc/dump(var/thing)
	if (istype(thing, /list))
		. = dumplist(thing).Join(",")
	else if (isnull(thing))
		. = "NULL"
	else if (isnum(thing))
		. = thing
	else
		. = "'[thing]'"

/proc/dumplist(var/list/a)
	var/list/stuff = new
	for (var/i in a)
		stuff += dump(i)
	. = stuff

/world/New()
	world.log << "Hello world"
	world.log << DMPG.Version()
	DMPG.Connect("postgres://bs12:bs12@172.16.148.1/bs12")
	var/iconn = DMPG.IsConnected()
	if (iconn)
		world.log << "connected"
	else
		world.log << "not connected"
	var/q = DMPG.Query("SELECT * FROM testdata")
	world.log << "query: [q]"
	var/dl = dumplist(q)
	for (var/i in dl)
		world.log << "row: [i]"
	var/qn = DMPG.Execute("SELECT * FROM testdata")
	world.log << "execute: [qn]"
	DMPG.Shutdown()
	shutdown()
