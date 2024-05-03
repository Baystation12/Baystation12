/mob/living/Life()
	set invisibility = 0
	set background = BACKGROUND_ENABLED

	..()

	if (HasMovementHandler(/datum/movement_handler/mob/transformation))
		return
	if (!loc)
		return

	if(machine && !CanMouseDrop(machine, src))
		machine = null

	//Handle temperature/pressure differences between body and environment
	var/datum/gas_mixture/environment = loc.return_air()
	if(environment)
		handle_environment(environment)

	blinded = 0 // Placing this here just show how out of place it is.
	// human/handle_regular_status_updates() needs a cleanup, as blindness should be handled in handle_disabilities()
	handle_regular_status_updates() // Status & health update, are we dead or alive etc.

	if(stat != DEAD)
		aura_check(AURA_TYPE_LIFE)

		if(!InStasis())
			//Mutations and radiation
			handle_mutations_and_radiation()

	//Check if we're on fire
	handle_fire()

	update_pulling()

	for(var/obj/item/grab/G in src)
		G.Process()

	handle_actions()

	UpdateLyingBuckledAndVerbStatus()

	handle_regular_hud_updates()

	//update our thermal image relative to our surroundings

	if(thermal_image)
		thermal_image.process_appearance()

	return 1

/mob/living/proc/handle_breathing()
	return

/mob/living/proc/handle_mutations_and_radiation()
	return

/mob/living/proc/handle_chemicals_in_body()
	return

/mob/living/proc/handle_random_events()
	return

/mob/living/proc/handle_environment(datum/gas_mixture/environment)
	return

/mob/living/proc/update_pulling()
	if(pulling)
		if(incapacitated())
			stop_pulling()

//This updates the health and status of the mob (conscious, unconscious, dead)
/mob/living/proc/handle_regular_status_updates()
	updatehealth()
	if(stat != DEAD)
		if(paralysis)
			set_stat(UNCONSCIOUS)
		else if (status_flags & FAKEDEATH)
			set_stat(UNCONSCIOUS)
		else
			set_stat(CONSCIOUS)
		return 1

/mob/living/proc/handle_statuses()
	handle_stunned()
	handle_weakened()
	handle_paralysed()
	handle_stuttering()
	handle_silent()
	handle_drugged()
	handle_slurring()
	handle_confused()

/mob/living/proc/handle_stunned()
	if(stunned)
		AdjustStunned(-1)
		if(!stunned)
			update_icons()
	return stunned

/mob/living/proc/handle_weakened()
	if(weakened)
		weakened = max(weakened-1,0)
		if(!weakened)
			update_icons()
	return weakened

/mob/living/proc/handle_stuttering()
	if(stuttering)
		stuttering = max(stuttering-1, 0)
	return stuttering

/mob/living/proc/handle_silent()
	if(silent)
		silent = max(silent-1, 0)
	return silent

/mob/living/proc/handle_drugged()
	if(druggy)
		druggy = max(druggy-1, 0)
	return druggy

/mob/living/proc/handle_slurring()
	if(slurring)
		slurring = max(slurring-1, 0)
	return slurring

/mob/living/proc/handle_paralysed()
	if(paralysis)
		AdjustParalysis(-1)
		if(!paralysis)
			update_icons()
	return paralysis

/mob/living/proc/handle_disabilities()
	handle_impaired_vision()
	handle_impaired_hearing()

/mob/living/proc/handle_confused()
	confused = max(confused - 1, 0)
	return confused

/mob/living/proc/handle_impaired_vision()
	//Eyes
	if(sdisabilities & BLINDED || stat)	//blindness from disability or unconsciousness doesn't get better on its own
		eye_blind = max(eye_blind, 1)
	else if(eye_blind)			//blindness, heals slowly over time
		eye_blind = max(eye_blind-1,0)
	else if(eye_blurry)			//blurry eyes heal slowly
		eye_blurry = max(eye_blurry-1, 0)

/mob/living/proc/handle_impaired_hearing()
	//Ears
	if(sdisabilities & DEAFENED)	//disabled-deaf, doesn't get better on its own
		setEarDamage(null, max(ear_deaf, 1))
	else if(ear_damage < 25)
		adjustEarDamage(-0.05, -1)	// having ear damage impairs the recovery of ear_deaf
	else if(ear_damage < 100)
		adjustEarDamage(-0.05, 0)	// deafness recovers slowly over time, unless ear_damage is over 100. TODO meds that heal ear_damage


//this handles hud updates. Calls update_vision() and handle_hud_icons()
/mob/living/proc/handle_regular_hud_updates()
	if(!client)	return 0

	handle_hud_icons()
	handle_vision()

	return 1

