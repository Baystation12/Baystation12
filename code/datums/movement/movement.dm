var/global/const/MOVEMENT_HANDLED = FLAG(0) // If no further movement handling should occur after this
var/global/const/MOVEMENT_REMOVE  = FLAG(1)

var/global/const/MOVEMENT_PROCEED = FLAG(2)
var/global/const/MOVEMENT_STOP    = FLAG(3)

#define INIT_MOVEMENT_HANDLERS \
if(LAZYLEN(movement_handlers) && ispath(movement_handlers[1])) { \
	var/new_handlers = list(); \
	for(var/path in movement_handlers){ \
		var/arguments = movement_handlers[path];   \
		arguments = arguments ? (list(src) | (arguments)) : list(src); \
		new_handlers += new path(arglist(arguments)); \
	} \
	movement_handlers= new_handlers; \
}

#define REMOVE_AND_QDEL(X) LAZYREMOVE(movement_handlers, X); qdel(X);

/atom/movable
	var/list/movement_handlers

// We don't want to check for subtypes, hence why we don't call is_path_in_list(), etc.
/atom/movable/proc/HasMovementHandler(var/handler_path)
	if(!LAZYLEN(movement_handlers))
		return FALSE
	if(ispath(movement_handlers[1]))
		return (handler_path in movement_handlers)
	else
		for(var/mh in movement_handlers)
			var/datum/MH = mh
			if(MH.type == handler_path)
				return TRUE
	return FALSE

/atom/movable/proc/AddMovementHandler(var/handler_path, var/handler_path_to_add_before)
	INIT_MOVEMENT_HANDLERS

	. = new handler_path(src)

	// If a handler_path_to_add_before was given, attempt to find it and insert our handler just before it
	if(handler_path_to_add_before && LAZYLEN(movement_handlers))
		var/index = 0
		for(var/handler in movement_handlers)
			index++
			var/datum/H = handler
			if(H.type == handler_path_to_add_before)
				LAZYINSERT(movement_handlers, ., index)
				return

	// If no handler_path_to_add_after was given or found, add first
	LAZYINSERT(movement_handlers, ., 1)

/atom/movable/proc/RemoveMovementHandler(var/handler_path)
	INIT_MOVEMENT_HANDLERS

	if(ispath(handler_path))
		for(var/handler in movement_handlers)
			var/datum/H = handler
			if(H.type == handler_path)
				REMOVE_AND_QDEL(H)
				break
	else if (handler_path in movement_handlers)
		REMOVE_AND_QDEL(handler_path)

/atom/movable/proc/ReplaceMovementHandler(var/handler_path)
	RemoveMovementHandler(handler_path)
	AddMovementHandler(handler_path)

/atom/movable/proc/GetMovementHandler(var/handler_path)
	INIT_MOVEMENT_HANDLERS

	for(var/handler in movement_handlers)
		var/datum/H = handler
		if(H.type == handler_path)
			return H

// If is_external is explicitly set then use that, otherwise if the mover isn't the host assume it's external
#define SET_MOVER(X) X = X || src
#define SET_IS_EXTERNAL(X) is_external = isnull(is_external) ? (mover != src) : is_external

/atom/movable/proc/DoMove(var/direction, var/mob/mover, var/is_external)
	INIT_MOVEMENT_HANDLERS
	SET_MOVER(mover)
	SET_IS_EXTERNAL(mover)

	for(var/mh in movement_handlers)
		var/datum/movement_handler/movement_handler = mh
		if(movement_handler.MayMove(mover, is_external) & MOVEMENT_STOP)
			return MOVEMENT_STOP

		. = movement_handler.DoMove(direction, mover, is_external)
		if(. & MOVEMENT_REMOVE)
			REMOVE_AND_QDEL(movement_handler)
		if(. & MOVEMENT_HANDLED)
			return

// is_external means that something else (not inside us) is asking if we may move
// This for example includes mobs bumping into each other
/atom/movable/proc/MayMove(var/mob/mover, var/is_external)
	INIT_MOVEMENT_HANDLERS
	SET_MOVER(mover)
	SET_IS_EXTERNAL(mover)

	for(var/mh in movement_handlers)
		var/datum/movement_handler/movement_handler = mh
		var/may_move = movement_handler.MayMove(mover, is_external)
		if(may_move & MOVEMENT_STOP)
			return FALSE
		if((may_move & (MOVEMENT_PROCEED|MOVEMENT_HANDLED)) == (MOVEMENT_PROCEED|MOVEMENT_HANDLED))
			return TRUE
	return TRUE

#undef SET_MOVER
#undef SET_IS_EXTERNAL
#undef INIT_MOVEMENT_HANDLERS
#undef REMOVE_AND_QDEL

/datum/movement_handler
	var/expected_host_type = /atom/movable
	var/atom/movable/host

/datum/movement_handler/New(var/atom/movable/host)
	if(!istype(host, expected_host_type))
		CRASH("Invalid host type. Expected [expected_host_type], was [host ? host.type : "*null*"]")
	src.host = host

/datum/movement_handler/Destroy()
	host = null
	. = ..()

/datum/movement_handler/proc/DoMove(var/direction, var/mob/mover, var/is_external)
	set waitfor = FALSE
	return

// Asks the handlers if the mob may move, ignoring destination, if attempting a DoMove()
/datum/movement_handler/proc/MayMove(var/mob/mover, var/is_external)
	return MOVEMENT_PROCEED

/*******
* /mob *
*******/
/datum/movement_handler/mob
	expected_host_type = /mob
	var/mob/mob

/datum/movement_handler/mob/New(var/host)
	..()
	src.mob = host

/datum/movement_handler/mob/Destroy()
	mob = null
	. = ..()
