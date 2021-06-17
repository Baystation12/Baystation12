///////////////////////////////////////////////////////////////
//SS13 Optimized Map loader
//////////////////////////////////////////////////////////////

//global datum that will preload variables on atoms instanciation
GLOBAL_VAR_INIT(use_preloader, FALSE)
GLOBAL_DATUM_INIT(_preloader, /dmm_suite/preloader, new)

/datum/map_load_metadata
	var/bounds
	var/list/atoms_to_initialise

/dmm_suite
		// /"([a-zA-Z]+)" = \(((?:.|\n)*?)\)\n(?!\t)|\((\d+),(\d+),(\d+)\) = \{"([a-zA-Z\n]*)"\}/g
	var/static/regex/dmmRegex = new/regex({""(\[a-zA-Z]+)" = \\(((?:.|\n)*?)\\)\n(?!\t)|\\((\\d+),(\\d+),(\\d+)\\) = \\{"(\[a-zA-Z\n]*)"\\}"}, "g")
		// /^[\s\n]+"?|"?[\s\n]+$|^"|"$/g
	var/static/regex/trimQuotesRegex = new/regex({"^\[\\s\n]+"?|"?\[\\s\n]+$|^"|"$"}, "g")
		// /^[\s\n]+|[\s\n]+$/
	var/static/regex/trimRegex = new/regex("^\[\\s\n]+|\[\\s\n]+$", "g")
	var/static/list/modelCache = list()
	var/static/space_key
	#ifdef TESTING
	var/static/turfsSkipped
	#endif

/**
 * Construct the model map and control the loading process
 *
 * WORKING :
 *
 * 1) Makes an associative mapping of model_keys with model
 *		e.g aa = /turf/unsimulated/wall{icon_state = "rock"}
 * 2) Read the map line by line, parsing the result (using parse_grid)
 *
 */
/dmm_suite/load_map(var/dmm_file, var/x_offset, var/y_offset, var/z_offset, var/cropMap, var/measureOnly, var/no_changeturf, var/clear_contents, var/lower_crop_x, var/lower_crop_y, var/upper_crop_x, var/upper_crop_y, var/initialized_areas_by_type)
	//How I wish for RAII
	Master.StartLoadingMap()
	space_key = null
	#ifdef TESTING
	turfsSkipped = 0
	#endif
	initialized_areas_by_type = initialized_areas_by_type || list()
	if(!(world.area in initialized_areas_by_type))
		initialized_areas_by_type[world.area] = locate(world.area)
	. = load_map_impl(dmm_file, x_offset, y_offset, z_offset, cropMap, measureOnly, no_changeturf, clear_contents, lower_crop_x, upper_crop_x, lower_crop_y, upper_crop_y, initialized_areas_by_type)
	#ifdef TESTING
	if(turfsSkipped)
		testing("Skipped loading [turfsSkipped] default turfs")
	#endif
	Master.StopLoadingMap()

