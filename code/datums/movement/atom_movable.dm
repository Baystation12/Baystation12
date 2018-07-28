// Static movement denial
/datum/movement_handler/no_move/MayMove()
	return MOVEMENT_STOP

// Anchor check
/datum/movement_handler/anchored/MayMove()
	return host.anchored ? MOVEMENT_STOP : MOVEMENT_PROCEED

// Movement relay
/datum/movement_handler/move_relay/DoMove(var/direction, var/mover)
	var/atom/movable/AM = host.loc
	if(!istype(AM))
		return
	. = AM.DoMove(direction, mover, FALSE)
	if(!(. & MOVEMENT_HANDLED))
		. = MOVEMENT_HANDLED
		AM.relaymove(mover, direction)

// Movement delay
/datum/movement_handler/delay
	var/delay = 1
	var/next_move

/datum/movement_handler/delay/New(var/host, var/delay)
	..()
	src.delay = max(1, delay)

/datum/movement_handler/delay/DoMove()
	next_move = world.time + delay

/datum/movement_handler/delay/MayMove()
	return world.time >= next_move ? MOVEMENT_PROCEED : MOVEMENT_STOP

// Relay self
/datum/movement_handler/move_relay_self/DoMove(var/direction, var/mover)
	host.relaymove(mover, direction)
	return MOVEMENT_HANDLED
