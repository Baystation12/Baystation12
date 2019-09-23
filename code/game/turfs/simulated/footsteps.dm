GLOBAL_LIST_INIT(footstep_sounds, list(
	FOOTSTEP_CATWALK = list(
		'sound/effects/footstep/catwalk1.ogg',
		'sound/effects/footstep/catwalk2.ogg',
		'sound/effects/footstep/catwalk3.ogg',
		'sound/effects/footstep/catwalk4.ogg',
		'sound/effects/footstep/catwalk5.ogg'),
	FOOTSTEP_WOOD = list(
		'sound/effects/footstep/wood1.ogg',
		'sound/effects/footstep/wood2.ogg',
		'sound/effects/footstep/wood3.ogg',
		'sound/effects/footstep/wood4.ogg',
		'sound/effects/footstep/wood5.ogg'),
	FOOTSTEP_TILES = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'),
	FOOTSTEP_PLATING =  list(
		'sound/effects/footstep/plating1.ogg',
		'sound/effects/footstep/plating2.ogg',
		'sound/effects/footstep/plating3.ogg',
		'sound/effects/footstep/plating4.ogg',
		'sound/effects/footstep/plating5.ogg'),
	FOOTSTEP_CARPET = list(
		'sound/effects/footstep/carpet1.ogg',
		'sound/effects/footstep/carpet2.ogg',
		'sound/effects/footstep/carpet3.ogg',
		'sound/effects/footstep/carpet4.ogg',
		'sound/effects/footstep/carpet5.ogg'),
	FOOTSTEP_ASTEROID = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg',
		'sound/effects/footstep/asteroid5.ogg'),
	FOOTSTEP_GRASS = list(
		'sound/effects/footstep/grass1.ogg',
		'sound/effects/footstep/grass2.ogg',
		'sound/effects/footstep/grass3.ogg',
		'sound/effects/footstep/grass4.ogg'),
	FOOTSTEP_WATER = list(
		'sound/effects/footstep/water1.ogg',
		'sound/effects/footstep/water2.ogg',
		'sound/effects/footstep/water3.ogg',
		'sound/effects/footstep/water4.ogg'),
	FOOTSTEP_LAVA = list(
		'sound/effects/footstep/lava1.ogg',
		'sound/effects/footstep/lava2.ogg',
		'sound/effects/footstep/lava3.ogg'),
	FOOTSTEP_BLANK = list(
		'sound/effects/footstep/blank.ogg')
))

/proc/get_footstep(var/footstep_type, var/mob/caller)
	. = caller && caller.get_footstep(footstep_type)
	if(!. && GLOB.footstep_sounds[footstep_type])
		. = pick(GLOB.footstep_sounds[footstep_type])

/turf/simulated/proc/get_footstep_sound(var/mob/caller)

	for(var/obj/structure/S in contents)
		if(S.footstep_type)
			return get_footstep(S.footstep_type, caller)

	if(check_fluid_depth(10) && !is_flooded(TRUE))
		return get_footstep(FOOTSTEP_WATER, caller)

	if(is_plating())
		return get_footstep(FOOTSTEP_PLATING, caller)

	if(footstep_type)
		return get_footstep(footstep_type, caller)

/turf/simulated/floor/get_footstep_sound(var/mob/caller)
	. = ..()
	if(!.)
		if(!flooring || !flooring.footstep_type)
			return get_footstep(FOOTSTEP_BLANK, caller)
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
