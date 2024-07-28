#define CLEAR_OBJECT(TARGET) \
	movables -= TARGET; \
	TARGET.airflow_dest = null; \
	TARGET.airflow_speed = 0; \
	TARGET.airflow_time = 0; \
	TARGET.airflow_skip_speedcheck = FALSE; \
	if (TARGET.airflow_od) { \
		TARGET.set_density(FALSE); \
	}


SUBSYSTEM_DEF(airflow)
	name = "Airflow"
	wait = 1
	flags = SS_NO_INIT
	priority = SS_PRIORITY_AIRFLOW

	var/static/list/atom/movable/movables = list()
	var/static/list/atom/movable/queue = list()


/datum/controller/subsystem/airflow/Recover()
	queue.Cut()


/datum/controller/subsystem/airflow/UpdateStat(time)
	return


/datum/controller/subsystem/airflow/fire(resumed, no_mc_tick)
	if (!resumed)
		queue = movables.Copy()
		if (!length(queue))
			return
	var/cut_until = 1
	for (var/atom/movable/target as anything in queue)
		++cut_until
		if (QDELETED(target))
			if (target)
				CLEAR_OBJECT(target)
			if (MC_TICK_CHECK)
				queue.Cut(1, cut_until)
				return
			continue
		if (target.airflow_speed <= 0)
			CLEAR_OBJECT(target)
			if (MC_TICK_CHECK)
				queue.Cut(1, cut_until)
				return
			continue
		if (target.airflow_process_delay > 0)
			target.airflow_process_delay -= 1
			if (MC_TICK_CHECK)
				queue.Cut(1, cut_until)
				return
			continue
		else if (target.airflow_process_delay)
			target.airflow_process_delay = 0
		target.airflow_speed = min(target.airflow_speed, 15)
		target.airflow_speed -= vsc.airflow_speed_decay
		if (!target.airflow_skip_speedcheck)
			if (target.airflow_speed > 7)
				if (target.airflow_time++ >= target.airflow_speed - 7)
					if (target.airflow_od)
						target.set_density(FALSE)
					target.airflow_skip_speedcheck = TRUE
					if (MC_TICK_CHECK)
						queue.Cut(1, cut_until)
						return
					continue
			else
				if (target.airflow_od)
					target.set_density(FALSE)
				target.airflow_process_delay = max(1, 10 - (target.airflow_speed + 3))
				target.airflow_skip_speedcheck = TRUE
				if (MC_TICK_CHECK)
					queue.Cut(1, cut_until)
					return
				continue
		target.airflow_skip_speedcheck = FALSE
		if (target.airflow_od)
			target.set_density(TRUE)
		if (!target.airflow_dest || target.loc == target.airflow_dest)
			target.airflow_dest = locate(min(max(target.x + target.airflow_xo, 1), world.maxx), min(max(target.y + target.airflow_yo, 1), world.maxy), target.z)
		if ((target.x == 1) || (target.x == world.maxx) || (target.y == 1) || (target.y == world.maxy))
			CLEAR_OBJECT(target)
			if (MC_TICK_CHECK)
				queue.Cut(1, cut_until)
				return
			continue
		if (!isturf(target.loc))
			CLEAR_OBJECT(target)
			if (MC_TICK_CHECK)
				queue.Cut(1, cut_until)
				return
			continue
		step_towards(target, target.airflow_dest)
		if (ismob(target))
			var/mob/M = target
			M.SetMoveCooldown(vsc.airflow_mob_slowdown)
		if (MC_TICK_CHECK)
			queue.Cut(1, cut_until)
			return
	queue.Cut()

#undef CLEAR_OBJECT


/datum/controller/subsystem/airflow/StartLoadingMap()
	suspend()


/datum/controller/subsystem/airflow/StopLoadingMap()
	wake()


/atom/movable/var/airflow_xo
/atom/movable/var/airflow_yo
/atom/movable/var/airflow_od
/atom/movable/var/airflow_process_delay
/atom/movable/var/airflow_skip_speedcheck


/atom/movable/proc/prepare_airflow(strength)
	if (!airflow_dest || airflow_speed < 0 || last_airflow > world.time - vsc.airflow_delay)
		return FALSE
	if (airflow_speed)
		airflow_speed = strength / max(get_dist(src, airflow_dest), 1)
		return FALSE
	if (airflow_dest == loc)
		step_away(src, loc)
	if (!AirflowCanMove(strength))
		return FALSE
	if (ismob(src))
		to_chat(src, SPAN_DANGER("You are pushed away by airflow!"))
	last_airflow = world.time
	var/airflow_falloff = 9 - sqrt((x - airflow_dest.x) ** 2 + (y - airflow_dest.y) ** 2)
	if (airflow_falloff < 1)
		airflow_dest = null
		return FALSE
	airflow_speed = min(max(strength * (9 / airflow_falloff), 1), 9)
	airflow_od = FALSE
	if (!density)
		set_density(TRUE)
		airflow_od = TRUE
	return TRUE


/atom/movable/proc/GotoAirflowDest(strength)
	if (!prepare_airflow(strength))
		return
	airflow_xo = airflow_dest.x - x
	airflow_yo = airflow_dest.y - y
	airflow_dest = null
	SSairflow.movables += src


/atom/movable/proc/RepelAirflowDest(strength)
	if (!prepare_airflow(strength))
		return
	airflow_xo = -(airflow_dest.x - x)
	airflow_yo = -(airflow_dest.y - y)
	airflow_dest = null
	SSairflow.movables += src
