/datum/persistence/serializer
	var/thing_index = 1
	var/var_index = 1
	var/list_index = 1
	var/element_index = 1

	var/list/thing_map = list()
	var/list/reverse_map = list()
	var/list/list_map = list()

	var/list/thing_inserts = list()
	var/list/var_inserts = list()
	var/list/list_inserts = list()
	var/list/element_inserts = list()
#ifdef SAVE_DEBUG
	var/verbose_logging = FALSE
#endif

/datum/persistence/serializer/proc/isproc(var/test)
	var/ref = copytext("\ref[test]",4,6)
	return ref == "26"

/datum/persistence/serializer/proc/FetchIndexes()
	establish_db_connection()
	if(!dbcon.IsConnected())
		return
	var/DBQuery/query = dbcon.NewQuery("SELECT MAX(`id`) FROM `thing`;")
	query.Execute()
	while(query.NextRow())
		thing_index = text2num(query.item[1]) + 1
		break

	query = dbcon.NewQuery("SELECT MAX(`id`) FROM `thing_var`;")
	query.Execute()
	while(query.NextRow())
		var_index = text2num(query.item[1]) + 1
		break

	query = dbcon.NewQuery("SELECT MAX(`id`) FROM `list`;")
	query.Execute()
	while(query.NextRow())
		list_index = text2num(query.item[1]) + 1
		break

	query = dbcon.NewQuery("SELECT MAX(`id`) FROM `list_element`;")
	query.Execute()
	while(query.NextRow())
		element_index = text2num(query.item[1]) + 1
		break

/datum/persistence/serializer/proc/SerializeList(var/_list)
	if(isnull(_list))
		return

	var/list/existing = list_map["\ref[_list]"]
	if(!isnull(existing))
#ifdef SAVE_DEBUG
		if(verbose_logging)
			to_world_log("(SerializeList-Resv) \ref[_list] to [existing]")
#endif
		return existing

	var/l_i = list_index
	list_index++
	list_inserts.Add("([l_i],[length(_list)],[version])")
	list_map["\ref[_list]"] = l_i

#ifdef SAVE_DEBUG
	if(verbose_logging)
		CHECK_TICK
		to_world_log("(SerializeList) ([l_i],[length(_list)],[version])")
#endif

	var/I = 1
	for(var/key in _list)
		var/e_i = element_index
		var/ET = "NULL"
		var/KT = "NULL"
		var/KV = key
		var/EV = null
		try
			EV = _list[key]
		catch
			EV = null // NBD... No value.

		// Some guard statements of things we don't want to serialize...
		if(isfile(KV) || isicon(KV) || isfile(EV) || isicon(EV))
			continue

		// Serialize the list.
		element_index++

		if (isnull(key))
			KT = "NULL"
		else if(isnum(key))
			KT = "NUM"
		else if (istext(key))
			KT = "TEXT"
		else if (islist(key))
			KT = "LIST"
			KV = SerializeList(key)
		else if(istype(key, /datum))
			KT = "OBJ"
			KV = SerializeThing(key)
		else if (ispath(key) || isproc(key))
			KT = "PATH"
		else
			// Don't know what this is. Skip it.
			element_index--
#ifdef SAVE_DEBUG
			if(verbose_logging)
				to_world_log("(SerializeListElem-Skip) Unknown Key. Value: [key]")
#endif
			continue

		if(!isnull(key) && !isnull(EV))
			if(isnum(EV))
				ET = "NUM"
			else if (istext(EV))
				ET = "TEXT"
			else if (isnull(EV))
				ET = "NULL"
			else if (islist(EV))
				ET = "LIST"
				EV = SerializeList(EV)
			else if (istype(EV, /datum))
				ET = "OBJ"
				EV = SerializeThing(EV)
			else if (ispath(EV) || isproc(EV))
				ET = "PATH"
			else
				// Don't know what this is. Skip it.
				element_index--
#ifdef SAVE_DEBUG
				if(verbose_logging)
					to_world_log("(SerializeListElem-Skip) Unknown Value")
#endif
				continue
		KV = sanitizeSQL("[KV]")
		EV = sanitizeSQL("[EV]")
#ifdef SAVE_DEBUG
		if(verbose_logging)
			to_world_log("(SerializeListElem-Done) ([e_i],[l_i],[I],\"[KV]\",'[KT]',\"[EV]\",\"[ET]\",[version])")
#endif
		element_inserts.Add("([e_i],[l_i],[I],\"[KV]\",'[KT]',\"[EV]\",\"[ET]\",[version])")
		I++
	return l_i

