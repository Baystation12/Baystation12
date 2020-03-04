#define SAVECHUNK_SIZEX 16
#define SAVECHUNK_SIZEY 16

/datum/persistence
	var/version = 1

/datum/persistence/serializer
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
		var/EV = _list[key]
		element_index += 1

		if(isnum(EV))
			ET = 'NUM'
		else if (istext(EV))
			ET = 'TEXT'
		else if (islist(EV))
			ET = 'LIST'
			EV = SerializeList(EV)
		else if (isnull(EV))
			ET = 'NULL'
		else
			ET = 'OBJ'
			EV = SerializeThing(EV)
		LAZY_ADD(element_inserts, "([e_i],[l_i],[I],\"[key]\",'[ET]','[EV]',[version])")
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

	LAZYADD(thing_inserts, "([t_i],'[thing.type]',[version])")
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

/datum/persistence/serializer/Commit()
	var/thing_query = "INSERT INTO `thing`(`id`,`type`,`version`) VALUES" + jointext(thing_inserts, ",")
	var/var_query = "INSERT INTO `thing_var`(`id`,`thing_id`,`key`,`type`,`value`,`version`) VALUES" + jointext(var_inserts, ",")
	var/list_query = "INSERT INTO `list`(`id`,`length`,`version`) VALUES" + jointext(list_inserts, ",")
	var/element_query = "INSERT INTO `list_element`(`id`,`list_id`,`index`,`key`,`type`,`value`,`version`) VALUES" + jointext(element_inserts, ",")

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


/datum/persistence/world_handle/Load(var/thing_id)
	

/datum/persistence/world_handle/LoadChunk(var/x, var/y, var/z)

#undef SAVECHUNK_SIZEX
#undef SAVECHUNK_SIZEY