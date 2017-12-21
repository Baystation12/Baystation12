#define FOOTSTEP_CARPET 	"carpet"
#define FOOTSTEP_TILES 		"tiles"
#define FOOTSTEP_PLATING 	"plating"
#define FOOTSTEP_WOOD 		"wood"
#define FOOTSTEP_ASTEROID 	"asteroid"

/turf/simulated/floor/var/global/list/footstep_sounds = list(
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
		'sound/effects/footstep/asteroid5.ogg')
	)

/decl/flooring/var/footstep_type
/decl/flooring/carpet/footstep_type = FOOTSTEP_CARPET
/decl/flooring/tiling/footstep_type = FOOTSTEP_TILES
/decl/flooring/linoleum/footstep_type = FOOTSTEP_TILES
/decl/flooring/wood/footstep_type = FOOTSTEP_WOOD
/decl/flooring/reinforced/footstep_type = FOOTSTEP_PLATING

/turf/simulated/floor/proc/get_footstep_sound()
	if(is_plating())
		return safepick(footstep_sounds[FOOTSTEP_PLATING])
	else
		return safepick(footstep_sounds[flooring.footstep_type])

/turf/simulated/floor/asteroid/get_footstep_sound()
	return safepick(footstep_sounds[FOOTSTEP_ASTEROID])

/turf/simulated/floor/exoplanet/get_footstep_sound()
	return safepick(footstep_sounds[FOOTSTEP_CARPET])

/turf/simulated/floor/Entered(var/mob/living/carbon/human/H)
	..()
	if(istype(H))
		H.handle_footsteps()
		H.step_count++

/datum/species/var/silent_steps
/datum/species/nabber/silent_steps = 1

/mob/living/carbon/human/var/step_count

/mob/living/carbon/human/proc/handle_footsteps()
	var/turf/simulated/floor/T = get_turf(src)
	if(!istype(T))
		return

	if(buckled || lying || throwing)
		return //people flying, lying down or sitting do not step

	if(m_intent == "run")
		if(step_count % 2) //every other turf makes a sound
			return

	if(species.silent_steps)
		return //species is silent

	if(!has_gravity(src))
		if(step_count % 3) // don't need to step as often when you hop around
			return

	if(!has_organ(BP_L_FOOT) && !has_organ(BP_R_FOOT))
		return //no feet no footsteps

	var/S = T.get_footstep_sound()
	if(S)
		var/range = -(world.view - 2)
		var/volume = 70
		if(m_intent == "walk")
			volume -= 45
			range -= 0.333
		if(!shoes)
			volume -= 60
			range -= 0.333

		playsound(T, S, volume, 1, range)