/datum/persistence/serializer/proc/SerializeThing(var/datum/thing)
	// Check for existing references first. If we've already saved
	// there's no reason to save again.
	if(isnull(thing))
		return

	var/datum/existing = thing_map["\ref[thing]"]
	if (!isnull(existing))
#ifdef SAVE_DEBUG
		if(verbose_logging)
			to_world_log("(SerializeThing-Resv) \ref[thing] to [existing]")
#endif
		return existing

	// Thing didn't exist. Create it.
	var/t_i = thing_index
	thing_index++

	var/x = 0
	var/y = 0
	var/z = 0

	thing.before_save() // Before save hook.
	if(ispath(thing.type, /turf))
		var/turf/T = thing
		x = T.x
		y = T.y
		z = T.z

#ifdef SAVE_DEBUG
	CHECK_TICK
	if(x == 34 && y == 106 && z == 1)
		verbose_logging = TRUE
	// else
	// 	verbose_logging = FALSE

	if(verbose_logging)
		to_world_log("(SerializeThing) ([t_i],'[thing.type]',[x],[y],[z],[version])")
#endif
	thing_inserts.Add("([t_i],'[thing.type]',[x],[y],[z],[version])")
	thing_map["\ref[thing]"] = t_i
	for(var/V in thing.get_saved_vars())
		if(!issaved(thing.vars[V]))
			continue
		var/VV = thing.vars[V]
		var/VT = "VAR"
#ifdef SAVE_DEBUG
		if(verbose_logging)
			to_world_log("(SerializeThingVar) [V]")
#endif

		// Some guard statements of things we don't want to serialize...
		if(isfile(VV) || isicon(VV))
			continue

		var/v_i = var_index
		var_index++

		if(islist(VV) && !isnull(VV))
			// Complex code for serializing lists...
			if(length(VV) == 0)
				// Another optimization. Don't need to serialize lists
				// that have 0 elements.
				var_index--
#ifdef SAVE_DEBUG
				if(verbose_logging)
					to_world_log("(SerializeThingVar-Skip)")
#endif
				continue
			VT = "LIST"
			VV = SerializeList(VV)
		else if (isnum(VV))
			VT = "NUM"
		else if (istext(VV))
			VT = "TEXT"
		else if (isnull(VV))
			VT = "NULL"
		else if (istype(VV, /datum))
			// Serialize it complex-like, baby.
			VT = "OBJ"
			VV = SerializeThing(VV)
		else if (ispath(VV) || isproc(VV)) // After /datum check to avoid high-number obj refs
			VT = "PATH"
		else
			// We don't know what this is. Skip it.
			var_index--
#ifdef SAVE_DEBUG
			if(verbose_logging)
				to_world_log("(SerializeThingVar-Skip)")
#endif
			continue
		VV = sanitizeSQL("[VV]")
#ifdef SAVE_DEBUG
		if(verbose_logging)
			to_world_log("(SerializeThingVar-Done) ([v_i],[t_i],'[V]','[VT]',\"[VV]\",[version])")
#endif
		var_inserts.Add("([v_i],[t_i],'[V]','[VT]',\"[VV]\",[version])")
	thing.after_save() // After save hook.		
	return t_i

/datum/persistence/serializer/proc/DeserializeThing(var/thing_id, var/thing_path, var/x, var/y, var/z)
	// Will deserialize a thing by ID, including all of its
	// child variables.
	// Fixing some SQL shit.
	x = text2num(x)
	y = text2num(y)
	z = text2num(z)

	// Checking for existing items.
	var/existing
	try
		existing = reverse_map[num2text(thing_id)]
		if(!isnull(existing))
			return existing
	catch

	if(!dbcon.IsConnected())
		return

	// Handlers for specific types would go here.
	if (ispath(thing_path, /turf))
		// turf turf turf
		var/turf/T = locate(x, y, z)
		T.ChangeTurf(thing_path)
		if (T == null)
			to_world_log("Attempting to deserialize onto turf [x],[y],[z] failed. Could not locate turf.")
			return
		existing = T
	else
		// default creation
		existing = new thing_path()

	reverse_map[num2text(thing_id)] = existing
	var/DBQuery/query = dbcon.NewQuery("SELECT `key`,`type`,`value` FROM `thing_var` WHERE `version`=[version] AND `thing_id`=[thing_id];")
	query.Execute()
	while(query.NextRow())
		// Each row is a variable on this object.
		var/key = query.item[1]
		var/key_type = query.item[2]
		if (key_type == "NUM")
			existing[key] = text2num(query.item[3])
		else if (key_type == "TEXT")
			existing[key] = query.item[3]
		else if (key_type == "PATH")
			existing[key] = text2path(query.item[3])
		else if (key_type == "NULL")
			existing[key] = null
		else if (key_type == "LIST")
			existing[key] = DeserializeList(text2num(query.item[3]))
		else if (key_type == "OBJ")
			var/DBQuery/objQuery = dbcon.NewQuery("SELECT `id`,`type`,`x`,`y`,`z` FROM `thing` WHERE `version`=[version] AND `id`=[query.item[3]];")
			objQuery.Execute()
			while(objQuery.NextRow())
				existing[key] = DeserializeThing(text2num(query.item[3]), text2path(objQuery.item[2]), objQuery.item[3], objQuery.item[4], objQuery.item[5])
				break
	return existing

