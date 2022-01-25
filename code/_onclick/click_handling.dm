/datum/click_handler
//	var/mob_type
	var/species
	var/handler_name
	var/one_use_flag = 0//drop client.CH after succes ability use
	var/client/owner
	// var/icon/mouse_icon

/datum/click_handler/New(client/_owner)
	owner = _owner

//datum/click_handler/Prepare(/client/_owner)

/datum/click_handler/Destroy()
	..()
	if (owner)
		owner.CH = null
	return ..()
//	owner = null

//Return false from these procs to discard the click afterwards
/datum/click_handler/proc/Click(var/atom/target, location, control, params)
	if (!isHUDobj(target))
		if (mob_check(owner.mob) && use_ability(owner.mob, target))
			//Ability successful
			if (one_use_flag)
				//If we're single use, delete ourselves anyways
				qdel(src)
		else
			//Ability fail, delete ourselves
			to_chat(owner.mob, "For some reason you can't use [handler_name] ability")
			qdel(src)

		return FALSE //As long as we're not clicking a hud object, we drop the click
	return TRUE

/datum/click_handler/proc/OnDblClick(var/atom/A, var/params)
	return

/datum/click_handler/proc/MouseDown(object,location,control,params)
	return TRUE

/datum/click_handler/proc/MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
	return TRUE

/datum/click_handler/proc/MouseUp(object,location,control,params)
	return TRUE

/datum/click_handler/proc/Enter()
	return

/datum/click_handler/proc/Exit()
	return

/datum/click_handler/proc/mob_check(mob/living/carbon/human/user) //Check can mob use a ability
	return

/datum/click_handler/proc/use_ability(mob/living/carbon/human/user,atom/target)
	return

//Tests whether the target thing is valid, and returns it if so.
//If its not valid, null will be returned
//In the case of click catchers, we resolve and return the turf under it
/datum/click_handler/proc/resolve_world_target(var/a)

	if (istype(a, /obj/screen/click_catcher))
		var/obj/screen/click_catcher/CC = a
		return CC.resolve(owner.mob)

	if (istype(a, /turf))
		return a

	else if (istype(a, /atom))
		var/atom/A = a
		if (istype(A.loc, /turf))
			return A
	return null


/****************************
	Full auto gunfire
*****************************/
/datum/click_handler/fullauto
	var/atom/target = null
	var/obj/item/gun/reciever // The thing we send firing signals to
	var/time_since_last_init // Time since last start of full auto fire , used to prevent ANGRY smashing of M1 to fire faster.
	//Todo: Make this work with callbacks

/datum/click_handler/fullauto/Click()
	if(reciever.aim_tag)
		reciever.aim_tag = 0
		return FALSE
	return TRUE

//Next loop will notice these vars and stop shooting
/datum/click_handler/fullauto/proc/stop_firing()
	target = null

/datum/click_handler/fullauto/proc/do_fire()
	reciever.afterattack(target, owner.mob, FALSE)

/datum/click_handler/fullauto/MouseDown(object, location, control, params)
	var/L = params2list(params)
	if(owner.mob.in_throw_mode || L["shift"] || L["ctrl"])
		return TRUE
	if(!isturf(owner.mob.loc)) // This stops from firing full auto weapons inside closets or in /obj/effect/dummy/chameleon chameleon projector
		return FALSE
	if(time_since_last_init > world.time)
		return FALSE

	object = resolve_world_target(object)
	if(object)
		target = object
		shooting_loop()
		time_since_last_init = world.time + reciever.fire_delay
	return TRUE

/datum/click_handler/fullauto/proc/shooting_loop()
	if(owner.mob.resting)
		return FALSE
	if(target && !reciever.aim_tag)
		owner.mob.face_atom(target)
		do_fire()
		spawn(reciever.fire_delay) shooting_loop()

/datum/click_handler/fullauto/MouseDrag(over_object, src_location, over_location, src_control, over_control, params)
	src_location = resolve_world_target(src_location)
	if(src_location)
		target = src_location
		return FALSE
	return TRUE

/datum/click_handler/fullauto/MouseUp(object, location, control, params)
	stop_firing()
	return TRUE

/datum/click_handler/fullauto/Destroy()
	stop_firing() //Without this it keeps firing in an infinite loop when deleted
	.=..()

/datum/click_handler/human/mob_check(mob/living/carbon/human/user)
	if(ishuman(user))
		if(user.species.name == src.species)
			return 1
	return 0

/datum/click_handler/human/use_ability(mob/living/carbon/human/user,atom/target)
	return
