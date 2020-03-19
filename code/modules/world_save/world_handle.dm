#define SAVECHUNK_SIZEX 4
#define SAVECHUNK_SIZEY 4

/datum/persistence/world_handle
	var/datum/persistence/serializer/serializer = new()

/datum/persistence/world_handle/proc/FetchVersion()
	SetVersion(0)

	establish_db_connection()
	if(!dbcon.IsConnected())
		return
	var/DBQuery/query = dbcon.NewQuery("SELECT MAX(`version`) FROM `thing`;")
	query.Execute()
	while(query.NextRow())
		SetVersion(text2num(query.item[1]) + 1)
		break

	serializer.FetchIndexes()

/datum/persistence/world_handle/proc/SetVersion(var/_version)
	version = _version
	serializer.version = _version

/datum/persistence/world_handle/proc/SaveWorld()
	// This part of SaveWorld() manages saving turfs
	// to the lovely database
	// Increment the version
	SetVersion(version + 1)

	// Collect the z-levels we're saving and get the turfs!
	world.log << "Saving [LAZYLEN(SSmapping.saved_levels)] z-levels."
	for(var/z in SSmapping.saved_levels)
		for(var/x in 1 to world.maxx step SAVECHUNK_SIZEX)
			for(var/y in 1 to world.maxy step SAVECHUNK_SIZEY)
				SaveChunk(x,y,z)

/datum/persistence/world_handle/proc/SaveChunk(var/xi, var/yi, var/zi)
	var/z = zi
	xi = (xi - (xi % SAVECHUNK_SIZEX) + 1)
	yi = (yi - (yi % SAVECHUNK_SIZEY) + 1)
	for(var/y in yi to yi + SAVECHUNK_SIZEY)
		for(var/x in xi to xi + SAVECHUNK_SIZEX)
			var/turf/T = locate(x,y,z)
			if(!T || ((T.type == /turf/space || T.type == /turf/simulated/open) && (!T.contents || !T.contents.len)))
				continue
			serializer.SerializeThing(T)
	serializer.Commit()

/datum/persistence/world_handle/proc/LoadWorld()
	// Loads all data in as part of a version.
	establish_db_connection()
	if(!dbcon.IsConnected())
		return

	var/DBQuery/query = dbcon.NewQuery("SELECT `id`,`type`,`x`,`y`,`z` FROM `thing` WHERE `version`=[version - 1]")
	query.Execute()
	while(query.NextRow())
		// Blind deserialize *everything*.
		var/thing_id = query.item[1]
		var/thing_type = query.item[2]
		var/thing_path = text2path(thing_type)

		// Then we populate the entity with this data.
		serializer.DeserializeThing(thing_id, thing_path, query.item[3], query.item[4], query.item[5])


// /datum/persistence/world_handle/proc/LoadChunk(var/x, var/y, var/z)

#undef SAVECHUNK_SIZEX
#undef SAVECHUNK_SIZEY