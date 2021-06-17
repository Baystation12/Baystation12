GLOBAL_REAL(GLOB, /datum/controller/global_vars)

/datum/controller/global_vars
	name = "Global Variables"

	var/list/gvars_datum_protected_varlist
	var/list/gvars_datum_in_built_vars
	var/list/gvars_datum_init_order

/datum/controller/global_vars/New()
	if(GLOB)
		CRASH("Multiple instances of global variable controller created")
	GLOB = src

	var/datum/controller/exclude_these = new
	gvars_datum_in_built_vars = exclude_these.vars + list("gvars_datum_protected_varlist", "gvars_datum_in_built_vars", "gvars_datum_init_order")
	qdel(exclude_these)

	var/global_vars = vars.len - gvars_datum_in_built_vars.len
	var/global_procs = length(typesof(/datum/controller/global_vars/proc))

	report_progress("[global_vars] global variables")
	report_progress("[global_procs] global init procs")

	try
		if(global_vars == global_procs)
			Initialize()
		else
			crash_with("Expected [global_vars] global init procs, were [global_procs].")
	catch(var/exception/e)
		to_world_log("Vars to be initialized: [json_encode((vars - gvars_datum_in_built_vars))]")
		to_world_log("Procs used to initialize: [json_encode(typesof(/datum/controller/global_vars/proc))]")
		throw e


/datum/controller/global_vars/Destroy(force)
	crash_with("There was an attempt to qdel the global vars holder!")
	if(!force)
		return QDEL_HINT_LETMELIVE

	QDEL_NULL(statclick)
	gvars_datum_protected_varlist.Cut()
	gvars_datum_in_built_vars.Cut()

	GLOB = null

	return ..()

/datum/controller/global_vars/stat_entry()
	if(!statclick)
		statclick = new/obj/effect/statclick/debug(null, "Initializing...", src)

	stat("Globals:", statclick.update("Edit"))

/datum/controller/global_vars/VV_hidden()
	return ..() + gvars_datum_protected_varlist

/datum/controller/global_vars/Initialize()
	gvars_datum_init_order = list()
	gvars_datum_protected_varlist = list("gvars_datum_protected_varlist")

	//See https://github.com/tgstation/tgstation/issues/26954
	for(var/I in typesof(/datum/controller/global_vars/proc))
		var/start_tick = world.time
		call(src, I)()
		if(world.time - start_tick)
			warning("[I] slept during initialization!")
