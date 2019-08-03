//If we intercept it return true else return false
/atom/proc/RelayMouseDrag(src_object, over_object, src_location, over_location, src_control, over_control, params, var/mob/user)
	return FALSE

/mob/proc/OnMouseDrag(src_object, over_object, src_location, over_location, src_control, over_control, params)
	if(istype(loc, /atom))
		var/atom/A = loc
		if(A.RelayMouseDrag(src_object, over_object, src_location, over_location, src_control, over_control, params, src))
			return

	if(over_object)
		if(!incapacitated())
			var/obj/item/weapon/gun/gun = get_active_hand()
			if(istype(gun) && gun.can_autofire())
				set_dir(get_dir(src, over_object))
				gun.Fire(get_turf(over_object), src, params, (get_dist(over_object, src) <= 1), FALSE)