/datum/movement_handler/mob/multiz/DoMove(var/direction, var/mob/mover, var/is_external)
	if(!(direction & (UP|DOWN)))
		return MOVEMENT_PROCEED

	var/turf/destination = (direction == UP) ? GetAbove(mob) : GetBelow(mob)
	if(!destination)
		to_chat(mob, "<span class='notice'>There is nothing of interest in this direction.</span>")
		return MOVEMENT_HANDLED

	var/turf/start = get_turf(mob)
	if(!start.CanZPass(mob, direction))
		to_chat(mob, "<span class='warning'>\The [start] is in the way.</span>")
		return MOVEMENT_HANDLED

	if(!destination.CanZPass(mob, direction))
		to_chat(mob, "<span class='warning'>You bump against \the [destination].</span>")
		return MOVEMENT_HANDLED

	var/area/area = get_area(mob)
	if(direction == UP && area.has_gravity() && !mob.can_overcome_gravity())
		to_chat(mob, "<span class='warning'>Gravity stops you from moving upward.</span>")
		return MOVEMENT_HANDLED

	for(var/atom/A in destination)
		if(!A.CanMoveOnto(mob, start, 1.5, direction))
			to_chat(mob, "<span class='warning'>\The [A] blocks you.</span>")
			return MOVEMENT_HANDLED

	if(direction == UP && area.has_gravity() && mob.can_fall(FALSE, destination))
		to_chat(mob, "<span class='warning'>You see nothing to hold on to.</span>")
		return MOVEMENT_HANDLED

	return MOVEMENT_PROCEED

//For ghosts and such
/datum/movement_handler/mob/multiz_connected/DoMove(var/direction, var/mob/mover, var/is_external)
	if(!(direction & (UP|DOWN)))
		return MOVEMENT_PROCEED

	var/turf/destination = (direction == UP) ? GetAbove(mob) : GetBelow(mob)
	if(!destination)
		to_chat(mob, "<span class='notice'>There is nothing of interest in this direction.</span>")
		return MOVEMENT_HANDLED

	return MOVEMENT_PROCEED

/datum/movement_handler/deny_multiz/DoMove(var/direction, var/mob/mover, var/is_external)
	if(direction & (UP|DOWN))
		return MOVEMENT_HANDLED
	return MOVEMENT_PROCEED
