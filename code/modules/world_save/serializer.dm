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

	var/datum/persistence/load_cache/resolver/resolver = new()

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
#ifdef SAVE_DEBUG
				if(verbose_logging)
					to_world_log("(SerializeListElem-Skip) Key thing is null.")
#endif
				continue
		else if(istype(key, /datum))
			KT = "OBJ"
			KV = SerializeThing(key)
			if(isnull(KV))
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
#ifdef SAVE_DEBUG
					if(verbose_logging)
						to_world_log("(SerializeListElem-Skip) Value list is null.")
#endif
					continue
			else if (istype(EV, /datum))
				ET = "OBJ"
				EV = SerializeThing(EV)
				if(isnull(EV))
#ifdef SAVE_DEBUG
					if(verbose_logging)
						to_world_log("(SerializeListElem-Skip) Value thing is null.")
#endif
					continue
			else if (ispath(EV) || IS_PROC(EV))
				ET = "PATH"
			else
				// Don't know what this is. Skip it.
#ifdef SAVE_DEBUG
				if(verbose_logging)
					to_world_log("(SerializeListElem-Skip) Unknown Value")
#endif
				continue
		KV = sanitizeSQL("[KV]")
		EV = sanitizeSQL("[EV]")
#ifdef SAVE_DEBUG
		if(verbose_logging)
			to_world_log("(SerializeListElem-Done) ([element_index],[l_i],[I],\"[KV]\",'[KT]',\"[EV]\",\"[ET]\",[version])")
#endif
		element_inserts.Add("([element_index],[l_i],[I],\"[KV]\",'[KT]',\"[EV]\",\"[ET]\",[version])")
		element_index++
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
		if(islist(VV) && !isnull(VV))
			// Complex code for serializing lists...
			if(length(VV) == 0)
				// Another optimization. Don't need to serialize lists
				// that have 0 elements.
#ifdef SAVE_DEBUG
				if(verbose_logging)
					to_world_log("(SerializeThingVar-Skip) Zero Length List")
#endif
				continue
			VT = "LIST"
			VV = SerializeList(VV)
			if(isnull(VV))
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
#ifdef SAVE_DEBUG
				if(verbose_logging)
					to_world_log("(SerializeThingVar-Skip) Null Thing")
#endif
				continue
		else if (ispath(VV) || IS_PROC(VV)) // After /datum check to avoid high-number obj refs
			VT = "PATH"
		else
			// We don't know what this is. Skip it.
#ifdef SAVE_DEBUG
			if(verbose_logging)
				to_world_log("(SerializeThingVar-Skip) Unknown Var")
#endif
			continue
		VV = sanitizeSQL("[VV]")
#ifdef SAVE_DEBUG
		if(verbose_logging)
			to_world_log("(SerializeThingVar-Done) ([var_index],[t_i],'[V]','[VT]',\"[VV]\",[version])")
#endif
		var_inserts.Add("([var_index],[t_i],'[V]','[VT]',\"[VV]\",[version])")
		var_index++
	thing.after_save() // After save hook.
	return t_i

/datum/persistence/serializer/proc/DeserializeThing(var/datum/persistence/load_cache/thing/thing)
#ifdef SAVE_DEBUG
	var/list/deserialized_vars = list()
#endif

	// Checking for existing items.
	var/datum/existing = reverse_map["[thing.id]"]
	if(existing)
		return existing
	// Handlers for specific types would go here.
	if (ispath(thing.thing_type, /turf))
		// turf turf turf
		var/turf/T = locate(thing.x, thing.y, thing.z)
		T.ChangeTurf(thing.thing_type)
		if (!T)
			to_world_log("Attempting to deserialize onto turf [thing.x],[thing.y],[thing.z] failed. Could not locate turf.")
			return
		existing = T
	else
		// default creation
		existing = new thing.thing_type()
	reverse_map["[thing.id]"] = existing
	// Fetch all the variables for the thing.
	for(var/datum/persistence/load_cache/thing_var/TV in thing.thing_vars)
		// Each row is a variable on this object.
