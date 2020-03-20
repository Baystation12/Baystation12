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
	to_world_log("Saving [LAZYLEN(SSmapping.saved_levels)] z-levels. World size max ([world.maxx],[world.maxy])")

	try
		// This will save all the turfs/world.
		var/index = 1
		for(var/z in SSmapping.saved_levels)
			for(var/x in 1 to world.maxx)
				for(var/y in 1 to world.maxy)
					// Get the thing to serialize and serialize it.
					var/turf/T = locate(x,y,z)
					if(!T)
						continue
					serializer.SerializeThing(T)

					// Don't save every single tile.
					// Batch them up to save time.
					if(index / 16 == 1)
						serializer.Commit()
						index = 1
					else
						index++

					// Prevent the whole game from locking up.
					CHECK_TICK

		// Clear the refmaps/do other cleanup to end the save.
		serializer.Clear()
	catch (var/exception/e)
		to_world_log("Save failed on line [e.line], file [e.file] with message: '[e]'.")

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