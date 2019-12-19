/*
	Custom click handling
*/
#define SETUP_CLICK_HANDLERS \
if(!click_handlers) { \
	click_handlers = new(); \
	click_handlers += new/datum/click_handler/default(src) \
}

/mob
	var/list/click_handlers

/mob/Destroy()
	QDEL_NULL_LIST(click_handlers)
	. = ..()

var/const/CLICK_HANDLER_NONE                 = 0x000000
var/const/CLICK_HANDLER_REMOVE_ON_MOB_LOGOUT = 0x000001
var/const/CLICK_HANDLER_REMOVE_IF_NOT_TOP    = 0x000002
var/const/CLICK_HANDLER_ALL                  = (~0)

/datum/click_handler
	var/mob/user
	var/flags = 0

/datum/click_handler/New(var/mob/user)
	..()
	src.user = user
	if(flags & (CLICK_HANDLER_REMOVE_ON_MOB_LOGOUT))
		GLOB.logged_out_event.register(user, src, /datum/click_handler/proc/OnMobLogout)

/datum/click_handler/Destroy()
	if(flags & (CLICK_HANDLER_REMOVE_ON_MOB_LOGOUT))
		GLOB.logged_out_event.unregister(user, src, /datum/click_handler/proc/OnMobLogout)
	user = null
	. = ..()

/datum/click_handler/proc/Enter()
	return

/datum/click_handler/proc/Exit()
	return

/datum/click_handler/proc/OnMobLogout()
	user.RemoveClickHandler(src)

/datum/click_handler/proc/OnClick(var/atom/A, var/params)
	return

/datum/click_handler/proc/OnDblClick(var/atom/A, var/params)
	return

/datum/click_handler/default/OnClick(var/atom/A, var/params)
	user.ClickOn(A, params)

/datum/click_handler/default/OnDblClick(var/atom/A, var/params)
	user.DblClickOn(A, params)

/mob/proc/GetClickHandler(var/datum/click_handler/popped_handler)
	SETUP_CLICK_HANDLERS
	return click_handlers[1]

// Returns TRUE if the given click handler was removed, otherwise FALSE
/mob/proc/RemoveClickHandler(var/datum/click_handler/click_handler)
	if(!click_handlers)
		return FALSE
	if(ispath(click_handler)) // If we were given a path instead of an instance, find the first matching instance by type
		// No removing of the default click handler
		if(click_handler == /datum/click_handler/default)
			return FALSE
		click_handler = get_instance_of_strict_type(click_handlers, click_handler)
	if(!click_handler)
		return FALSE

	. = (click_handler in click_handlers)
	if(!.)
		return

	var/was_top = click_handlers[1] == click_handler

	if(was_top)
		click_handler.Exit()
	click_handlers.Remove(click_handler)
	qdel(click_handler)

	if(!was_top)
		return
	click_handler = click_handlers[1]
	if(click_handler)
		click_handler.Enter()

// Returns TRUE if the given click handler type was NOT previously the top click handler but now is
/mob/proc/PushClickHandler(var/datum/click_handler/new_click_handler_type)
	// No manipulation of the default click handler
	if(new_click_handler_type == /datum/click_handler/default)
		return FALSE
	if((initial(new_click_handler_type.flags) & CLICK_HANDLER_REMOVE_ON_MOB_LOGOUT) && !client)
		return FALSE
	SETUP_CLICK_HANDLERS

	var/datum/click_handler/click_handler = click_handlers[1]
	if(click_handler.type == new_click_handler_type)
		return FALSE // If the top click handler is already the same as the desired one, bow out

	click_handler.Exit()
	if(click_handler.flags & CLICK_HANDLER_REMOVE_IF_NOT_TOP)
		click_handlers.Remove(click_handler)
		qdel(click_handler)

	click_handler = get_instance_of_strict_type(click_handlers, click_handler)
	if(click_handler)
		click_handlers.Remove(click_handler)
	else
		click_handler = new new_click_handler_type(src)

	click_handlers.Insert(1, click_handler) // Insert new handlers first
	click_handler.Enter()
	return TRUE

#undef SETUP_CLICK_HANDLERS
