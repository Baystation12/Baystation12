#define IS_PROC(X) (findtext("\ref[X]", "0x26"))

/datum/persistence/serializer
	var/thing_index = 1
	var/var_index = 1
	var/list_index = 1
	var/element_index = 1

	var/list/thing_map = list()
	var/list/reverse_map = list()
	var/list/list_map = list()
	var/list/reverse_list_map = list()

	var/list/thing_inserts = list()
	var/list/var_inserts = list()
	var/list/list_inserts = list()
	var/list/element_inserts = list()

#ifdef SAVE_DEBUG
	var/verbose_logging = FALSE
#endif

/datum/persistence/serializer/proc/FetchIndexes()
	establish_db_connection()
	if(!dbcon.IsConnected())
		return

	var/DBQuery/query = dbcon.NewQuery("SELECT MAX(`id`) FROM `thing`;")
	query.Execute()
	if(query.NextRow())
		thing_index = text2num(query.item[1]) + 1

	query = dbcon.NewQuery("SELECT MAX(`id`) FROM `thing_var`;")
	query.Execute()
	if(query.NextRow())
		var_index = text2num(query.item[1]) + 1

	query = dbcon.NewQuery("SELECT MAX(`id`) FROM `list`;")
	query.Execute()
	if(query.NextRow())
		list_index = text2num(query.item[1]) + 1

	query = dbcon.NewQuery("SELECT MAX(`id`) FROM `list_element`;")
	query.Execute()
	if(query.NextRow())
		element_index = text2num(query.item[1]) + 1

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
		if(isfile(KV) || isfile(EV))
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
			if(isnull(KV))
				element_index--
#ifdef SAVE_DEBUG
				if(verbose_logging)
					to_world_log("(SerializeListElem-Skip) Key thing is null.")
#endif
				continue
		else if(istype(key, /datum))
			KT = "OBJ"
			KV = SerializeThing(key)
			if(isnull(KV))
				element_index--
#ifdef SAVE_DEBUG
				if(verbose_logging)
					to_world_log("(SerializeListElem-Skip) Key list is null.")
#endif
				continue
		else if (ispath(key) || IS_PROC(key))
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
				if(isnull(EV))
					element_index--
#ifdef SAVE_DEBUG
					if(verbose_logging)
						to_world_log("(SerializeListElem-Skip) Value list is null.")
#endif
					continue
			else if (istype(EV, /datum))
				ET = "OBJ"
				EV = SerializeThing(EV)
				if(isnull(EV))
					element_index--
#ifdef SAVE_DEBUG
					if(verbose_logging)
						to_world_log("(SerializeListElem-Skip) Value thing is null.")
#endif
					continue
			else if (ispath(EV) || IS_PROC(EV))
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

	if(isnull(GLOB.saved_vars[thing.type]))
		return // EXPERIMENTAL. Don't save things without a whitelist.

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
		if(isfile(VV))
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
					to_world_log("(SerializeThingVar-Skip) Zero Length List")
#endif
				continue
			VT = "LIST"
			VV = SerializeList(VV)
			if(isnull(VV))
				var_index--
#ifdef SAVE_DEBUG
				if(verbose_logging)
					to_world_log("(SerializeThingVar-Skip) Null List")
#endif
				continue
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
			if(isnull(VV))
				var_index--
#ifdef SAVE_DEBUG
				if(verbose_logging)
					to_world_log("(SerializeThingVar-Skip) Null Thing")
#endif
				continue
		else if (ispath(VV) || IS_PROC(VV)) // After /datum check to avoid high-number obj refs
			VT = "PATH"
		else
			// We don't know what this is. Skip it.
			var_index--
#ifdef SAVE_DEBUG
			if(verbose_logging)
				to_world_log("(SerializeThingVar-Skip) Unknown Var")
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

/datum/persistence/serializer/proc/DeserializeThing(var/thing_id, var/thing_path, var/x, var/y, var/z, var/datum/existing)
	if(!dbcon.IsConnected())
		return existing

	// Will deserialize a thing by ID, including all of its
	// child variables.
	// Fixing some SQL shit.
	x = text2num(x)
	y = text2num(y)
	z = text2num(z)

	if(isnull(existing))
		// Checking for existing items.
		existing = reverse_map[num2text(thing_id)]
		if(!isnull(existing))
			return existing

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
	// Fetch all the variables for the thing.
	var/DBQuery/query = dbcon.NewQuery("SELECT `key`,`type`,`value` FROM `thing_var` WHERE `version`=[version] AND `thing_id`=[thing_id];")
	query.Execute()
	while(query.NextRow())
		// Each row is a variable on this object.
		var/items = query.GetRowData()

		try
			switch(items["type"])
				if("NUM")
					existing.vars[items["key"]] = text2num(items["value"])
				if("TEXT")
					existing.vars[items["key"]] = items["value"]
				if("PATH")
					existing.vars[items["key"]] = text2path(items["value"])
				if("NULL")
					existing.vars[items["key"]] = null
				if("LIST")
					existing.vars[items["key"]] = DeserializeList(items["value"])
				if("OBJ")
					var/DBQuery/objQuery = dbcon.NewQuery("SELECT `type`,`x`,`y`,`z` FROM `thing` WHERE `version`=[version] AND `id`=[items["value"]];")
					objQuery.Execute()
					if(objQuery.NextRow())
						var/objItems = objQuery.GetRowData()
						existing.vars[items["key"]] = DeserializeThing(text2num(items["value"]), text2path(objItems["type"]), objItems["x"], objItems["y"], objItems["z"])
		catch(var/exception/e)
			to_world_log("Failed to deserialize '[items["key"]]' of type '[items["type"]]' on line [e.line] / file [e.file] for reason: '[e]'.")
	return existing

