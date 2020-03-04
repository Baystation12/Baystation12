#define SAVECHUNK_SIZEX 16
#define SAVECHUNK_SIZEY 16

/datum/persistence
	var/version = 1

/datum/persistence/serializer
	// var/database/db = new("mydb.db")

	var/thing_index = 1
	var/var_index = 1
	var/list_index = 1
	var/element_index = 1

	var/list/thing_map = list()

	var/list/thing_inserts = list()
	var/list/var_inserts = list()
	var/list/list_inserts = list()
	var/list/element_inserts = list()

/datum/persistence/serializer/SerializeList(var/_list)
	var/l_i = list_index
	list_index += 1
	LAZYADD(list_inserts, "([l_i],[LAZYLEN(_list)],[version])")

	var/I = 1
	for(var/key in _list)
		var/e_i = element_index
		var/ET = 'NULL'
		var/KT = 'NULL'
		var/KV = key
		var/EV = _list[key]
		element_index += 1

		if(isnum(key))
			KT = 'NUM'
		else if (istext(key))
			KT = 'TEXT'
		else if (ispath(key))
			KT = 'PATH'
		else if (islist(key))
			KT = 'LIST'
			KV = SerializeList(KV)
		else
			KT = 'OBJ'
			KV = SerializeThing(KV)

		if(isnum(EV))
			ET = 'NUM'
		else if (istext(EV))
			ET = 'TEXT'
		else if (isnull(EV))
			ET = 'NULL'
		else if (ispath(EV))
			ET = 'PATH'
		else if (islist(EV))
			ET = 'LIST'
			EV = SerializeList(EV)
		else
			ET = 'OBJ'
			EV = SerializeThing(EV)
		LAZY_ADD(element_inserts, "([e_i],[l_i],[I],\"[KV]\",'[KT]','[EV]','[ET]',[version])")
		I += 1
	return l_i

/datum/persistence/serializer/SerializeThing(var/thing)
	// Check for existing references first. If we've already saved
	// there's no reason to save again.
	var/ref = thing_map["\ref[thing]"]
	if (!isnull(ref))
		return ref

	// Thing didn't exist. Create it.
	var/t_i = thing_index
	thing_index += 1

	var/x = 0
	var/y = 0
	var/z = 0

	if(ispath(thing.type, /turf))
		var/turf/T = thing
		x = T.x
		y = T.y
		z = T.z

	LAZYADD(thing_inserts, "([t_i],'[thing.type]',[x],[y],[z],[version])")
	thing_map["\ref[thing]"] = t_i
	for(var/V in thing.vars)
		var/VV = things.vars[V]
		var/VT = 'VAR'
		var/v_i = var_index
		var_index += 1

		if(islist(VV))
			// Complex code for serializing lists...
			VT = 'LIST'
			VV = SerializeList(VV)
		else if (isnum(VV))
			VT = 'NUM'
		else if (istext(VV))
			VT = 'TEXT'
		else if (isnull(VV))
			VT = 'NULL'
		else if (ispath(VV))
			VT = 'PATH'
		else
			// Only alternative is this an object. Serialize it complex-like, baby.
			VT = 'OBJ'
			VV = SerializeThing(VV)		
		LAZYADD(var_inserts, "([v_i],[t_i],'[V]','[VT]','[VV]',[version])")
	return t_i

/datum/persistence/serialize/DeserializeThing(var/thing_id, var/thing_path, var/x, var/y, var/z)
	// Will deserialize a thing by ID, including all of its
	// child variables.
	if(!dbcon.IsConnected())
		return

	// Handlers for specific types would go here.
	var/existing
	if (ispath(thing_path, /turf))
		// turf turf turf
		var/turf/T = locate(x, y, z)
		T.ChangeTurf(thing_path)
		existing = T
	else
		// default creation
		existing = new thing_path()
	
	var/DBQuery/query = dbcon.NewQuery("SELECT `key`,`type`,`value` FROM `thing_var` WHERE `version`=[version] AND `thing_id`=[thing_id];")
	query.Execute()
	while(query.NextRow())
		// Each row is a variable on this object.
		var/key = query.item[1]
		var/key_type = query.item[2]
		if (key_type == 'NUM')
			existing[key] = text2num(query.item[3])
		else if (key_type == 'TEXT')
			existing[key] = query.item[3]
		else if (key_type == 'PATH')
			existing[key] = text2path(query.item[3])
		else if (key_type == 'NULL')
			existing[key] = NULL
		else if (key_type == 'LIST')
			existing[key] = DeserializeList(text2num(query.item[3]))
		else if (key_type == 'OBJ')
			var/DBQuery/objQuery = dbcon.NewQuery("SELECT `id`,`type`,`x`,`y`,`z` FROM `thing` WHERE `version`=[version] AND `id`=[query.item[3]];")
			objQuery.Execute()
			while(objQuery.NextRow())
				existing[key] = DeserializeThing(text2num(query.item[3]), text2path(objQuery.item[2]), objQuery.item[3], objQuery.item[4], objQuery.item[5])
				break
	return existing

