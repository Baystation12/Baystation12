/proc/create_objects_in_loc(var/atom/loc, var/atom_paths)
	if(!istype(loc))
		CRASH("Inappropriate loction given.")

	if(istype(atom_paths, /datum/atom_creator))
		var/datum/atom_creator/atom_creator = atom_paths
		atom_creator.create(loc)
	else if(islist(atom_paths))
		for(var/atom_path in atom_paths)
			for(var/i = 1 to max(1, atom_paths[atom_path]))
				create_objects_in_loc(loc, atom_path)
	else if(ispath(atom_paths))
		new atom_paths(loc)
	else
		CRASH("Unhandled input: [log_info_line(atom_paths)]")

// Gets the object with largest w_class from a list of paths. Used during unit testing.
/proc/get_largest(var/list/paths)
	var/obj/largest
	var/largest_path
	for(var/path in paths)
		if(!islist(path))
			var/cur_path = path
			// Recursive search for random spawner objects
			if(ispath(path, /obj/random))
				var/obj/random/R = new path()
				cur_path = get_largest(R.spawn_choices())
			var/obj/AM = new cur_path()
			if(!istype(AM))
				continue
			if(!largest || (largest.w_class < AM.w_class))
				largest = AM
				largest_path = path
	return largest_path

/datum/atom_creator/proc/create(var/loc)
	return

/datum/atom_creator/simple
	var/path
	var/probability // prob is a reserved keyword and won't compile

/datum/atom_creator/simple/New(var/path, var/probability)
	..()
	if(!isnum(probability) || probability < 1 || probability > 99)
		CRASH("The given probability must be between 1 and 99") // A probability of 0 or 100 is pretty meaningless.
#ifdef UNIT_TEST // Force 100% probability during unit testing - needed for container overflow tests
	src.probability = 100
#else
	src.probability = probability
#endif
	src.path = path

/datum/atom_creator/simple/create(var/loc)
	if(prob(probability))
		create_objects_in_loc(loc, path)

/datum/atom_creator/weighted
	var/list/paths

/datum/atom_creator/weighted/New(var/paths)
	..()
	src.paths = paths

/datum/atom_creator/weighted/create(var/loc)
#ifdef UNIT_TEST
	var/path = get_largest(paths)
	if(path == null)
		path = pickweight(paths)
#else
	var/path = pickweight(paths)
#endif
	create_objects_in_loc(loc, path)
