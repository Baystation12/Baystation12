#define BAD_INIT_QDEL_BEFORE 1
#define BAD_INIT_DIDNT_INIT 2
#define BAD_INIT_SLEPT 4
#define BAD_INIT_NO_HINT 8


SUBSYSTEM_DEF(atoms)
	name = "Atoms"
	init_order = SS_INIT_ATOMS
	flags = SS_NO_FIRE | SS_NEEDS_SHUTDOWN

	var/static/tmp/atom_init_stage = INITIALIZATION_INSSATOMS
	var/static/tmp/old_init_stage
	var/static/tmp/list/late_loaders = list()
	var/static/tmp/list/created_atoms = list()
	var/static/tmp/list/BadInitializeCalls = list()


/datum/controller/subsystem/atoms/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..("Bad Inits: [BadInitializeCalls.len]")


/datum/controller/subsystem/atoms/Shutdown()
	var/initlog = InitLog()
	if (initlog)
		text2file(initlog, "[GLOB.log_directory]/initialize.log")


/datum/controller/subsystem/atoms/Initialize(start_uptime)
	atom_init_stage = INITIALIZATION_INNEW_MAPLOAD
	InitializeAtoms()


/datum/controller/subsystem/atoms/Recover()
	created_atoms.Cut()
	late_loaders.Cut()
	if (atom_init_stage == INITIALIZATION_INNEW_MAPLOAD)
		InitializeAtoms()


/datum/controller/subsystem/atoms/proc/InitializeAtoms()
	if (atom_init_stage <= INITIALIZATION_INSSATOMS_LATE)
		return
	atom_init_stage = INITIALIZATION_INNEW_MAPLOAD
	var/list/mapload_arg = list(TRUE)
	var/count = created_atoms.len
	var/atom/created
	var/list/arguments
	for (var/i = created_atoms.len to 1 step -1)
		created = created_atoms[i]
		if (!(created.atom_flags & ATOM_FLAG_INITIALIZED))
			arguments = created_atoms[created] ? mapload_arg + created_atoms[created] : mapload_arg
			InitAtom(created, arguments)
			CHECK_TICK
	created_atoms.Cut()
	if (!initialized)
		for (var/atom/A in world)
			if (!(A.atom_flags & ATOM_FLAG_INITIALIZED))
				InitAtom(A, mapload_arg)
				++count
				CHECK_TICK
	report_progress("Initialized [count] atom\s")
	atom_init_stage = INITIALIZATION_INNEW_REGULAR
	if (!late_loaders.len)
		return
	for (var/atom/A as anything in late_loaders)
		A.LateInitialize(arglist(late_loaders[A]))
	report_progress("Late initialized [late_loaders.len] atom\s")
	late_loaders.Cut()


/datum/controller/subsystem/atoms/proc/InitAtom(atom/A, list/arguments)
	var/atom_type = A?.type
	if (QDELING(A))
		BadInitializeCalls[atom_type] |= BAD_INIT_QDEL_BEFORE
		return TRUE
	var/start_tick = world.time
	var/result = A.Initialize(arglist(arguments))
	if(start_tick != world.time)
		BadInitializeCalls[atom_type] |= BAD_INIT_SLEPT
	var/qdeleted = FALSE
	if (result != INITIALIZE_HINT_NORMAL)
		switch(result)
			if (INITIALIZE_HINT_LATELOAD)
				if (arguments[1])	//mapload
					late_loaders[A] = arguments
				else
					A.LateInitialize(arglist(arguments))
			if (INITIALIZE_HINT_QDEL)
				qdel(A)
				qdeleted = TRUE
			else
				BadInitializeCalls[atom_type] |= BAD_INIT_NO_HINT
	if (!A)	//possible harddel
		qdeleted = TRUE
	else if (!(A.atom_flags & ATOM_FLAG_INITIALIZED))
		BadInitializeCalls[atom_type] |= BAD_INIT_DIDNT_INIT
	return qdeleted || QDELING(A)


/datum/controller/subsystem/atoms/proc/map_loader_begin()
	old_init_stage = atom_init_stage
	atom_init_stage = INITIALIZATION_INSSATOMS_LATE


/datum/controller/subsystem/atoms/proc/map_loader_stop()
	atom_init_stage = old_init_stage


/datum/controller/subsystem/atoms/proc/InitLog()
	. = ""
	for (var/path in BadInitializeCalls)
		. += "Path : [path] \n"
		var/fails = BadInitializeCalls[path]
		if (fails & BAD_INIT_DIDNT_INIT)
			. += "- Didn't call atom/Initialize()\n"
		if (fails & BAD_INIT_NO_HINT)
			. += "- Didn't return an Initialize hint\n"
		if (fails & BAD_INIT_QDEL_BEFORE)
			. += "- Qdel'd in New()\n"
		if (fails & BAD_INIT_SLEPT)
			. += "- Slept during Initialize()\n"


#undef BAD_INIT_QDEL_BEFORE
#undef BAD_INIT_DIDNT_INIT
#undef BAD_INIT_SLEPT
#undef BAD_INIT_NO_HINT