/datum/persistence/serializer/proc/DeserializeList(var/list_id)
	// Will deserialize and return a list.
	if(!dbcon.IsConnected())
		return

	var/list/existing = list()
	var/DBQuery/query = dbcon.NewQuery("SELECT `key`,`key_type`,`value`,`value_type` FROM `list_element` WHERE `list_id`=[list_id] AND `version`=[version] ORDER BY `index` DESC;")
	query.Execute()
	while(query.NextRow())
		var/key = query.item[1]
		var/key_type = query.item[2]
		var/key_value = key
		var/value_type = query.item[4]

		if (key_type == "NUM")
			key_value = text2num(key)
		else if (key_type == "PATH")
			key_value = text2path(key)
		else if (key_type == "LIST")
			key_value = DeserializeList(text2num(key))
		else if (key_type == "OBJ")
			var/DBQuery/objQuery = dbcon.NewQuery("SELECT `id`,`type`,`x`,`y`,`z` FROM `thing` WHERE `version`=[version] AND `id`=[key];")
			objQuery.Execute()
			while(objQuery.NextRow())
				key_value = DeserializeThing(text2num(key), text2path(objQuery.item[2]), objQuery.item[3], objQuery.item[4], objQuery.item[5])
				break

		if(value_type == "NUM")
			existing[key_value] = text2num(query.item[3])
		else if(value_type == "TEXT")
			existing[key_value] = query.item[3]
		else if(value_type == "PATH")
			existing[key_value] = text2path(query.item[3])
		else if(value_type == "NULL")
			existing.Add(key_value)
		else if(value_type == "LIST")
			existing[key_value] = DeserializeList(text2num(query.item[3]))
		else if(value_type == "OBJ")
			var/DBQuery/objQuery = dbcon.NewQuery("SELECT `id`,`type`,`x`,`y`,`z` FROM `thing` WHERE `version`=[version] AND `id`=[query.item[3]];")
			objQuery.Execute()
			while(objQuery.NextRow())
				existing[key_value] = DeserializeThing(text2num(query.item[3]), text2path(objQuery.item[2]), objQuery.item[3], objQuery.item[4], objQuery.item[5])
				break
	return existing

/datum/persistence/serializer/proc/Commit()
	establish_db_connection()
	if(!dbcon.IsConnected())
		return

	var/values
	var/DBQuery/query

	try
		if(length(thing_inserts) > 0)
			values = jointext(thing_inserts, ",")
			query = dbcon.NewQuery("INSERT INTO `thing`(`id`,`type`,`x`,`y`,`z`,`version`) VALUES[values]")
			query.Execute()
		if(length(var_inserts) > 0)
			values = jointext(var_inserts, ",")
			query = dbcon.NewQuery("INSERT INTO `thing_var`(`id`,`thing_id`,`key`,`type`,`value`,`version`) VALUES[values]")
			query.Execute()
		if(length(list_inserts) > 0)
			values = jointext(list_inserts, ",")
			query = dbcon.NewQuery("INSERT INTO `list`(`id`,`length`,`version`) VALUES[values]")
			query.Execute()
		if(length(element_inserts) > 0)
			values = jointext(element_inserts, ",")
			query = dbcon.NewQuery("INSERT INTO `list_element`(`id`,`list_id`,`index`,`key`,`key_type`,`value`,`value_type`,`version`) VALUES[values]")
			query.Execute()
	catch (var/exception/e)
		to_world_log("World Serializer Failed")
		to_world_log(e)

	thing_inserts.Cut(1)
	var_inserts.Cut(1)
	list_inserts.Cut(1)
	element_inserts.Cut(1)
