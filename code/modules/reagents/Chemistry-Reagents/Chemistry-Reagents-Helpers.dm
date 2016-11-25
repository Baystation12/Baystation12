/atom/movable/proc/can_be_injected_by(var/atom/injector)
	if(!Adjacent(get_turf(injector)))
		return FALSE
	if(!reagents)
		return FALSE
	if(!reagents.get_free_space())
		return FALSE
	return TRUE

/obj/can_be_injected_by(var/atom/injector)
	return is_open_container() && ..()

/mob/living/can_be_injected_by(var/atom/injector)
	return ..() && (can_inject(null, 0, BP_CHEST) || can_inject(null, 0, BP_GROIN))
