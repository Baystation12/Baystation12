#define CLEAR_OBJECT(TARGET)                \
	processing -= TARGET;                   \
	TARGET.airflow_dest = null;             \
	TARGET.airflow_speed = 0;               \
	TARGET.airflow_time = 0;                \
	TARGET.airflow_skip_speedcheck = FALSE; \
	if (TARGET.airflow_od) {                \
		TARGET.density = 0;                 \
	}

PROCESSING_SUBSYSTEM_DEF(airflow)
	name = "Airflow"
	wait = 1
	flags = SS_NO_INIT
	priority = SS_PRIORITY_AIRFLOW


/datum/controller/subsystem/processing/airflow/fire(resumed = FALSE)
	if (!resumed)
		current_run = processing.Copy()	// Defined in parent.

	var/list/curr = current_run	// Defined in parent.

	while (curr.len)
		var/atom/movable/target = curr[curr.len]
		curr.len--

		if (target.airflow_speed <= 0)
			CLEAR_OBJECT(target)
			if (MC_TICK_CHECK)
				return
			continue

		if (target.airflow_process_delay > 0)
			target.airflow_process_delay -= 1
			if (MC_TICK_CHECK)
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
						target.density = 0
					target.airflow_skip_speedcheck = TRUE

					if (MC_TICK_CHECK)
						return
					continue
			else
				if (target.airflow_od)
					target.density = 0
				target.airflow_process_delay = max(1, 10 - (target.airflow_speed + 3))
				target.airflow_skip_speedcheck = TRUE

				if (MC_TICK_CHECK)
					return
				continue

		target.airflow_skip_speedcheck = FALSE

		if (target.airflow_od)
			target.density = 1

		if (!target.airflow_dest || target.loc == target.airflow_dest)
			target.airflow_dest = locate(min(max(target.x + target.airflow_xo, 1), world.maxx), min(max(target.y + target.airflow_yo, 1), world.maxy), target.z)

		if ((target.x == 1) || (target.x == world.maxx) || (target.y == 1) || (target.y == world.maxy))
			CLEAR_OBJECT(target)
			if (MC_TICK_CHECK)
				return
			continue

		if (!isturf(target.loc))
			CLEAR_OBJECT(target)
			if (MC_TICK_CHECK)
				return
			continue
		
		step_towards(target, target.airflow_dest)
		if (ismob(target) && target:client)
			target:setMoveCooldown(vsc.airflow_mob_slowdown)

		if (MC_TICK_CHECK)
			return

#undef CLEAR_OBJECT		

/atom/movable
	var/tmp/airflow_xo
	var/tmp/airflow_yo
	var/tmp/airflow_od
	var/tmp/airflow_process_delay
	var/tmp/airflow_skip_speedcheck

/atom/movable/proc/prepare_airflow(n)
	if (!airflow_dest || airflow_speed < 0 || last_airflow > world.time - vsc.airflow_delay)
		return FALSE
	if (airflow_speed)
		airflow_speed = n / max(get_dist(src, airflow_dest), 1)
		return FALSE

	if (airflow_dest == loc)
		step_away(src, loc)

	if (!src.AirflowCanMove(n))
		return FALSE

	if (ismob(src))
		to_chat(src,"<span class='danger'>You are pushed away by airflow!</span>")

	last_airflow = world.time
	var/airflow_falloff = 9 - sqrt((x - airflow_dest.x) ** 2 + (y - airflow_dest.y) ** 2)

	if (airflow_falloff < 1)
		airflow_dest = null
		return FALSE
	
	airflow_speed = min(max(n * (9 / airflow_falloff), 1), 9)	
	
	airflow_od = 0

	if (!density)
		density = 1
		airflow_od = 1

	return TRUE

/atom/movable/proc/GotoAirflowDest(n)
	if (!prepare_airflow(n))
		return

	airflow_xo = airflow_dest.x - src.x
	airflow_yo = airflow_dest.y - src.y

	airflow_dest = null

	SSairflow.processing += src

/atom/movable/proc/RepelAirflowDest(n)
	if (!prepare_airflow(n))
		return
	
	airflow_xo = -(airflow_dest.x - src.x)
	airflow_yo = -(airflow_dest.y - src.y)

	airflow_dest = null

	SSairflow.processing += src