/datum/persistence/serializer/proc/DeserializeList(var/list_id, var/list/existing)
	// Will deserialize and return a list.
	if(!dbcon.IsConnected())
		return

	if(isnull(existing))
		existing = reverse_list_map["[list_id]"]
		if(isnull(existing))
			existing = list()
	reverse_list_map["[list_id]"] = existing

	var/DBQuery/query = dbcon.NewQuery("SELECT `key`,`key_type`,`value`,`value_type` FROM `list_element` WHERE `list_id`=[list_id] AND `version`=[version] ORDER BY `index` DESC;")
	query.Execute()
	while(query.NextRow())
		var/items = query.GetRowData()
		var/key_value

		switch(items["key_type"])
			if("NULL")
				key_value = null
			if("TEXT")
				key_value = items["key"]
			if("NUM")
				key_value = text2num(items["key"])
			if("PATH")
				key_value = text2path(items["key"])
			if("LIST")
				key_value = DeserializeList(items["key"])
			if("OBJ")
				var/DBQuery/objQuery = dbcon.NewQuery("SELECT `type`,`x`,`y`,`z` FROM `thing` WHERE `version`=[version] AND `id`=[items["key"]];")
				objQuery.Execute()
				if(objQuery.NextRow())
					var/objItems = objQuery.GetRowData()
					key_value = DeserializeThing(text2num(items["key"]), text2path(objItems["type"]), objItems["x"], objItems["y"], objItems["z"])

		switch(items["value_type"])
			if("NULL")
				// This is how lists are made. Everything else is a dict.
				existing.Add(key_value)
			if("TEXT")
				existing[key_value] = items["value"]
			if("NUM")
				existing[key_value] = text2num(items["value"])
			if("PATH")
				existing[key_value] = text2path(items["value"])
			if("LIST")
				existing[key_value] = DeserializeList(items["value"])
			if("OBJ")
				var/DBQuery/objQuery = dbcon.NewQuery("SELECT `type`,`x`,`y`,`z` FROM `thing` WHERE `version`=[version] AND `id`=[items["value"]];")
				objQuery.Execute()
				if(objQuery.NextRow())
					var/objItems = objQuery.GetRowData()
					existing[key_value] = DeserializeThing(text2num(items["value"]), text2path(objItems["type"]), objItems["x"], objItems["y"], objItems["z"])
	return existing

/datum/persistence/serializer/proc/Commit()
	establish_db_connection()
	if(!dbcon.IsConnected())
		return

	var/DBQuery/query

	try
		if(length(thing_inserts) > 0)
			query = dbcon.NewQuery("INSERT INTO `thing`(`id`,`type`,`x`,`y`,`z`,`version`) VALUES[jointext(thing_inserts, ",")]")
			query.Execute()
		if(length(var_inserts) > 0)
			query = dbcon.NewQuery("INSERT INTO `thing_var`(`id`,`thing_id`,`key`,`type`,`value`,`version`) VALUES[jointext(var_inserts, ",")]")
			query.Execute()
		if(length(list_inserts) > 0)
			query = dbcon.NewQuery("INSERT INTO `list`(`id`,`length`,`version`) VALUES[jointext(list_inserts, ",")]")
			query.Execute()
		if(length(element_inserts) > 0)
			query = dbcon.NewQuery("INSERT INTO `list_element`(`id`,`list_id`,`index`,`key`,`key_type`,`value`,`value_type`,`version`) VALUES[jointext(element_inserts, ",")]")
			query.Execute()
	catch (var/exception/e)
		to_world_log("World Serializer Failed")
		to_world_log(e)

	thing_inserts.Cut(1)
	var_inserts.Cut(1)
	list_inserts.Cut(1)
	element_inserts.Cut(1)

/datum/persistence/serializer/proc/Clear()
	thing_inserts.Cut(1)
	var_inserts.Cut(1)
	list_inserts.Cut(1)
	element_inserts.Cut(1)
	thing_map.Cut(1)
	reverse_map.Cut(1)
	list_map.Cut(1)
	reverse_list_map.Cut(1)