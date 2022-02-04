/mob/living
	var/decl/maneuver/prepared_maneuver
	var/list/available_maneuvers = list()

/mob/living/begin_falling(var/lastloc, var/below)
	if(throwing)
		return
	if(!can_fall(location_override = lastloc) && prepared_maneuver && prepared_maneuver.can_be_used_by(src, silent = TRUE))
		var/turf/check = get_turf(lastloc)
		for(var/i = 1 to Ceil((get_jump_distance() * get_acrobatics_multiplier()) * prepared_maneuver.reflexive_modifier))
			var/turf/next_check = get_step(check, dir)
			if(!next_check || next_check.density)
				break
			check = next_check
			if(!can_fall(location_override = check))
				break
		if(check && check != loc)
			addtimer(CALLBACK(src, /mob/living/proc/reflexive_maneuver_callback, lastloc, check), 0)
		return
	. = ..()

/mob/living/proc/reflexive_maneuver_callback(var/turf/origin, var/turf/check)
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
		maneuvers += decls_repository.get_decl(maneuver)

	var/next_maneuver = input(src, "Select a maneuver.") as null|anything in maneuvers
	if(next_maneuver)
		prepared_maneuver = next_maneuver
		to_chat(src, SPAN_NOTICE("You prepare to [prepared_maneuver.name]."))
	else
		prepared_maneuver = null
		to_chat(src, SPAN_NOTICE("You are no longer preparing to perform a maneuver."))

/mob/living/proc/perform_maneuver(var/maneuver, var/atom/target)
	var/decl/maneuver/performing_maneuver = ispath(maneuver) ? decls_repository.get_decl(maneuver) : maneuver
	if(istype(performing_maneuver))
		. = performing_maneuver.perform(src, target, get_acrobatics_multiplier(performing_maneuver))

/mob/living/proc/get_acrobatics_multiplier(var/decl/maneuver/attempting_maneuver)
	return 1

/mob/living/proc/can_do_maneuver(var/decl/maneuver/maneuver, var/silent = FALSE)
	. = ((istype(maneuver) ? maneuver.type : maneuver) in available_maneuvers)

/mob/living/proc/get_jump_distance()
	return 0
