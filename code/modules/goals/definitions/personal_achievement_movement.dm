// Subscribe to owner's movement event.
/datum/goal/movement/New()
	..()
	if(owner)
		var/datum/mind/mind = owner
		GLOB.moved_event.register(mind.current, src, .proc/owner_moved)

/datum/goal/movement/proc/owner_moved()
	return

/datum/goal/movement/Destroy()
	if(owner)
		var/datum/mind/mind = owner
		GLOB.moved_event.unregister(mind.current, src)
	. = ..()

/datum/goal/movement/walk
	completion_message = "It sure feels good to stretch your legs."
	var/steps = 0
	var/required_steps
	var/min_steps = 4500
	var/max_steps = 5500

/datum/goal/movement/walk/proc/valid_step()
	return TRUE

/datum/goal/movement/walk/owner_moved()
	if(steps < required_steps && valid_step())
		steps++
		if(steps >= required_steps)
			on_completion()
			GLOB.moved_event.unregister(owner, src)

/datum/goal/movement/walk/get_summary_value()
	return " ([steps]/[required_steps] step\s so far)"

/datum/goal/movement/walk/New()
	required_steps = rand(min_steps, max_steps)
	..()

/datum/goal/movement/walk/check_success()
	return (steps >= required_steps)
	
/datum/goal/movement/walk/update_strings()
	description = "Stave off microgravity muscle atrophy by walking at least [required_steps] step\s this shift."

/datum/goal/movement/walk/eva
	completion_message = "We're so very small, in the end..."
	min_steps = 50
	max_steps = 70

/datum/goal/movement/walk/eva/valid_step()
	var/datum/mind/mind = owner
	return istype(mind.current.loc, /turf/space)

/datum/goal/movement/walk/eva/update_strings()
	description = "It's so stuffy inside. Go for a spacewalk - at least [required_steps] step\s."