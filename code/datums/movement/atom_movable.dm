// Static movement denial
/datum/movement_handler/no_move/MayMove()
	return FALSE

// Anchor check
/datum/movement_handler/anchored/MayMove()
	return !host.anchored

// Movement relay
/datum/movement_handler/move_relay/DoMove(var/direction, var/mover)
	var/atom/movable/AM = host.loc
	if(!istype(AM))
		return
	. = AM.DoMove(direction, mover)
	if(!(. & MOVEMENT_HANDLED))
		. = MOVEMENT_HANDLED
		AM.relaymove(mover, direction)