/dmm_suite/proc/load_map_impl(dmm_file, x_offset, y_offset, z_offset, cropMap, measureOnly, no_changeturf, clear_contents, x_lower = -INFINITY, x_upper = INFINITY, y_lower = -INFINITY, y_upper = INFINITY, initialized_areas_by_type)
	var/tfile = dmm_file//the map file we're creating
	if(isfile(tfile))
		tfile = file2text(tfile)

	if(!x_offset)
		x_offset = 1
	if(!y_offset)
		y_offset = 1
	if(!z_offset)
		z_offset = world.maxz + 1

	var/list/bounds = list(1.#INF, 1.#INF, 1.#INF, -1.#INF, -1.#INF, -1.#INF)
	var/list/grid_models = list()
	var/key_len = 0

	var/stored_index = 1

	var/list/atoms_to_initialise = list()
	var/list/atoms_to_delete = list()

	while(regex_find(dmmRegex, tfile, stored_index))
		stored_index = dmmRegex.next

		// "aa" = (/type{vars=blah})
		if(dmmRegex.group[1]) // Model
			var/key = dmmRegex.group[1]
			if(grid_models[key]) // Duplicate model keys are ignored in DMMs
				continue
			if(key_len != length(key))
				if(!key_len)
					key_len = length(key)
				else
					throw EXCEPTION("Inconsistant key length in DMM")
			if(!measureOnly)
				grid_models[key] = dmmRegex.group[2]

		// (1,1,1) = {"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"}
		else if(dmmRegex.group[3]) // Coords
			if(!key_len)
				throw EXCEPTION("Coords before model definition in DMM")

			var/curr_x = text2num(dmmRegex.group[3])

			if(curr_x < x_lower || curr_x > x_upper)
				continue

			var/xcrdStart = curr_x + x_offset - 1
			//position of the currently processed square
			var/xcrd
			var/ycrd = text2num(dmmRegex.group[4]) + y_offset - 1
			var/zcrd = text2num(dmmRegex.group[5]) + z_offset - 1

			var/is_connected_to_lower_levels = AreConnectedZLevels(zcrd, z_offset)
			var/is_on_an_existing_zlevel = zcrd <= world.maxz

			if (is_on_an_existing_zlevel && !is_connected_to_lower_levels)
				continue

			var/zexpansion = zcrd > world.maxz
			if(zexpansion && !measureOnly) // don't actually expand the world if we're only measuring bounds
				if(cropMap)
					continue
				else
					world.maxz = zcrd //create a new z_level if needed
				if(!no_changeturf)
					WARNING("Z-level expansion occurred without no_changeturf set, this may cause problems when /turf/post_change is called.")

			bounds[MAP_MINX] = min(bounds[MAP_MINX], Clamp(xcrdStart, x_lower, x_upper))
			bounds[MAP_MINZ] = min(bounds[MAP_MINZ], zcrd)
			bounds[MAP_MAXZ] = max(bounds[MAP_MAXZ], zcrd)

			var/list/gridLines = splittext(dmmRegex.group[6], "\n")

			var/leadingBlanks = 0
			while(leadingBlanks < gridLines.len && gridLines[++leadingBlanks] == "")
			if(leadingBlanks > 1)
				gridLines.Cut(1, leadingBlanks) // Remove all leading blank lines.

			if(!gridLines.len) // Skip it if only blank lines exist.
				continue

			if(gridLines.len && gridLines[gridLines.len] == "")
				gridLines.Cut(gridLines.len) // Remove only one blank line at the end.

			bounds[MAP_MINY] = min(bounds[MAP_MINY], Clamp(ycrd, y_lower, y_upper))
			ycrd += gridLines.len - 1 // Start at the top and work down

			if(!cropMap && ycrd > world.maxy)
				if(!measureOnly)
					world.maxy = ycrd // Expand Y here.  X is expanded in the loop below
				bounds[MAP_MAXY] = max(bounds[MAP_MAXY], Clamp(ycrd, y_lower, y_upper))
			else
				bounds[MAP_MAXY] = max(bounds[MAP_MAXY], Clamp(min(ycrd, world.maxy), y_lower, y_upper))

			var/maxx = xcrdStart
			if(measureOnly)
				for(var/line in gridLines)
					maxx = max(maxx, xcrdStart + length(line) / key_len - 1)
			else
				for(var/line in gridLines)
					if((ycrd - y_offset + 1) < y_lower || (ycrd - y_offset + 1) > y_upper)				//Reverse operation and check if it is out of bounds of cropping.
						--ycrd
						continue
					if(ycrd <= world.maxy && ycrd >= 1)
						xcrd = xcrdStart
						for(var/tpos = 1 to length(line) - key_len + 1 step key_len)
							if((xcrd - x_offset + 1) < x_lower || (xcrd - x_offset + 1) > x_upper)			//Same as above.
								++xcrd
								continue								//X cropping.
							if(xcrd > world.maxx)
								if(cropMap)
									break
								else
									world.maxx = xcrd

							if(xcrd >= 1)
								var/model_key = copytext(line, tpos, tpos + key_len)
								var/no_afterchange = no_changeturf || zexpansion
								if(!no_afterchange || (model_key != space_key))
									if(!grid_models[model_key])
										throw EXCEPTION("Undefined model key in DMM.")
									var/datum/grid_load_metadata/M = parse_grid(grid_models[model_key], model_key, xcrd, ycrd, zcrd, no_changeturf || zexpansion, clear_contents, initialized_areas_by_type)
									if (M)
										atoms_to_initialise += M.atoms_to_initialise
										atoms_to_delete += M.atoms_to_delete
								#ifdef TESTING
								else
									++turfsSkipped
								#endif
								CHECK_TICK
							maxx = max(maxx, xcrd)
							++xcrd
					--ycrd
				if (zexpansion)
					create_lighting_overlays_zlevel(zcrd)

			bounds[MAP_MAXX] = Clamp(max(bounds[MAP_MAXX], cropMap ? min(maxx, world.maxx) : maxx), x_lower, x_upper)

		CHECK_TICK

	if(bounds[1] == 1.#INF) // Shouldn't need to check every item
		return null
	else
		if(!measureOnly)
			if(clear_contents)
				for(var/atom/to_delete in atoms_to_delete)
					qdel(to_delete)
		var/datum/map_load_metadata/M = new
		M.bounds = bounds
		M.atoms_to_initialise = atoms_to_initialise
		return M

/**
 * Fill a given tile with its area/turf/objects/mobs
 * Variable model is one full map line (e.g /turf/unsimulated/wall{icon_state = "rock"}, /area/mine/explored)
 *
 * WORKING :
 *
 * 1) Read the model string, member by member (delimiter is ',')
 *
 * 2) Get the path of the atom and store it into a list
 *
 * 3) a) Check if the member has variables (text within '{' and '}')
 *
 * 3) b) Construct an associative list with found variables, if any (the atom index in members is the same as its variables in members_attributes)
 *
 * 4) Instanciates the atom with its variables
 *
 */

/datum/grid_load_metadata
	var/list/atoms_to_initialise
	var/list/atoms_to_delete

/dmm_suite/proc/types_to_delete()
	return list(
		/mob/living,
		/obj/effect,
		/obj/item,
		/obj/machinery,
		/obj/structure,
	)

/dmm_suite/proc/parse_grid(model as text, model_key as text, xcrd as num,ycrd as num,zcrd as num, no_changeturf as num, clear_contents as num, initialized_areas_by_type)
	/*Method parse_grid()
	- Accepts a text string containing a comma separated list of type paths of the
		same construction as those contained in a .dmm file, and instantiates them.
	*/

	var/list/members //will contain all members (paths) in model (in our example : /turf/unsimulated/wall and /area/mine/explored)
	var/list/members_attributes //will contain lists filled with corresponding variables, if any (in our example : list(icon_state = "rock") and list())
	var/list/cached = modelCache[model]
	var/index

	if(cached)
		members = cached[1]
		members_attributes = cached[2]
	else
		/////////////////////////////////////////////////////////
		//Constructing members and corresponding variables lists
		////////////////////////////////////////////////////////

		members = list()
		members_attributes = list()
		index = 1

		var/old_position = 1
		var/dpos

		do
			//finding next member (e.g /turf/unsimulated/wall{icon_state = "rock"} or /area/mine/explored)
			dpos = find_next_delimiter_position(model, old_position, ",", "{", "}") //find next delimiter (comma here) that's not within {...}

			var/full_def = trim_text(copytext(model, old_position, dpos)) //full definition, e.g : /obj/foo/bar{variables=derp}
			var/variables_start = findtext(full_def, "{")
			var/atom_def = text2path(trim_text(copytext(full_def, 1, variables_start))) //path definition, e.g /obj/foo/bar
			old_position = dpos + 1

			if(!atom_def) // Skip the item if the path does not exist.  Fix your crap, mappers!
	#ifdef UNIT_TEST
				log_error("Couldn't find atom path specified in map: [full_def]")
	#endif
				if (dpos == 0)
					break
				else
					continue

			members += atom_def

			//transform the variables in text format into a list (e.g {var1="derp"; var2; var3=7} => list(var1="derp", var2, var3=7))
			var/list/fields

			if(variables_start)//if there's any variable
				full_def = copytext(full_def,variables_start+1,length(full_def))//removing the last '}'
				fields = readlist(full_def, ";")
				if(fields.len)
					if(!trim(fields[fields.len]))
						--fields.len
					for(var/I in fields)
						var/value = fields[I]
						if(istext(value))
							fields[I] = apply_text_macros(value)

			//then fill the members_attributes list with the corresponding variables
			members_attributes.len++
			members_attributes[index++] = fields

			CHECK_TICK
		while(dpos != 0)

		//check and see if we can just skip this turf
		//So you don't have to understand this horrid statement, we can do this if
		// 1. no_changeturf is set
		// 2. the space_key isn't set yet
		// 3. there are exactly 2 members
		// 4. with no attributes
		// 5. and the members are world.turf and world.area
		// Basically, if we find an entry like this: "XXX" = (/turf/default, /area/default)
		// We can skip calling this proc every time we see XXX
		if(no_changeturf && !space_key && members.len == 2 && members_attributes.len == 2 && length(members_attributes[1]) == 0 && length(members_attributes[2]) == 0 && (world.area in members) && (world.turf in members))
			space_key = model_key
			return

		modelCache[model] = list(members, members_attributes)

	////////////////
	//Instanciation
	////////////////

	//The next part of the code assumes there's ALWAYS an /area AND a /turf on a given tile
	var/turf/crds = locate(xcrd,ycrd,zcrd)

	var/is_not_noop = FALSE
	var/atoms_to_delete = list()

	//first instance the /area and remove it from the members list
	index = members.len
	if(members[index] != /area/template_noop)
		is_not_noop = TRUE
		var/list/attr = members_attributes[index]
		if (LAZYLEN(attr))
			GLOB._preloader.setup(attr)//preloader for assigning  set variables on atom creation
		var/atype = members[index]
		var/atom/instance = initialized_areas_by_type[atype]
		if(!instance)
			instance = new atype(null)
			initialized_areas_by_type[atype] = instance
		if(crds)
			instance.contents.Add(crds)

		if(GLOB.use_preloader && instance)
			GLOB._preloader.load(instance)

	//then instance the /turf and, if multiple tiles are presents, simulates the DMM underlays piling effect

	var/first_turf_index = 1
	while(!ispath(members[first_turf_index], /turf)) //find first /turf object in members
		first_turf_index++

	//turn off base new Initialization until the whole thing is loaded
	SSatoms.map_loader_begin()
	//since we've switched off autoinitialisation, record atoms to initialise later
	var/list/atoms_to_initialise = list()

	//instanciate the first /turf
	var/turf/T
	if(members[first_turf_index] != /turf/template_noop)
		is_not_noop = TRUE
		T = instance_atom(members[first_turf_index],members_attributes[first_turf_index],crds,no_changeturf)
		atoms_to_initialise += T

	if(T)
		//if others /turf are presents, simulates the underlays piling effect
		index = first_turf_index + 1
		while(index <= members.len - 1) // Last item is an /area
			var/underlay = T.appearance
			T = instance_atom(members[index],members_attributes[index],crds,no_changeturf)//instance new turf
			T.underlays += underlay
			index++
			atoms_to_initialise += T

	if (clear_contents && is_not_noop)
		for (var/type_to_delete in types_to_delete())
			for (var/atom/pre_existing in crds)
				if (istype(pre_existing, type_to_delete))
					atoms_to_delete |= pre_existing

	//finally instance all remainings objects/mobs
	for(index in 1 to first_turf_index-1)
		atoms_to_initialise += instance_atom(members[index],members_attributes[index],crds,no_changeturf)
	//Restore initialization to the previous valsue
	SSatoms.map_loader_stop()

	var/datum/grid_load_metadata/M = new
	M.atoms_to_initialise = atoms_to_initialise
	M.atoms_to_delete = atoms_to_delete
	return M

////////////////
//Helpers procs
////////////////

//Instance an atom at (x,y,z) and gives it the variables in attributes
/dmm_suite/proc/instance_atom(path,list/attributes, turf/crds, no_changeturf)
	if (LAZYLEN(attributes))
		GLOB._preloader.setup(attributes, path)

	if(crds)
		if(!no_changeturf && ispath(path, /turf))
			. = crds.ChangeTurf(path, FALSE, TRUE)
		else
			. = create_atom(path, crds)//first preloader pass

	if(GLOB.use_preloader && .)//second preloader pass, for those atoms that don't ..() in New()
		GLOB._preloader.load(.)

	//custom CHECK_TICK here because we don't want things created while we're sleeping to delay initialization.
	if(TICK_CHECK)
		SSatoms.map_loader_stop()
		stoplag()
		SSatoms.map_loader_begin()

/dmm_suite/proc/create_atom(path, crds)
	// Doing this async is impossible, as we must return the ref.
	return new path (crds)

//text trimming (both directions) helper proc
//optionally removes quotes before and after the text (for variable name)
/dmm_suite/proc/trim_text(text, trim_quotes)
	return replacetext_char(text, trim_quotes ? trimQuotesRegex : trimRegex, "")

//find the position of the next delimiter,skipping whatever is comprised between opening_escape and closing_escape
//returns 0 if reached the last delimiter
/dmm_suite/proc/find_next_delimiter_position(text as text,initial_position as num, delimiter=",",opening_escape="\"",closing_escape="\"")
	var/position = initial_position
	var/next_delimiter = findtext(text,delimiter,position,0)
	var/next_opening = findtext(text,opening_escape,position,0)

	while((next_opening != 0) && (next_opening < next_delimiter))
		position = findtext(text,closing_escape,next_opening + 1,0)+1
		next_delimiter = findtext(text,delimiter,position,0)
		next_opening = findtext(text,opening_escape,position,0)

	return next_delimiter

/dmm_suite/proc/readlistitem(text as text)
	//Check for string
	if(findtext(text,"\"",1,2))
		. = copytext(text,2,findtext(text,"\"",3,0))

	//Check for number
	else if(isnum(text2num(text)) && text == "[text2num(text)]") //text2num will parse truthy false positives; this demands that the only numbers parsed as such are properly formatted ones.
		. = text2num(text)

	//Check for null
	else if(text == "null")
		. = null

	//Check for list
	else if(copytext(text,1,5) == "list")
		. = readlist(copytext(text,6,length(text)))

	//Check for file
	else if(copytext(text,1,2) == "'")
		. = file(copytext(text,2,length(text)))

	//Check for path
	else if(ispath(text2path(text)))
		. = text2path(text)

//build a list from variables in text form (e.g {var1="derp"; var2; var3=7} => list(var1="derp", var2, var3=7))
//return the filled list
/dmm_suite/proc/readlist(text as text, delimiter=",")
	var/list/to_return = list()

	var/position
	var/old_position = 1

	do
		//find next delimiter that is not within  "..."
		position = find_next_delimiter_position(text,old_position,delimiter)

		//check if this is a simple variable (as in list(var1, var2)) or an associative one (as in list(var1="foo",var2=7))
		var/equal_position = findtext(text,"=",old_position, position)

		var/trim_left = trim_text(copytext(text,old_position,(equal_position ? equal_position : position)), 0)
		old_position = position + 1

		if(!length(trim_left))
			if(position == 0)
				break // That terminal commas are ignored is real dm behavior.
			to_return.len++
			continue

		var/left = readlistitem(trim_left)
		if(equal_position)
			if(!left && trim_left != "null")
				left = trim_left // This is dm behavior: unindentifiable keys in associative lists are parsed as literal strings.
			if(left == 1.#INF || left == -1.#INF)
				left = trim_left // This is not valid as a list index; we could let it runtime, but if associative it should be parsed as "inf" or "-inf" instead.
		to_return += left

		if(equal_position)//associative var, so do the association
			if(isnum(left))
				crash_with("Numerical key in associative list.")
				break // This is invalid; apparently dm will runtime in this situation.
			var/trim_right = trim_text(copytext(text,equal_position+1,position))//the content of the variable
			to_return[left] = readlistitem(trim_right)

	while(position != 0)

	return to_return

/dmm_suite/Destroy()
	..()
	return QDEL_HINT_HARDDEL_NOW

//////////////////
//Preloader datum
//////////////////

/dmm_suite/preloader
	parent_type = /datum
	var/list/attributes
	var/target_path

/dmm_suite/preloader/proc/setup(list/the_attributes, path)
	if(LAZYLEN(the_attributes))
		GLOB.use_preloader = TRUE
		attributes = the_attributes
		target_path = path

/dmm_suite/preloader/proc/load(atom/what)
	for(var/attribute in attributes)
		var/value = attributes[attribute]
		if(islist(value))
			value = deepCopyList(value)
		try
			what.vars[attribute] = value
		catch (var/ex)
			var/found = FALSE
			for (var/V in what.vars)
				if (deep_string_equals(V, attribute))
					what.vars[V] = value
					log_debug("Successfully performed manual var detection for var [V] \ref[V] on provided attribute [attribute] \ref[attribute] for atom [what]")
					found = TRUE
					break
			if (!found)
				throw ex
	GLOB.use_preloader = FALSE

/area/template_noop
	name = "Area Passthrough"
	icon_state = "unknown"

/turf/template_noop
	name = "Turf Passthrough"
	icon_state = "noop"