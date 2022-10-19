#define LOCK_LOCKED 1
#define LOCK_BROKEN 2


/datum/lock
	var/status = 1 //unlocked, 1 == locked 2 == broken
	var/lock_data = "" //basically a randomized string. The longer the string the more complex the lock.
	var/atom/holder

/datum/lock/New(atom/h, complexity = 1)
	holder = h
	if(istext(complexity))
		lock_data = complexity
	else
		lock_data = generateRandomString(complexity)

/datum/lock/Destroy()
	holder = null
	..()

/datum/lock/proc/unlock(key = "", mob/user)
	if(status ^ LOCK_LOCKED)
		to_chat(user, SPAN_WARNING("Its already unlocked!"))
		return 2
	key = get_key_data(key, user)
	if(cmptext(lock_data,key) && (status ^ LOCK_BROKEN))
		status &= ~LOCK_LOCKED
		return 1
	return 0

/datum/lock/proc/lock(key = "", mob/user)
	if(status & LOCK_LOCKED)
		to_chat(user, SPAN_WARNING("Its already locked!"))
		return 2
	key = get_key_data(key, user)
	if(cmptext(lock_data,key) && (status ^ LOCK_BROKEN))
		status |= LOCK_LOCKED
		return 1
	return 0

/datum/lock/proc/toggle(key = "", mob/user)
	if(status & LOCK_LOCKED)
		return unlock(key, user)
	else
		return lock(key, user)

/datum/lock/proc/getComplexity()
	return length(lock_data)

/datum/lock/proc/get_key_data(key = "", mob/user)
	if(istype(key,/obj/item/key))
		var/obj/item/key/K = key
		return K.get_data(user)
	if(istext(key))
		return key
	return null

/datum/lock/proc/isLocked()
	return status & LOCK_LOCKED

/datum/lock/proc/pick_lock(obj/item/I, mob/user)
	if(!istype(I) || (status ^ LOCK_LOCKED))
		return 0
	var/unlock_power = I.lock_picking_level
	if(!unlock_power)
		return 0
	user.visible_message("\The [user] takes out \the [I], picking \the [holder]'s lock.")
	if (!do_after(user, 2 SECONDS, holder, DO_PUBLIC_UNIQUE))
		return 0
	if(prob(20*(unlock_power/getComplexity())))
		to_chat(user, SPAN_NOTICE("You pick open \the [holder]'s lock!"))
		unlock(lock_data)
		return 1
	else if(prob(5 * unlock_power))
		to_chat(user, SPAN_WARNING("You accidently break \the [holder]'s lock with your [I]!"))
		status |= LOCK_BROKEN
	else
		to_chat(user, SPAN_WARNING("You fail to pick open \the [holder]."))
	return 0
