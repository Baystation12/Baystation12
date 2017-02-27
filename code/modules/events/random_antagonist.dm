// The random spawn proc on the antag datum will handle announcing the spawn and whatnot.
/datum/event/random_antag/announce()
	return

/datum/event/random_antag/start()
	var/list/valid_types = list()
	
	var/list/all_antag_types = all_antag_types()
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		if(antag.flags & ANTAG_RANDSPAWN)
			valid_types |= antag
	if(valid_types.len)
		var/datum/antagonist/antag = pick(valid_types)
		antag.attempt_random_spawn()
