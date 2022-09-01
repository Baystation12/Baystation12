//Removing the lock and the buttons.
/obj/item/gun/dropped(mob/living/user)
	if(istype(user))
		user.stop_aiming(src)
	return ..()

/obj/item/gun/equipped(mob/living/user, slot)
	if(istype(user) && (slot != slot_l_hand && slot != slot_r_hand))
		user.stop_aiming(src)
	return ..()

//Compute how to fire.....
//Return 1 if a target was found, 0 otherwise.
/obj/item/gun/proc/PreFire(atom/A, mob/living/user, params)
	if(!user.aiming)
		user.aiming = new(user)
	user.face_atom(A)
	if(ismob(A) && user.aiming)
		user.aiming.aim_at(A, src)
		return 1
	return 0
