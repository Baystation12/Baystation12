/mob/living
	var/singleton/maneuver/prepared_maneuver
	var/list/available_maneuvers = list()

/mob/living/begin_falling(lastloc, below)
	if(throwing)
		return
	if(!can_fall(location_override = lastloc) && prepared_maneuver && prepared_maneuver.can_be_used_by(src, silent = TRUE))
		var/turf/check = get_turf(lastloc)
		for(var/i = 1 to ceil((get_jump_distance() * get_acrobatics_multiplier()) * prepared_maneuver.reflexive_modifier))
			var/turf/next_check = get_step(check, dir)
			if(!next_check || next_check.density)
				break
			check = next_check
			if(!can_fall(location_override = check))
				break
		if(check && check != loc)
			addtimer(new Callback(src, TYPE_PROC_REF(/mob/living, reflexive_maneuver_callback), lastloc, check), 0)
		return
	. = ..()

/mob/living/proc/reflexive_maneuver_callback(turf/origin, turf/check)
	if(prepared_maneuver)
		if(origin)
			forceMove(get_turf(origin))
		prepared_maneuver.perform(src, check, get_acrobatics_multiplier(prepared_maneuver), reflexively = TRUE)

/mob/living/verb/prepare_maneuver()
	set name = "Prepare To Maneuver"
	set desc = "Select a maneuver to perform."
	set category = "IC"

	if(!length(available_maneuvers))
		to_chat(src, SPAN_WARNING("You are unable to perform any maneuvers."))
		return

	var/list/maneuvers = list()
	for(var/maneuver in available_maneuvers)
		maneuvers += GET_SINGLETON(maneuver)

	var/next_maneuver = input(src, "Select a maneuver.") as null|anything in maneuvers
	if(next_maneuver)
		prepared_maneuver = next_maneuver
		to_chat(src, SPAN_NOTICE("You prepare to [prepared_maneuver.name]."))
	else
		prepared_maneuver = null
		to_chat(src, SPAN_NOTICE("You are no longer preparing to perform a maneuver."))

/mob/living/proc/perform_maneuver(maneuver, atom/target)
	var/singleton/maneuver/performing_maneuver = ispath(maneuver) ? GET_SINGLETON(maneuver) : maneuver
	if(istype(performing_maneuver))
		. = performing_maneuver.perform(src, target, get_acrobatics_multiplier(performing_maneuver))

/mob/living/proc/get_acrobatics_multiplier(singleton/maneuver/attempting_maneuver)
	return 1

/mob/living/proc/can_do_maneuver(singleton/maneuver/maneuver, silent = FALSE)
	. = ((istype(maneuver) ? maneuver.type : maneuver) in available_maneuvers)

/mob/living/proc/get_jump_distance()
	return 0


/mob/living/proc/post_maneuver()
	return
