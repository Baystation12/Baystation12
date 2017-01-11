/mob/living/Life()
	set invisibility = 0
	set background = BACKGROUND_ENABLED

	..()

	if (transforming)
		return
	if(!loc)
		return

	if(machine && !CanMouseDrop(machine, src))
		machine = null

	var/datum/gas_mixture/environment = loc.return_air()

	if(stat != DEAD)
		//Breathing, if applicable
		handle_breathing()

		//Mutations and radiation
		handle_mutations_and_radiation()

		//Chemicals in the body
		handle_chemicals_in_body()

		//Blood - do this after chemicals so that dexplus doesn't keep people awake with no heart
		handle_blood()

		//Random events (vomiting etc)
		handle_random_events()

		//stuff in the stomach
		handle_stomach()

		. = 1
	else if(timeofdeath && (world.time - timeofdeath < 150))
		//This is to make dead people process reagents for a few ticks, so they can be treated and defibrilated
		handle_chemicals_in_body()

		. = 1

	//Handle temperature/pressure differences between body and environment
	if(environment)
		handle_environment(environment)

	//Check if we're on fire
	handle_fire()

	update_pulling()

	for(var/obj/item/weapon/grab/G in src)
		G.process()

	blinded = 0 // Placing this here just show how out of place it is.
	// human/handle_regular_status_updates() needs a cleanup, as blindness should be handled in handle_disabilities()
	if(handle_regular_status_updates()) // Status & health update, are we dead or alive etc.
		handle_disabilities() // eye, ear, brain damages
		handle_statuses() //all special effects, stunned, weakened, jitteryness, hallucination, sleeping, etc

	handle_actions()

	update_canmove()

	handle_regular_hud_updates()

/mob/living/proc/handle_breathing()
	return

/mob/living/proc/handle_mutations_and_radiation()
	return

/mob/living/proc/handle_chemicals_in_body()
	return

/mob/living/proc/handle_blood()
	return

/mob/living/proc/handle_random_events()
	return

/mob/living/proc/handle_environment(var/datum/gas_mixture/environment)
	return

/mob/living/proc/handle_stomach()
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
			stat = UNCONSCIOUS
		else if (status_flags & FAKEDEATH)
			stat = UNCONSCIOUS
		else
			stat = CONSCIOUS
		return 1

/mob/living/proc/handle_statuses()
	handle_stunned()
	handle_weakened()
	handle_paralysed()
	handle_stuttering()
	handle_silent()
	handle_drugged()
	handle_slurring()

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

/mob/living/proc/handle_impaired_vision()
	//Eyes
	if(sdisabilities & BLIND || stat)	//blindness from disability or unconsciousness doesn't get better on its own
		eye_blind = max(eye_blind, 1)
	else if(eye_blind)			//blindness, heals slowly over time
		eye_blind = max(eye_blind-1,0)
	else if(eye_blurry)			//blurry eyes heal slowly
		eye_blurry = max(eye_blurry-1, 0)

/mob/living/proc/handle_impaired_hearing()
	//Ears
	if(sdisabilities & DEAF)	//disabled-deaf, doesn't get better on its own
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

	if(machine)
		var/viewflags = machine.check_eye(src)
		if(viewflags < 0)
			reset_view(null, 0)
		else if(viewflags)
			set_sight(viewflags)
	else if(eyeobj)
		if(eyeobj.owner != src)
			reset_view(null)
	else if(!client.adminobs)
		reset_view(null)

/mob/living/proc/update_sight()
	if(stat == DEAD || eyeobj)
		update_dead_sight()
	else
		update_living_sight()

/mob/living/proc/update_living_sight()
	set_sight(sight&(~(SEE_TURFS|SEE_MOBS|SEE_OBJS)))
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