/datum/persistence/serializer/DeserializeList(var/list_id)
	// Will deserialize and return a list.
	if(!dbcon.IsConnected())
		return

	/var/list/existing = list()
	var/DBQuery/query = dbcon.NewQuery("SELECT `key`,`key_type`,`value`,`value_type` FROM `list_element` WHERE `list_id`=[list_id] AND `version`=[version] ORDER BY `index` DESC;")
	query.Execute()
	while(query.NextRow())
		var/key = query.item[1]
		var/key_type = query.item[2]
		var/key_value = key
		var/value_type = query.item[4]
		
		if (key_type == 'NUM')
			key_value = text2num(key)
		else if (key_type == 'PATH')
			key_value = text2path(key)
		else if (key_type == 'LIST')
			key_value = DeserializeList(text2num(key))
		else if (key_type == 'OBJ')
			var/DBQuery/objQuery = dbcon.NewQuery("SELECT `id`,`type`,`x`,`y`,`z` FROM `thing` WHERE `version`=[version] AND `id`=[key];")
			objQuery.Execute()
			while(objQuery.NextRow())
				key_value = DeserializeThing(text2num(key), text2path(objQuery.item[2]), objQuery.item[3], objQuery.item[4], objQuery.item[5])
				break

		if(value_type == 'NUM')
			existing[key_value] = text2num(query.item[3])
		else if(value_type == 'TEXT')
			existing[key_value] = query.item[3]
		else if(value_type == 'PATH')
			existing[key_value] = text2path(query.item[3])
		else if(value_type == 'NULL')
			LAZYADD(existing, key_value)
		else if(value_type == 'LIST')
			existing[key_value] = DeserializeList(text2num(query.item[3]))
		else if(value_type == 'OBJ')
			var/DBQuery/objQuery = dbcon.NewQuery("SELECT `id`,`type`,`x`,`y`,`z` FROM `thing` WHERE `version`=[version] AND `id`=[query.item[3]];")
			objQuery.Execute()
			while(objQuery.NextRow())
				existing[key_value] = DeserializeThing(text2num(query.item[3]), text2path(objQuery.item[2]), objQuery.item[3], objQuery.item[4], objQuery.item[5])
				break
	return existing

/datum/persistence/serializer/Commit()
	var/thing_query = "INSERT INTO `thing`(`id`,`type`,`x`,`y`,`z`,`version`) VALUES" + jointext(thing_inserts, ",")
	var/var_query = "INSERT INTO `thing_var`(`id`,`thing_id`,`key`,`type`,`value`,`version`) VALUES" + jointext(var_inserts, ",")
	var/list_query = "INSERT INTO `list`(`id`,`length`,`version`) VALUES" + jointext(list_inserts, ",")
	var/element_query = "INSERT INTO `list_element`(`id`,`list_id`,`index`,`key`,`key_type`,`value`,`value_type`,`version`) VALUES" + jointext(element_inserts, ",")

	establish_db_connection()
	if(!dbcon.IsConnected())
		return

	var/DBQuery/query = dbcon.NewQuery(thing_query)
	query.Execute()
	query = dbcon.NewQuery(var_query)
	query.Execute()
	query = dbcon.NewQuery(list_query)
	query.Execute()
	query = dbcon.NewQuery(element_query)
	query.Execute()

	thing_inserts = list()
	var_inserts = list()
	list_inserts = list()
	element_inserts = list()

/datum/persistence/world_handle
	var/datum/persistence/serializer/serializer = new()

/datum/persistence/world_handle/SetVersion(var/_version)
	version = _version
	serializer.version = _version

/datum/persistence/world_handle/SaveWorld()
	// This part of SaveWorld() manages saving turfs
	// to the lovely database
	z_levels = GLOB.using_map.saved_levels
	for(var/z in z_levels)
		for(var/x in 1 to world.maxx step SAVECHUNK_SIZEX)
			for(var/y in 1 to world.maxy step SAVECHUNK_SIZEY)
				Save_Chunk(x,y,z)
				serializer.Commit()

/datum/persistence/world_handle/SaveChunk(var/xi, var/yi, var/zi)
	var/z = zi
	xi = (xi - (xi % SAVECHUNK_SIZEX) + 1)
	yi = (yi - (yi % SAVECHUNK_SIZEY) + 1)
	for(var/y in yi to yi + SAVECHUNK_SIZEY)
		for(var/x in xi to xi + SAVECHUNK_SIZEX)
			var/turf/T = locate(x,y,z)
			// Want to serialize even if turf is just space
			// as saves are additive changes.
			// if(!T || ((T.type == /turf/space || T.type == /turf/simulated/open) && (!T.contents || !T.contents.len)))
			// 	continue
			serializer.SerializeThing(T)


/datum/persistence/world_handle/LoadWorld()
	// Loads all data in as part of a version.
	establish_db_connection()
	if(!dbcon.IsConnected())
		return
	
	var/DBQuery/query = dbcon.NewQuery("SELECT `id`,`type`,`x`,`y`,`z` FROM `thing` WHERE `version`=[version]")
	query.Execute()
	while(query.NextRow())
		// Blind deserialize *everything*.
		var/thing_id = query.item[1]
		var/thing_type = query.item[2]
		var/thing_path = text2path(thing_type)

		// Then we populate the entity with this data.
		serializer.DeserializeThing(thing_id, thing_path, query.item[3], query.item[4], query.item[5])


/datum/persistence/world_handle/LoadChunk(var/x, var/y, var/z)

#undef SAVECHUNK_SIZEX
#undef SAVECHUNK_SIZEY