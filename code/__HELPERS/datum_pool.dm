
/*
/tg/station13 /atom/movable Pool:
---------------------------------
By RemieRichards

Creation/Deletion is laggy, so let's reduce reuse and recycle!

*/
#define ATOM_POOL_COUNT 100
// "define DEBUG_ATOM_POOL 1
var/global/list/GlobalPool = list()

//You'll be using this proc 90% of the time.
//It grabs a type from the pool if it can
//And if it can't, it creates one
//The pool is flexible and will expand to fit
//The new created atom when it eventually
//Goes into the pool

//Second argument can be a new location, if the type is /atom/movable
//Or a list of arguments
//Either way it gets passed to new

/proc/PoolOrNew(var/get_type,var/second_arg)
	if(!get_type)
		return

	var/datum/D
	D = GetFromPool(get_type,second_arg)

	if(!D)
		if(ispath(get_type))
			if(islist(second_arg))
				return new get_type (arglist(second_arg))
			else
				return new get_type (second_arg)
	return D

/proc/GetFromPool(var/get_type,var/second_arg)
	if(!get_type)
		return 0

	if(isnull(GlobalPool[get_type]))
		return 0

	if(length(GlobalPool[get_type]) == 0)
		return 0

	var/datum/D = pick_n_take(GlobalPool[get_type])
	if(D)
		D.ResetVars()
		D.Prepare()
		return D
	return 0

/proc/PlaceInPool(var/datum/D)
	if(!istype(D))
		return

	if(length(GlobalPool[D.type]) > ATOM_POOL_COUNT)
		#ifdef DEBUG_ATOM_POOL
		world << text("DEBUG_DATUM_POOL: PlaceInPool([]) exceeds [] discarding...", D.type, ATOM_POOL_COUNT)
		#endif
		qdel(D)
		return

	if(D in GlobalPool[D.type])
		return

	if(!GlobalPool[D.type])
		GlobalPool[D.type] = list()

	GlobalPool[D.type] |= D

	D.Destroy()
	D.ResetVars()


/datum/proc/Prepare(args)
	if(islist(args))
		New(arglist(args))
	else
		New(args)

/atom/movable/Prepare(args)
	if(islist(args))
		loc = args[1]
	else
		loc = args
	..()

/datum/proc/ResetVars(var/list/exlude = list())
	var/list/excluded = list("animate_movement", "loc", "locs", "parent_type", "vars", "verbs", "type") + exlude

	for(var/V in vars)
		if(V in excluded)
			continue

		vars[V] = initial(vars[V])

/atom/movable/ResetVars()
	..()
	vars["loc"] = null

#undef ATOM_POOL_COUNT
