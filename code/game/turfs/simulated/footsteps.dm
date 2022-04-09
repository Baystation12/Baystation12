/proc/get_footstep(var/footstep_type, var/mob/caller)
	. = caller && caller.get_footstep(footstep_type)
	if(!.)
		var/decl/footsteps/FS = decls_repository.get_decl(footstep_type)
		. = pick(FS.footstep_sounds)


/turf/simulated/floor/get_footstep_sound(var/mob/caller)
	. = ..()
	if(!.)
		if(!flooring || !flooring.footstep_type)
			return get_footstep(/decl/footsteps/blank, caller)
		else
			return get_footstep(flooring.footstep_type, caller)

/turf/simulated/Entered(var/mob/living/carbon/human/H)
	..()
	if(istype(H))
		H.handle_footsteps()
		H.step_count++

/mob/living/carbon/human/proc/has_footsteps()
	if(species.silent_steps || buckled || lying || throwing)
		return //people flying, lying down or sitting do not step

	if(shoes && (shoes.item_flags & ITEM_FLAG_SILENT))
		return // quiet shoes

	if(!has_organ(BP_L_FOOT) && !has_organ(BP_R_FOOT))
		return //no feet no footsteps

	return TRUE

/mob/living/carbon/human/proc/handle_footsteps()
	if(!has_footsteps())
		return

	 //every other turf makes a sound
	if((step_count % 2) && MOVING_QUICKLY(src))
		return

	// don't need to step as often when you hop around
	if((step_count % 3) && !has_gravity(src))
		return

	if(istype(move_intent, /decl/move_intent/creep)) //We don't make sounds if we're tiptoeing
		return

	var/turf/simulated/T = get_turf(src)
	if(istype(T))
		var/footsound = T.get_footstep_sound(src)
		if(footsound)
			var/range = -(world.view - 2)
			var/volume = 70
			if(MOVING_DELIBERATELY(src))
				volume -= 45
				range -= 0.333
			if(!shoes)
				volume -= 60
				range -= 0.333
			playsound(T, footsound, volume, 1, range)
