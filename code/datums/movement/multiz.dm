/datum/movement_handler/mob/multiz/DoMove(direction, mob/mover, is_external)
	if(!(direction & (UP|DOWN)))
		return MOVEMENT_PROCEED

	var/turf/destination = (direction == UP) ? GetAbove(mob) : GetBelow(mob)
	if(!destination)
		to_chat(mover, SPAN_NOTICE("There is nothing of interest in this direction."))
		return MOVEMENT_HANDLED

	var/turf/start = get_turf(mob)
	if(!start.CanZPass(mob, direction))
		to_chat(mover, SPAN_WARNING("\The [start] is in the way."))
		return MOVEMENT_HANDLED

	if(!destination.CanZPass(mob, direction))
		to_chat(mover, SPAN_WARNING("You bump against \the [destination]."))
		return MOVEMENT_HANDLED

	var/area/area = get_area(mob)
	if(direction == UP && area.has_gravity() && !mob.can_overcome_gravity())
		to_chat(mover, SPAN_WARNING("Gravity stops you from moving upward."))
		return MOVEMENT_HANDLED

	for(var/atom/A in destination)
		if(!A.CanMoveOnto(mob, start, 1.5, direction))
			to_chat(mover, SPAN_WARNING("\The [A] blocks you."))
			return MOVEMENT_HANDLED

	area = get_area(destination)
	if(direction == UP && area.has_gravity() && mob.can_fall(FALSE, destination))
		to_chat(mover, SPAN_WARNING("You see nothing to hold on to."))
		return MOVEMENT_HANDLED

	return MOVEMENT_PROCEED

//For ghosts and such
/datum/movement_handler/mob/multiz_connected/DoMove(direction, mob/mover, is_external)
	if(!(direction & (UP|DOWN)))
		return MOVEMENT_PROCEED

	var/turf/destination = (direction == UP) ? GetAbove(mob) : GetBelow(mob)
	if(!destination)
		to_chat(mob, SPAN_NOTICE("There is nothing of interest in this direction."))
		return MOVEMENT_HANDLED

	return MOVEMENT_PROCEED

/datum/movement_handler/deny_multiz/DoMove(direction, mob/mover, is_external)
	if(direction & (UP|DOWN))
		return MOVEMENT_HANDLED
	return MOVEMENT_PROCEED
