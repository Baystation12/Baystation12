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
	gvars_datum_in_built_vars = exclude_these.vars + list("gvars_datum_protected_varlist", "gvars_datum_in_built_vars", "gvars_datum_init_order") + "vars"
	qdel(exclude_these)

	log_world("[vars.len - gvars_datum_in_built_vars.len] global variables")

	try
		Initialize()
	catch(var/exception/e)
		to_world_log("Built-in vars which should not be initialized:\n[jointext(gvars_datum_in_built_vars, "\n")]")
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
		var/CLEANBOT_RETURNS = "[I]"
		pass(CLEANBOT_RETURNS)

	for(var/I in (vars - gvars_datum_in_built_vars))
		var/start_tick = world.time
		call(src, "InitGlobal[I]")()
		var/end_tick = world.time
		if(end_tick - start_tick)
			warning("Global [I] slept during initialization!")
