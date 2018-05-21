var/const/MOVEMENT_HANDLED = 1
var/const/MOVEMENT_REMOVE  = 2

#define INIT_MOVEMENT_HANDLERS \
if(LAZYLEN(movement_handlers) && ispath(movement_handlers[1])) { \
	var/new_handlers = list(); \
	for(var/path in movement_handlers){ \
		new_handlers += new path(src); \
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

/atom/movable/proc/AddMovementHandler(var/handler_path)
	INIT_MOVEMENT_HANDLERS

	. = new handler_path(src)
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

/atom/movable/proc/DoMove(var/direction)
	INIT_MOVEMENT_HANDLERS

	for(var/mh in movement_handlers)
		var/datum/movement_handler/movement_handler = mh
		var/movement_result = movement_handler.DoMove(direction)
		if(movement_result & MOVEMENT_REMOVE)
			REMOVE_AND_QDEL(movement_handler)
		if(movement_result & MOVEMENT_HANDLED)
			return MOVEMENT_HANDLED

#undef INIT_MOVEMENT_HANDLERS
#undef REMOVE_AND_QDEL

// Base
/atom/movable/Destroy()
	if(LAZYLEN(movement_handlers) && !ispath(movement_handlers[1]))
		QDEL_NULL_LIST(movement_handlers)
	. = ..()

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

/datum/movement_handler/proc/DoMove(var/direction)
	return MOVEMENT_REMOVE

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

/**************
* /mob/living *
**************/
/datum/movement_handler/mob_living
	expected_host_type = /mob/living
	var/mob/living/living

/datum/movement_handler/mob_living/New(var/host)
	..()
	src.living = host

/datum/movement_handler/mob_living/Destroy()
	living = null
	. = ..()