#ifdef SAVE_DEBUG
		deserialized_vars.Add("[TV.key]:[TV.var_type]")
#endif
		try
			switch(TV.var_type)
				if("NUM")
					existing.vars[TV.key] = text2num(TV.value)
				if("TEXT")
					existing.vars[TV.key] = TV.value
				if("PATH")
					existing.vars[TV.key] = text2path(TV.value)
				if("NULL")
					existing.vars[TV.key] = null
				if("LIST")
					existing.vars[TV.key] = DeserializeList(TV.value)
				if("OBJ")
					existing.vars[TV.key] = QueryAndDeserializeThing(TV.value)
		catch(var/exception/e)
			to_world_log("Failed to deserialize '[TV.key]' of type '[TV.var_type]' on line [e.line] / file [e.file] for reason: '[e]'.")
#ifdef SAVE_DEBUG
	to_world_log("Deserialized thing of type [thing.thing_type] ([thing.x],[thing.y],[thing.z]) with vars: " + jointext(deserialized_vars, ", "))
#endif
	return existing

/datum/persistence/serializer/proc/QueryAndDeserializeThing(var/thing_id)
	var/datum/existing = reverse_map["[thing_id]"]
	if(!isnull(existing))
		return existing
	return DeserializeThing(resolver.things["[thing_id]"])

/datum/persistence/serializer/proc/DeserializeList(var/list_id, var/list/existing)
	// Will deserialize and return a list.
	if(!dbcon.IsConnected())
		return

	if(isnull(existing))
		existing = reverse_list_map["[list_id]"]
		if(isnull(existing))
			existing = list()
	reverse_list_map["[list_id]"] = existing

	// We gotta resolve the list.
	var/list/raw_list = resolver.lists["[list_id]"]
	for(var/datum/persistence/load_cache/list_element/LE in raw_list)
		var/key_value

		switch(LE.key_type)
			if("NULL")
				key_value = null
			if("TEXT")
				key_value = LE.key
			if("NUM")
				key_value = text2num(LE.key)
			if("PATH")
				key_value = text2path(LE.key)
			if("LIST")
				key_value = DeserializeList(LE.key)
			if("OBJ")
				key_value = QueryAndDeserializeThing(LE.key)

		switch(LE.value_type)
			if("NULL")
				// This is how lists are made. Everything else is a dict.
				existing.Add(key_value)
			if("TEXT")
				existing[key_value] = LE.value
			if("NUM")
				existing[key_value] = text2num(LE.value)
			if("PATH")
				existing[key_value] = text2path(LE.value)
			if("LIST")
				existing[key_value] = DeserializeList(LE.value)
			if("OBJ")
				existing[key_value] = QueryAndDeserializeThing(LE.value)
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
			if(query.ErrorMsg())
				to_world_log("THING SERIALIZATION FAILED: [query.ErrorMsg()].")
		if(length(var_inserts) > 0)
			query = dbcon.NewQuery("INSERT INTO `thing_var`(`id`,`thing_id`,`key`,`type`,`value`,`version`) VALUES[jointext(var_inserts, ",")]")
			query.Execute()
			if(query.ErrorMsg())
				to_world_log("VAR SERIALIZATION FAILED: [query.ErrorMsg()].")
		if(length(list_inserts) > 0)
			query = dbcon.NewQuery("INSERT INTO `list`(`id`,`length`,`version`) VALUES[jointext(list_inserts, ",")]")
			query.Execute()
			if(query.ErrorMsg())
				to_world_log("LIST SERIALIZATION FAILED: [query.ErrorMsg()].")
		if(length(element_inserts) > 0)
			query = dbcon.NewQuery("INSERT INTO `list_element`(`id`,`list_id`,`index`,`key`,`key_type`,`value`,`value_type`,`version`) VALUES[jointext(element_inserts, ",")]")
			query.Execute()
			if(query.ErrorMsg())
				to_world_log("ELEMENT SERIALIZATION FAILED: [query.ErrorMsg()].")
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