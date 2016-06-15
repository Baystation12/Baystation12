/datum/cloaking
	var/max_alpha_reduction
	var/current_alpha_reduction
	var/min_alpha_level
	var/alpha_penalty_per_move
	var/alpha_per_second
	var/atom/target

/datum/cloaking/New(var/max_alpha_reduction = 315, var/min_alpha_level = 0, var/alpha_per_second = 2, var/alpha_penalty_per_move = 8)
	src.min_alpha_level = min_alpha_level
	src.max_alpha_reduction = max_alpha_reduction

	src.alpha_per_second = alpha_per_second
	src.alpha_penalty_per_move = alpha_penalty_per_move
	..()

/datum/cloaking/Destroy()
	unregister_target(target)
	. = ..()

/datum/cloaking/proc/process()
	if(!target)
		processing_objects -= src
		return
	current_alpha_reduction = min(max_alpha_reduction, current_alpha_reduction + alpha_per_second * process_schedule_interval("datum"))
	update_alpha()

/datum/cloaking/proc/on_move()
	if(!target)
		return
	current_alpha_reduction -= alpha_penalty_per_move * min(1, target.get_luminosity())
	update_alpha()

/datum/cloaking/proc/update_alpha()
	target.alpha = max(min_alpha_level, 255 - current_alpha_reduction)
	var/initial_alpha = initial(target.invisibility)
	if(target.alpha)
		target.invisibility = initial_alpha
	else
		target.invisibility = max(INVISIBILITY_LEVEL_TWO, initial_alpha)

/datum/cloaking/proc/register_target(var/atom/target)
	if(src.target == target)
		return
	if(!istype(target))
		CRASH("Unhandled type: [target ? "target.type" : "NULL"]")
	if(src.target)
		unregister_target()
	src.target = target
	moved_event.register(target, src, /datum/cloaking/proc/on_move)
	destroyed_event.register(target, src, /datum/cloaking/proc/unregister_target)
	processing_objects += src

/datum/cloaking/proc/unregister_target(var/atom/target)
	if(src.target != target)
		return
	processing_objects -= src
	moved_event.unregister(target, src, /datum/cloaking/proc/on_move)
	destroyed_event.unregister(target, src, /datum/cloaking/proc/unregister_target)
	current_alpha_reduction = 0
	src.target.alpha = initial(target.alpha)
	src.target = null
