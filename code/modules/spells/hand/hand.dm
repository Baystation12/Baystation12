/spell/hand
	var/min_range = 0
	var/list/compatible_targets = list(/atom)
	var/spell_delay = 5
	var/move_delay
	var/click_delay
	var/hand_state = "spell"
	var/show_message
	var/obj/item/magic_hand/hand

/spell/hand/Destroy()
	cancel_hand()
	. = ..()

/spell/hand/proc/cancel_hand()
	if(hand)
		if(istype(hand.loc,/mob/living))
			var/mob/living/L = hand.loc
			to_chat(L, "<span class='warning'>\The [hand] fades away.</span>")
			L.drop_from_inventory(hand)
		GLOB.destroyed_event.unregister(hand,src)
		hand = null

/spell/hand/choose_targets(mob/user = usr)
	return list(user)

/spell/hand/cast_check(skipcharge = 0,mob/user = usr, var/list/targets)
	if(!..())
		return 0
	if(hand)
		to_chat(user,"<span class='warning'>You already have that spell prepared!</span>")
		return 0
	if(targets)
		for(var/target in targets)
			var/mob/M = target
			if(M.get_active_hand())
				to_chat(user, "<span class='warning'>You need an empty hand to cast this spell.</span>")
				return 0
	return 1

/spell/hand/cast(list/targets, mob/user)
	for(var/mob/M in targets)
		if(M.get_active_hand())
			to_chat(user, "<span class='warning'>You need an empty hand to cast this spell.</span>")
			return 0
		if(M.restrained())
			to_chat(user,  "<span class='warning'>You're restrained! You can't cast anything!</span>")
			return 0
		hand = new(src)
		GLOB.destroyed_event.register(hand,src,/spell/hand/proc/cancel_hand)
		if(!M.put_in_active_hand(hand))
			QDEL_NULL(hand)
			return 0
	return 1

/spell/hand/proc/valid_target(var/atom/a,var/mob/user) //we use seperate procs for our target checking for the hand spells.
	var/distance = get_dist(a,user)
	if((min_range && distance < min_range) || (range && distance > range))
		return 0
	if(!is_type_in_list(a,compatible_targets))
		return 0
	return 1

/spell/hand/proc/cast_hand(var/atom/a,var/mob/user) //same for casting.
	return 1

/spell/hand/charges
	var/casts = 1
	var/max_casts = 1

/spell/hand/charges/cast(list/targets, mob/user)
	. = ..()
	if(.)
		casts = max_casts
		to_chat(user, "You ready the [name] spell ([casts]/[casts] charges).")

/spell/hand/charges/cast_hand()
	if(casts-- && ..())
		to_chat(holder, "<span class='notice'>The [name] spell has [casts] out of [max_casts] charges left</span>")
	return !!casts

/spell/hand/duration
	var/hand_duration = 600 //THIS MUST BE LESS THAN COOLDOWN
	var/hand_amount = 0 //Simple way of making sure we don't delete a newly created hand
	var/datum/scheduled_task/source/remove_hand

/spell/hand/duration/New()
	..()
	remove_hand = new(0,src,/spell/hand/proc/cancel_hand)

/spell/hand/duration/cast(var/list/targets, var/mob/user)
	if(..())
		remove_hand.trigger_task_in(hand_duration)
		scheduler.schedule(remove_hand)

/spell/hand/duration/cancel_hand()
	scheduler.unschedule(remove_hand)
	..()

/spell/hand/duration/Destroy()
	scheduler.unschedule(remove_hand)
	QDEL_NULL(remove_hand)
	return ..()