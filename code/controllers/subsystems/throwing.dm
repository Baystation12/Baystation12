#define MAX_TICKS_TO_MAKE_UP 3 //how many missed ticks will we attempt to make up for this run.


SUBSYSTEM_DEF(throwing)
	name = "Throwing"
	wait = 1
	priority = SS_PRIORITY_THROWING
	flags = SS_NO_INIT | SS_KEEP_TIMING

	/// An atom => thrownthing map of current throws
	var/static/list/processing = list()

	/// The current run of throws being processed
	var/static/list/queue = list()


/datum/controller/subsystem/throwing/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..("Queue [length(processing)]")


/datum/controller/subsystem/throwing/fire(resumed, no_mc_tick)
	if (!resumed)
		if (!length(processing))
			return
		queue = processing.Copy()
	var/cut_until = 1
	for (var/atom/movable/movable as anything in queue)
		++cut_until
		var/datum/thrownthing/thrown = queue[movable]
		if (QDELETED(movable) || QDELETED(thrown))
			processing -= movable
			continue
		thrown.tick()
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(1, cut_until)
			return
	queue.Cut()


/datum/thrownthing
	var/atom/movable/thrownthing
	var/atom/target
	var/turf/target_turf
	var/target_zone
	var/init_dir
	var/maxrange
	var/speed
	var/mob/thrower
	var/start_time
	var/dist_travelled = 0
	var/dist_x
	var/dist_y
	var/dx
	var/dy
	var/diagonal_error
	var/pure_diagonal
	var/datum/callback/callback
	var/paused = FALSE
	var/delayed_time = 0
	var/last_move = 0


/datum/thrownthing/New(atom/movable/_thrownthing, atom/_target, _range, _speed, mob/_thrower, datum/callback/_callback)
	thrownthing = _thrownthing
	target = _target
	target_turf = get_turf(target)
	init_dir = get_dir(thrownthing, target)
	maxrange = _range
	speed = _speed
	thrower = _thrower
	callback = _callback
	if (!QDELETED(thrower))
		target_zone = thrower.zone_sel ? thrower.zone_sel.selecting : null
	dist_x = abs(target.x - thrownthing.x)
	dist_y = abs(target.y - thrownthing.y)
	dx = (target.x > thrownthing.x) ? EAST : WEST
	dy = (target.y > thrownthing.y) ? NORTH : SOUTH//same up to here
	if (dist_x == dist_y)
		pure_diagonal = TRUE
	else if (dist_x <= dist_y)
		var/olddist_x = dist_x
		var/olddx = dx
		dist_x = dist_y
		dist_y = olddist_x
		dx = dy
		dy = olddx
	diagonal_error = dist_x / 2 - dist_y
	start_time = world.time


/datum/thrownthing/Destroy()
	SSthrowing.processing -= thrownthing
	thrownthing.throwing = null
	thrownthing = null
	target = null
	thrower = null
	callback = null
	return ..()


/datum/thrownthing/proc/tick()
	var/atom/movable/AM = thrownthing
	if (!isturf(AM.loc) || !AM.throwing)
		finalize()
		return
	if (paused)
		delayed_time += world.time - last_move
		return
	if (dist_travelled && hitcheck(get_turf(thrownthing)))
		finalize()
		return
	var/atom/step
	last_move = world.time
	var/scaled_wait = world.tick_lag * SSthrowing.wait
	var/target_travel = (delayed_time + (world.time + world.tick_lag) - start_time) * speed
	var/prior_travel = dist_travelled ? dist_travelled : -1
	var/max_travel = speed * MAX_TICKS_TO_MAKE_UP
	var/tilestomove = ceil(min(target_travel - prior_travel, max_travel) * scaled_wait)
	while (tilestomove-- > 0)
		if (dist_travelled >= maxrange || AM.loc == target_turf)
			finalize()
			return
		if (dist_travelled <= max(dist_x, dist_y)) //if we haven't reached the target yet we home in on it, otherwise we use the initial direction
			step = get_step(AM, get_dir(AM, target_turf))
		else
			step = get_step(AM, init_dir)
		if (!pure_diagonal) // not a purely diagonal trajectory and we don't want all diagonal moves to be done first
			if (diagonal_error >= 0 && max(dist_x,dist_y) - dist_travelled != 1) //we do a step forward unless we're right before the target
				step = get_step(AM, dx)
			diagonal_error += (diagonal_error < 0) ? dist_x/2 : -dist_y
		if (!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
			finalize()
			return
		if (hitcheck(step))
			finalize()
			return
		AM.Move(step, get_dir(AM, step))
		if (!AM.throwing) // we hit something during our move
			return
		dist_travelled++


/datum/thrownthing/proc/finalize(hit = FALSE, t_target = null)
	set waitfor = FALSE
	if(QDELETED(thrownthing))
		return
	thrownthing.throwing = null
	if (!hit)
		for (var/atom/A as anything in get_turf(thrownthing))
			if (A == target)
				hit = TRUE
				thrownthing.throw_impact(A, src)
				break
		if (!hit)
			thrownthing.throw_impact(get_turf(thrownthing), src)
			thrownthing.space_drift(init_dir)

	if(t_target && !QDELETED(thrownthing))
		thrownthing.throw_impact(t_target, src)
	if (callback)
		invoke(callback)
	if (!QDELETED(thrownthing))
		thrownthing.fall()
	qdel(src)


/datum/thrownthing/proc/hit_atom(atom/A)
	finalize(hit = TRUE, t_target = A)


/datum/thrownthing/proc/hitcheck(turf/T)
	var/atom/movable/hit_thing
	for (var/atom/movable/AM as anything in T)
		if (AM == thrownthing || (AM == thrower && !ismob(thrownthing)))
			continue
		if (!AM.density || AM.throwpass)//check if ATOM_FLAG_CHECKS_BORDER as an atom_flag is needed
			continue
		if (!hit_thing || AM.layer > hit_thing.layer)
			hit_thing = AM
	if (hit_thing)
		finalize(hit = TRUE, t_target = hit_thing)
		return TRUE
