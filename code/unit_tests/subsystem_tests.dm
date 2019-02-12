/datum/unit_test/subsystem_atom_shall_have_no_bad_init_calls
	name = "SUBSYSTEM - ATOMS: Shall have no bad init calls"

/datum/unit_test/subsystem_atom_shall_have_no_bad_init_calls/start_test()
	if(SSatoms.BadInitializeCalls.len)
		log_bad(jointext(SSatoms.InitLog(), null))
		fail("[SSatoms] had bad initialization calls.")
	else
		pass("[SSatoms] had no bad initialization calls.")
	return 1

/datum/unit_test/subsystem_shall_be_initialized
	name = "SUBSYSTEM - INIT: Subsystems shall be initalized"

/datum/unit_test/subsystem_shall_be_initialized/start_test()
	var/list/bad_subsystems = list()
	for(var/datum/controller/subsystem/SS in Master.subsystems)
		if (SS.flags & SS_NO_INIT)
			continue
		if(!SS.initialized)
			bad_subsystems += SS.type

	if(bad_subsystems.len)
		fail("Found improperly initialized subsystems: [english_list(bad_subsystems)]")
	else
		pass("All susbsystems have initialized properly")

	return 1

/datum/unit_test/all_atoms_shall_be_initialized
	name = "SUBSYSTEM - ATOMS: All atoms shall be initialized."

/datum/unit_test/all_atoms_shall_be_initialized/start_test()
	set background = TRUE // avoid infinite loop warning; SS will still wait for us.
	var/fail = FALSE
	for(var/atom/atom in world)
		if(!(atom.atom_flags & ATOM_FLAG_INITIALIZED))
			log_bad("Uninitialized atom: [log_info_line(atom)]")
			fail = TRUE
	if(fail)
		fail("There were uninitialized atoms.")
	else
		pass("All atoms were initialized")
	return 1
