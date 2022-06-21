/* *
* Managed Globals
*/

var/global/datum/globals/GLOB


/datum/globals
	var/static/atom/movable/clickable_stat/__stat_line


/datum/globals/Destroy(force)
	if (!GLOB || GLOB == src)
		GLOB = src
		return 1 //QDEL_HINT_LETMELIVE
	return ..()


/datum/globals/New()
	var/static/initialized
	if (initialized)
		return
	initialized = TRUE
	var/start = world.time
	for (var/init in typesof(/datum/globals/proc))
		if (copytext("[init]", 21, 24) != "GI_")
			continue
		call(src, init)()
		if (world.time != start)
			warning("[init] slept!")


/datum/globals/proc/UpdateStat()
	if (!__stat_line)
		__stat_line = new (null, src)
		__stat_line.name = "Edit"
	stat("Managed Globals", __stat_line)


/datum/globals/VV_hidden(add_var_name)
	var/static/list/result
	if (!result)
		var/datum/temp = new
		result = temp.vars + list(
			"__stat_line"
		)
	if (istext(add_var_name))
		result += add_var_name
		return
	return result.Copy()


/// Initializes the GLOB member to V.
#define GLOBAL_INIT(X, V) \
/datum/globals/proc/GI_I_##X() { \
	var/static/done; \
	if (done) { \
		log_debug("GLOB.GI_I_[#X] ran >1 time"); \
		return; \
	} \
	done = TRUE; \
	##X = V; \
}

#define GLOBAL_VAR_CONST(X, V) /datum/globals/var/const/##X = V;

#define GLOBAL_VAR(X) /datum/globals/var/static/##X;

#define GLOBAL_VAR_INIT(X, V) GLOBAL_VAR(X) GLOBAL_INIT(X, V)

#define GLOBAL_DATUM(X, P) /datum/globals/var/static##P/##X;

#define GLOBAL_DATUM_INIT(X, P, V) GLOBAL_DATUM(X, P) GLOBAL_INIT(X, V)

#define GLOBAL_LIST(X) /datum/globals/var/static/list/##X;

#define GLOBAL_LIST_INIT(X, V) GLOBAL_LIST(X) GLOBAL_INIT(X, V)

#define GLOBAL_LIST_EMPTY(X) GLOBAL_LIST_INIT(X, list())

#if !defined(TESTING)
/// Prevents the GLOB member from being shown in View Variables.
#define GLOBAL_PROTECT(X) \
/datum/globals/proc/GI_P_##X() { \
	var/static/done; \
	if (done) { \
		log_debug("GLOB.GI_P_[#X] ran >1 time"); \
		return; \
	} \
	done = TRUE; \
	VV_hidden(#X); \
}
#else
#define GLOBAL_PROTECT(X)
#endif
