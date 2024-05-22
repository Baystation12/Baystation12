/spell/hand
	var/min_range = 0
	var/list/compatible_targets = list(/atom)
	var/spell_delay = 5
	var/move_delay
	var/click_delay
	var/hand_state = "spell"
	var/obj/item/magic_hand/current_hand
	var/show_message

/spell/hand/choose_targets(mob/user = usr)
	return list(user)

/spell/hand/cast_check(skipcharge = 0,mob/user = usr, list/targets)
	if(!..())
		return FALSE
	if(user.get_active_hand())
		to_chat(holder, SPAN_WARNING("You need an empty hand to cast this spell."))
		return FALSE
	return TRUE

/spell/hand/cast(list/targets, mob/user)
	if(current_hand)
		cancel_hand()
	if(user.get_active_hand())
		to_chat(user, SPAN_WARNING("You need an empty hand to cast this spell."))
		return FALSE
	current_hand = new(src)
	if(!user.put_in_active_hand(current_hand))
		QDEL_NULL(current_hand)
		return FALSE
	return TRUE

/spell/hand/proc/cancel_hand()
	if(!QDELETED(current_hand))
		QDEL_NULL(current_hand)

/spell/hand/Destroy()
	qdel(current_hand)
	. = ..()

/spell/hand/proc/valid_target(atom/a,mob/user) //we use separate procs for our target checking for the hand spells.
	var/distance = get_dist(a,user)
	if((min_range && distance < min_range) || (range && distance > range))
		return FALSE
	if(!is_type_in_list(a,compatible_targets))
		return FALSE
	return TRUE

/spell/hand/proc/cast_hand(atom/a,mob/user) //same for casting.
	return TRUE

/spell/hand/charges
	var/casts = 1
	var/max_casts = 1

/spell/hand/charges/cast(list/targets, mob/user)
	. = ..()
	if(.)
		casts = max_casts
		to_chat(user, "You ready the [name] spell ([casts]/[casts] charges).")

/spell/hand/charges/cast_hand()
	if(..())
		casts--
		to_chat(holder, SPAN_NOTICE("The [name] spell has [casts] out of [max_casts] charges left"))
		cancel_hand()
		return TRUE
	return FALSE

/spell/hand/duration
	var/hand_timer = null
	var/hand_duration = 0

/spell/hand/duration/cast(list/targets, mob/user)
	. = ..()
	if(.)
		hand_timer = addtimer(new Callback(src, PROC_REF(cancel_hand)), hand_duration, TIMER_STOPPABLE|TIMER_UNIQUE|TIMER_NO_HASH_WAIT|TIMER_OVERRIDE)

/spell/hand/duration/cancel_hand()
	deltimer(hand_timer)
	hand_timer = null
	..()
