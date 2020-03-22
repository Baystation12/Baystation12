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
		SetVersion(text2num(query.item[1]))
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
		//
		// 	PREPARATION SECTIONS
		//
		var/list/areas_to_save = list() // TODO: Fill this with values.
		var/reallow = 0
		if(config.enter_allowed) reallow = 1
		config.enter_allowed = 0
		// Prepare atmosphere for saving.
		for(var/datum/pipe_network/net in SSmachines.pipenets)
			for(var/datum/pipeline/line in net.line_members)
				line.temporarily_store_air()

		//
		// 	ACTUAL SAVING SECTION
		//
		// This will save all the turfs/world.
		var/index = 1
		for(var/z in SSmapping.saved_levels)
			for(var/x in 1 to world.maxx)
				for(var/y in 1 to world.maxy)
					// Get the thing to serialize and serialize it.
					var/turf/T = locate(x,y,z)
					if(!T || ((T.type == /turf/space) && (!T.contents || !T.contents.len))) //  || T.type == /turf/simulated/open
						continue
					serializer.SerializeThing(T)

					// Don't save every single tile.
					// Batch them up to save time.
					if(index % 32 == 0)
						serializer.Commit()
						index = 1
					else
						index++

					// Prevent the whole game from locking up.
					CHECK_TICK
			serializer.Commit() // cleanup leftovers.

		// This section will save any areas in the world.
		for(var/area/A in areas_to_save)
			if(istype(A, /area/space)) continue
			var/datum/wrapper/area/wrapper = new(A)
			serializer.SerializeThing(wrapper)
			CHECK_TICK
		//
		//	CLEANUP SECTION
		//
		// Clear the refmaps/do other cleanup to end the save.
		serializer.Clear()
		if(reallow) config.enter_allowed = 1
	catch (var/exception/e)
		to_world_log("Save failed on line [e.line], file [e.file] with message: '[e]'.")

/datum/persistence/world_handle/proc/LoadWorld()
	try
		// Loads all data in as part of a version.
		establish_db_connection()
		if(!dbcon.IsConnected())
			return

		var/DBQuery/query = dbcon.NewQuery("SELECT COUNT(*) FROM `thing` WHERE `version`=[version];")
		query.Execute()
		if(query.NextRow())
			// total_entries = text2num(query.item[1])
			to_world_log("Loading [query.item[1]] things from world save.")

		// We start by loading the cache. This will load everything from SQL into an object structure
		// and is much faster than live-querying for information.
		serializer.resolver.load_cache(version)

		// Begin deserializing the world.
		var/start = world.timeofday
		var/turfs_loaded = 0
		for(var/TKEY in serializer.resolver.things)
			var/datum/persistence/load_cache/thing/T = serializer.resolver.things[TKEY]
			if(!T.x || !T.y || !T.z)
				continue // This isn't a turf. We can skip it.
			serializer.DeserializeThing(T)
			turfs_loaded++
			CHECK_TICK
		to_world_log("Load complete! Took [world.timeofday-start] to load [length(serializer.resolver.things)] things. Loaded [turfs_loaded] turfs.")

		// Cleanup the cache. It uses a *lot* of memory.
		for(var/id in serializer.reverse_map)
			var/datum/T = serializer.reverse_map[id]
			T.after_deserialize()
		serializer.resolver.clear_cache()
		serializer.Clear()
	catch(var/exception/e)
		to_world_log("Load failed on line [e.line], file [e.file] with message: '[e]'.")


// /datum/persistence/world_handle/proc/LoadChunk(var/x, var/y, var/z)