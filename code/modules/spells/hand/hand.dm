/spell/hand
	var/min_range = 0
	var/list/compatible_targets = list()
	var/spell_delay = 5
	var/move_delay
	var/click_delay
	var/hand_name = "magic hand"
	var/hand_icon = 'icons/mob/screen1.dmi'
	var/hand_state = "spell"
	var/empty_hand_message = "You need an empty hand to cast this spell."
	var/not_ready_message = "The spell isn't ready yet!"
	var/intent_help_message = "You decide against casting this spell as your intent is set to help."

/spell/hand/choose_targets(mob/user = usr)
	return list(user)

/spell/hand/cast(mob/target, mob/user)
	if(islist(target))
		target = target[1]

	if(target.get_active_hand())
		target << "<span class='warning'>[empty_hand_message]</span>"
		return
	if(istype(target.l_hand,/obj/item/magic_hand) || istype(target.r_hand,/obj/item/magic_hand)) //dont prepare two and switch them off. Seems... weird.
		target << "<span class='warning'>You already have something prepared!</span>"
		return
	var/obj/item/magic_hand/H = new(src)
	if(!target.put_in_active_hand(H))
		qdel(H)
		return

	target << "You ready the [name]."

/spell/hand/proc/valid_target(var/atom/a,var/mob/user) //we use seperate procs for our target checking for the hand spells.
	var/distance = get_dist(a,user)
	if((min_range && distance < min_range) || (range && distance > range))
		return 0
	if(!is_type_in_list(a,compatible_targets))
		return 0
	return 1

/spell/hand/proc/take_hand_charge(var/mob/user, var/obj/item/magic_hand/hand)
	return 1

/spell/hand/proc/cast_hand(var/atom/a,var/mob/user, var/obj/item/magic_hand/hand) //same for casting.
	return 1

/spell/hand/charges
	var/max_casts = 1
	var/current_casts = 1

/spell/hand/charges/cast(mob/target, mob/user)
	..()
	current_casts = max_casts
	target << "You may cast it [current_casts] times."

/spell/hand/charges/take_hand_charge(var/mob/user, var/obj/item/magic_hand/hand)
	if(!current_casts)
		return 0
	current_casts--
	return 1

/spell/hand/charges/cast_hand(var/atom/A, var/mob/user, var/obj/item/magic_hand/hand)
	if(!current_casts)
		user.drop_from_inventory(hand)
		return 0
	user << "[current_casts]/[max_casts] casts remaining."

	return 1