/mob/living/var/obj/aiming_overlay/aiming
/mob/living/var/list/aimed = list()

/mob/living/proc/stop_aiming(var/obj/item/thing, var/no_message = 0)
	if(!aiming)
		aiming = new(src)
	if(thing && aiming.aiming_with != thing)
		return
	aiming.cancel_aiming(no_message)

/mob/living/death(gibbed,deathmessage="seizes up and falls limp...")
	if(..())
		stop_aiming(no_message=1)

/mob/living/update_canmove()
	..()
	if(lying)
		stop_aiming(no_message=1)

/mob/living/Weaken(amount)
	stop_aiming(no_message=1)
	..()

/mob/living/Destroy()
	if(aiming)
		qdel(aiming)
		aiming = null
	aimed.Cut()
	return ..()

/turf/Enter(var/mob/living/mover)
	. = ..()
	if(istype(mover))
		if(mover.aiming && mover.aiming.aiming_at)
			mover.aiming.update_aiming()
		if(mover.aimed.len)
			mover.trigger_aiming(TARGET_CAN_MOVE)

/mob/living/forceMove(var/atom/destination)
	. = ..()
	if(aiming && aiming.aiming_at)
		aiming.update_aiming()
	if(aimed.len)
		trigger_aiming(TARGET_CAN_MOVE)