/mob/living/proc/handle_vision()
	update_sight()

	if(stat == DEAD)
		return

	if(eye_blind)
		overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
	else
		clear_fullscreen("blind")
		set_fullscreen(disabilities & NEARSIGHTED, "impaired", /obj/screen/fullscreen/impaired, 1)
		set_fullscreen(eye_blurry, "blurry", /obj/screen/fullscreen/blurry)
		set_fullscreen(druggy, "high", /obj/screen/fullscreen/high)

	set_fullscreen(stat == UNCONSCIOUS, "blackout", /obj/screen/fullscreen/blackout)

	if(machine)
		var/viewflags = machine.check_eye(src)
		if(viewflags < 0)
			reset_view(null, 0)
		else if(viewflags)
			set_sight(viewflags)
	else if(eyeobj)
		if(eyeobj.owner != src)
			reset_view(null)
	else if(!client?.adminobs)
		reset_view(null)

/mob/living/proc/update_sight()
	if(stat == DEAD || eyeobj)
		update_dead_sight()
	else
		update_living_sight()

	var/list/vision = get_accumulated_vision_handlers()
	set_sight(sight | vision[1])
	set_see_invisible(max(vision[2], see_invisible))

/mob/living/proc/update_living_sight()
	var/set_sight_flags = sight & ~(SEE_TURFS|SEE_MOBS|SEE_OBJS|SEE_PIXELS|SEE_INFRA)
	if(stat & UNCONSCIOUS)
		set_sight_flags |= BLIND
	else
		set_sight_flags &= ~BLIND

	set_sight(set_sight_flags)
	set_see_in_dark(initial(see_in_dark))
	set_see_invisible(initial(see_invisible))

/mob/living/proc/update_dead_sight()
	set_sight(sight|SEE_TURFS|SEE_MOBS|SEE_OBJS)
	set_see_in_dark(8)
	set_see_invisible(SEE_INVISIBLE_LEVEL_TWO)

/mob/living/proc/handle_hud_icons()
	handle_hud_icons_health()
	handle_hud_glasses()

/mob/living/proc/handle_hud_icons_health()
	return

//Adaptative darksight
//Ideally this would run instantly as mob updates are a bit too slow for this (noticeable when moving fast), but set_see_in_dark is called several timees.
//For the time being it's instant and called whenever see in dark changes. Replace with a single call at end of updates once code is not spaghetti
/mob/living/proc/handle_darksight()
	if(!darksight)
		return

	//For testing purposes
	var/darksightedness = min(see_in_dark/world.view,1.0)	//A ratio of how good your darksight is, from 'nada' to 'really darn good'
	var/current = darksight.alpha/255						//Our current adjustedness
	var/adjusted_diameter = (0.5 + (see_in_dark - 1)) * 2
	var/newScale = min((adjusted_diameter) * (world.icon_size/DARKSIGHT_GRADIENT_SIZE), 1)*0.9 //Scale the darksight gradient

	var/brightness = 0.0 //We'll assume it's superdark if we can't find something else.


	//Currently we're going to assume that only thing that matter is your turf
	//This is not necessarily correct.
	//We may want to blind people inside exosuits and such. At some point we could try moving lumcount to atom, default to turf and then we can make those override

	var/turf/my_turf = get_turf(src)
	if(isturf(my_turf))
		brightness = my_turf.get_lumcount()

	brightness = min((brightness + brightness*brightness), 1) //Increase apparent brightness so it's not that obvious. TODO: Make this a curve

	var/darkness = 1-brightness					//Silly, I know, but 'alpha' and 'darkness' go the same direction on a number line
	newScale *= darkness                        // you see further in the dark, in fully lit areas you don't get a bonus
	var/adjust_to = min(darkness,darksightedness)//Capped by how darksighted they are
	var/distance = abs(current-adjust_to)		//Used for how long to animate for
	var/negative = current > adjust_to          //Unfortunately due to a visual issue this must be instant if we go down 1 level of darksight

	if((distance < 0.001) && (abs(darksight.transform.a - newScale) < 0.01)) return	 //We're already all set

	if(negative)
		distance = 0 //Make it instant

	//TODO:.
	//FIX VISION CODE! There is no correct place to update darksight as it keeps being reset and enabled several times a frame (even placing it on Life doesnt work because overrides set it in wrong function)
	// Time = 0 means instant change, avoids some issues of animation resetting several times a frame
	distance = 0

	animate(darksight, alpha = (adjust_to*255), transform = matrix().Update(scale_x = newScale, scale_y = newScale), time = (distance*1 SECOND), flags = ANIMATION_LINEAR_TRANSFORM)

//Need to update every time we set see in dark as it can be called at many different points and waiting for next frame causes visual artifacts
/mob/living/set_see_in_dark(new_see_in_dark)
	. = ..()
	handle_darksight()

// Used by thermal effects. Not very useful elsewhere
/mob/living/get_warmth()
	return bodytemperature
