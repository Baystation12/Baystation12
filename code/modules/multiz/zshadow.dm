/mob  // TODO: rewrite as obj. If more efficient
	var/mob/zshadow/shadow

/mob/zshadow
	plane = OVER_OPENSPACE_PLANE
	name = "shadow"
	desc = "Z-level shadow"
	status_flags = GODMODE
	anchored = 1
	unacidable = 1
	density = 0
	opacity = 0					// Don't trigger lighting recalcs gah! TODO - consider multi-z lighting.
	//auto_init = FALSE 			// We do not need to be initialize()d
	var/mob/owner = null		// What we are a shadow of.

/mob/zshadow/can_fall()
	return FALSE

/mob/zshadow/New(var/mob/L)
	if(!istype(L))
		qdel(src)
		return
	..() // I'm cautious about this, but its the right thing to do.
	owner = L
	sync_icon(L)
	GLOB.dir_set_event.register(L, src, /mob/zshadow/proc/update_dir)


/mob/Destroy()
	if(shadow)
		qdel(shadow)
		shadow = null
	. = ..()

/mob/zshadow/Destroy()
	GLOB.dir_set_event.unregister(owner, src, /mob/zshadow/proc/update_dir)
	. = ..()

/mob/zshadow/examine(mob/user, distance, infix, suffix)
	return owner.examine(user, distance, infix, suffix)

// Relay some stuff they hear
/mob/zshadow/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "", var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	if(speaker && speaker.z != src.z)
		return // Only relay speech on our actual z, otherwise we might relay sounds that were themselves relayed up!
	if(isliving(owner))
		verb += " from above"
	return owner.hear_say(message, verb, language, alt_name, italics, speaker, speech_sound, sound_vol)

/mob/zshadow/proc/sync_icon(var/mob/M)
	var/lay = src.layer
	var/pln = src.plane
	appearance = M
	color = "#848484"
	dir = M.dir
	src.layer = lay
	src.plane = pln
	if(shadow)
		shadow.sync_icon(src)

/mob/living/proc/check_shadow()
	var/mob/M = src
	if(isturf(M.loc))
		var/turf/simulated/open/OS = GetAbove(src)
		while(OS && istype(OS))
			if(!M.shadow)
				M.shadow = new /mob/zshadow(M)
			M.shadow.forceMove(OS)
			M = M.shadow
			OS = GetAbove(M)
	// The topmost level does not need a shadow!
	if(M.shadow)
		qdel(M.shadow)
		M.shadow = null

//
// Handle cases where the owner mob might have changed its icon or overlays.
//

/mob/living/update_icons()
	. = ..()
	if(shadow)
		shadow.sync_icon(src)

// WARNING - the true carbon/human/update_icons does not call ..(), therefore we must sideways override this.
// But be careful, we don't want to screw with that proc.  So lets be cautious about what we do here.
/mob/living/carbon/human/update_icons()
	. = ..()
	if(shadow)
		shadow.sync_icon(src)

//Copy direction
/mob/zshadow/proc/update_dir()
	set_dir(owner.dir)


//Change name of shadow if it's updated too (generally moving will sync but static updates are handy)
/mob/fully_replace_character_name(var/new_name, var/in_depth = TRUE)
	. = ..()
	if(shadow)
		shadow.fully_replace_character_name(new_name)


