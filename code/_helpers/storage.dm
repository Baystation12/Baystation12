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

/datum/atom_creator/proc/create(var/loc)
	return

/datum/atom_creator/simple
	var/path
	var/probability
	var/prob_method = /proc/prob_call

/datum/atom_creator/simple/New(var/path, var/probability)
	if(args.len != 2)
		CRASH("Invalid number of arguments. Expected 2, was [args.len]")
	if(!isnum(probability) || probability < 1 || probability > 99)
		CRASH("Invalid probability. Expected a number between 1 and 99, was [log_info_line(probability)]") // A probability of 0 or 100 is pretty meaningless.
	src.probability = probability
	src.path = path

/datum/atom_creator/simple/create(var/loc)
	if(call(prob_method)(probability))
		create_objects_in_loc(loc, path)

/datum/atom_creator/weighted
	var/list/paths
	var/selection_method = /proc/pickweight

/datum/atom_creator/weighted/New(var/list/paths)
	if(args.len != 1)
		CRASH("Invalid number of arguments. Expected 1, was [args.len]")
	if(!istype(paths))
		CRASH("Invalid argument type. Expected /list, was [log_info_line(paths)]")
	for(var/path in paths)
		var/probability = paths[path]
		if(!(isnull(probability) || (isnum(probability) && probability > 0)))
			CRASH("Invalid probability. Expected null or a number greater than 0, was [log_info_line(probability)]")
	src.paths = paths

/datum/atom_creator/weighted/create(var/loc)
	var/path = call(selection_method)(paths)
	create_objects_in_loc(loc, path)
