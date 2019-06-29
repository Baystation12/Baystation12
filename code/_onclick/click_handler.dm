var/const/CLICK_HANDLER_NONE                 = 0
var/const/CLICK_HANDLER_REMOVE_ON_MOB_LOGOUT = 1
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
	if (user)
		user.click_handlers.Remove(src)
	user = null
	. = ..()

/datum/click_handler/proc/Enter()
	return

/datum/click_handler/proc/Exit()
	return



/datum/click_handler/proc/OnMobLogout()
	user.RemoveClickHandler(src)

/datum/click_handler/proc/OnClick(var/atom/A, var/params)
	return TRUE

/datum/click_handler/proc/OnDblClick(var/atom/A, var/params)
	return TRUE

/datum/click_handler/proc/MouseDown(object,location,control,params)
	return TRUE

/datum/click_handler/proc/MouseDrag(src_object,over_object,src_location,over_location,src_control,over_control,params)
	return TRUE

/datum/click_handler/proc/MouseUp(object,location,control,params)
	return TRUE

/datum/click_handler/proc/MouseMove(src_object,over_object,src_location,over_location,src_control,over_control,params)
	return TRUE


/datum/click_handler/default/OnClick(var/atom/A, var/params)
	user.ClickOn(A, params)
	return TRUE

/datum/click_handler/default/OnDblClick(var/atom/A, var/params)
	user.DblClickOn(A, params)
	return TRUE

//Tests whether the target thing is valid, and returns it if so.
//If its not valid, null will be returned
//In the case of click catchers, we resolve and return the turf under it
/datum/click_handler/proc/resolve_world_target(var/a)

	if (istype(a, /obj/screen/click_catcher))
		var/obj/screen/click_catcher/CC = a
		return CC.resolve(user)

	if (istype(a, /turf))
		return a

	else if (istype(a, /atom))
		var/atom/A = a
		if (istype(A.loc, /turf))
			return A
	return null


/mob/proc/GetClickHandler(var/datum/click_handler/popped_handler)
	if(!click_handlers)
		click_handlers = new()
	if(click_handlers.is_empty())
		PushClickHandler(/datum/click_handler/default)
	return click_handlers.Top()

/mob/proc/GetClickHandlers()
	if(!click_handlers)
		click_handlers = new()
	if(click_handlers.is_empty())
		PushClickHandler(/datum/click_handler/default)
	return click_handlers.Copy()

/mob/proc/RemoveClickHandler(var/datum/click_handler/click_handler)
	if(!click_handlers)
		return

	var/was_top = click_handlers.Top() == click_handler

	if(was_top)
		click_handler.Exit()
	click_handlers.Remove(click_handler)
	qdel(click_handler)

	if(!was_top)
		return
	click_handler = click_handlers.Top()
	if(click_handler)
		click_handler.Enter()


/mob/proc/PopClickHandler()
	if(!click_handlers)
		return
	RemoveClickHandler(click_handlers.Top())

/mob/proc/PushClickHandler(var/datum/click_handler/new_click_handler_type)
	if((initial(new_click_handler_type.flags) & CLICK_HANDLER_REMOVE_ON_MOB_LOGOUT) && !client)
		return FALSE
	if(!click_handlers)
		click_handlers = new()
	var/datum/click_handler/click_handler = click_handlers.Top()
	if(click_handler)
		click_handler.Exit()

	click_handler = new new_click_handler_type(src)
	click_handler.Enter()
	click_handlers.Push(click_handler)
	return click_handler












/****************************
	Full auto gunfire
*****************************/
/datum/click_handler/fullauto
	var/atom/target = null
	var/firing = FALSE
	var/obj/item/weapon/gun/reciever //The thing we send firing signals to.
	//Todo: Make this work with callbacks


/datum/click_handler/fullauto/proc/start_firing()
	firing = TRUE
	while (firing && target)
		do_fire()
		sleep(0.5) //Keep spamming events every frame as long as the button is held
	stop_firing()

//Next loop will notice these vars and stop shooting
/datum/click_handler/fullauto/proc/stop_firing()
	firing = FALSE
	target = null

/datum/click_handler/fullauto/proc/do_fire()
	reciever.afterattack(target, user, FALSE)

/datum/click_handler/fullauto/MouseDown(object,location,control,params)
	object = resolve_world_target(object)
	if (object)
		target = object
		user.face_atom(target)
		spawn()
			start_firing()
		return FALSE
	return TRUE

/datum/click_handler/fullauto/MouseDrag(src_object,over_object,src_location,over_location,src_control,over_control,params)
	src_location = resolve_world_target(src_location)
	if (src_location && firing)
		target = src_location //This var contains the thing the user is hovering over, oddly
		user.face_atom(target)
		return FALSE
	return TRUE

/datum/click_handler/fullauto/MouseUp(object,location,control,params)
	stop_firing()
	return TRUE

/datum/click_handler/fullauto/Destroy()
	stop_firing()//Without this it keeps firing in an infinite loop when deleted
	.=..()




/****************************
	Sustained Fire
*****************************/
/datum/click_handler/sustained
//Useful for ripper and maybe tracking lasers. Works similar to full auto, but:
	//Constant firing events are not generated
	//Firing events are generated on every mousedrag
	var/atom/target = null
	var/firing = FALSE
	var/obj/item/weapon/gun/reciever //The thing we send firing signals to.
	var/last_params
	//Todo: Make this work with callbacks


/datum/click_handler/sustained/proc/start_firing()

	if (reciever && istype(reciever.loc, /mob))
		GLOB.moved_event.register(reciever.loc, reciever, /obj/item/weapon/gun/proc/user_moved)
	do_fire()
	firing = reciever.firing

//Next loop will notice these vars and stop shooting
/datum/click_handler/sustained/proc/stop_firing()
	if (firing)
		if (reciever && istype(reciever.loc, /mob))
			GLOB.moved_event.unregister(reciever.loc, reciever, /obj/item/weapon/gun/proc/user_moved)
		firing = FALSE
		target = null
		reciever.stop_firing()

/datum/click_handler/sustained/proc/do_fire()
	reciever.afterattack(target, user, FALSE, last_params, get_global_pixel_click_location(last_params, user ? user.client : null))

/datum/click_handler/sustained/MouseDown(object,location,control,params)
	last_params = params
	object = resolve_world_target(object)
	if (object)
		target = object
		user.face_atom(target)
		start_firing()
		return FALSE
	return TRUE

/datum/click_handler/sustained/MouseDrag(src_object,over_object,src_location,over_location,src_control,over_control,params)
	last_params = params
	src_location = resolve_world_target(src_location)
	if (src_location && firing)
		target = src_location //This var contains the thing the user is hovering over, oddly
		user.face_atom(target)
		do_fire()
		return FALSE
	return TRUE

/datum/click_handler/sustained/MouseMove(src_object,over_object,src_location,over_location,src_control,over_control,params)
	last_params = params
	src_location = resolve_world_target(src_location)
	if (src_location && firing)
		target = src_location //This var contains the thing the user is hovering over, oddly
		user.face_atom(target)
		do_fire()
		return FALSE
	return TRUE


/datum/click_handler/sustained/MouseUp(object,location,control,params)
	stop_firing()
	return TRUE

/datum/click_handler/sustained/Destroy()
	stop_firing()//Without this it keeps firing in an infinite loop when deleted
	.=..()