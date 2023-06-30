/// Looping timers automatically re-queue themselves after firing, assuming they are still valid
var/global/const/TIMER_LOOP = FLAG(0)

/// Stoppable timers produce a hash that can be given to deltimer() to unqueue them
var/global/const/TIMER_STOPPABLE = FLAG(1)

/// Two of the same timer signature cannot be queued at once when they are unique
var/global/const/TIMER_UNIQUE = FLAG(2)

/// Attempting to add a unique timer will re-queue the event instead of being ignored
var/global/const/TIMER_OVERRIDE = FLAG(3)

/// Skips adding the wait to the timer hash, allowing for uniques with variable wait times
var/global/const/TIMER_NO_HASH_WAIT = FLAG(4)


/datum/timer
	var/datum/callback/callback
	var/wait
	var/flags
	var/source
	var/hash
	var/fire_time


SUBSYSTEM_DEF(timer)
	name = "Timer"
	flags = SS_NO_INIT | SS_TICKER
	priority = SS_PRIORITY_TIMER
	wait = 1

	var/list/datum/timer/queue = list()

	var/list/datum/timer/timers_by_hash = list()


/datum/controller/subsystem/timer/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..("Queue: [length(queue)]")


/datum/controller/subsystem/timer/fire(resume, no_mc_tick)
	if (!length(queue))
		return
	var/datum/timer/timer
	var/datum/target
	var/size = length(queue)
	for (var/i = 1 to size)
		timer = queue[i]
		if (world.time < timer.fire_time)
			if (i > 1)
				queue.Cut(1, i)
			return
		target = timer.callback.target
		if (target == GLOBAL_PROC || !QDELETED(target))
			invoke_async(timer.callback)
			if (timer.flags & TIMER_LOOP)
				_addtimer(timer, subsystem = src)
		else if (timer.hash)
			timers_by_hash -= timer.hash
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(1, i + 1)
			return
	queue.Cut(1, size + 1)


/proc/deltimer(datum/timer/timer, datum/controller/subsystem/timer/subsystem = SStimer)
	if (istext(timer))
		timer = subsystem.timers_by_hash[timer]
	if (!timer)
		return
	if (timer.hash)
		subsystem.timers_by_hash -= timer.hash
	subsystem.queue -= timer


/proc/_addtimer(datum/callback/callback, wait, flags, datum/controller/subsystem/timer/subsystem = SStimer, source)
	var/datum/timer/timer = callback
	if (!istype(timer))
		timer = new
		timer.callback = callback
		timer.wait = wait
		timer.flags = flags
		timer.source = source
		if (flags & (TIMER_STOPPABLE | TIMER_UNIQUE))
			var/hash = "[flags][callback.identity]"
			if (!(flags & TIMER_NO_HASH_WAIT))
				hash = "[hash][wait]"
			hash = sha1(hash)
			if (flags & TIMER_UNIQUE)
				var/datum/timer/match = subsystem.timers_by_hash[hash]
				if (match)
					if (!(flags & TIMER_OVERRIDE))
						return
					subsystem.timers_by_hash[hash] = timer
					subsystem.queue -= match
			timer.hash = hash
	timer.fire_time = timer.wait + world.time
	BINARY_INSERT(timer, subsystem.queue, /datum/timer, timer, fire_time, COMPARE_KEY)
	return timer.hash
