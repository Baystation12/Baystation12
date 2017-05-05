/spell/hand
	var/min_range = 0
	var/list/compatible_targets = list(/atom)
	var/spell_delay = 5
	var/move_delay
	var/click_delay
	var/hand_state = "spell"

/spell/hand/choose_targets(mob/user = usr)
	return list(user)

/spell/hand/cast_check(skipcharge = 0,mob/user = usr, var/list/targets)
	if(!..())
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
			return
		var/obj/item/magic_hand/H = new(src)
		if(!M.put_in_active_hand(H))
			qdel(H)
			return
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