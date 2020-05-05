
/datum/event/ship/grid_check
	title = "Automated Grid Check"
	custom_sound = 'sound/AI/poweroff.ogg'
	var/list/candidate_apcs = list()
	var/obj/machinery/power/apc/current_apc
	var/cycle_next_apc = 0
	var/cycle_duration = 15
	startWhen = 4
	endWhen = 999999		//symbolic number so we can control our own timing

/datum/event/ship/grid_check/setup()
	. = ..()

	//get a list of candidate machines
	for(var/cur_area_type in typesof(target_ship.parent_area_type))
		var/area/cur_area = locate(cur_area_type)
		if(cur_area)
			var/obj/machinery/power/apc/C = locate() in cur_area
			if(C)
				candidate_apcs.Add(C)

	if(severity == EVENT_LEVEL_MUNDANE)
		//only do 1 APC
		candidate_apcs = list(pick(candidate_apcs))

		//last a little bit longer
		cycle_duration += cycle_duration * rand(0.5, 1.5)

		announce_message = "Abnormal activity detected in the [current_apc] aboard [target_ship]. \
			As a precaution, power must be shut down for an indefinite duration."
	else
		announce_message = "Abnormal activity detected in the [target_ship] power system. \
			As a precaution, power must be shut down in a series of rolling blackouts."

/datum/event/ship/grid_check/tick()
	//dont end yet
	endWhen++

	if(world.time >= cycle_next_apc)

		//reset the timer
		cycle_next_apc = world.time + cycle_duration SECONDS

		if(candidate_apcs.len)

			//pick the next APC victim
			var/index = rand(1,candidate_apcs.len)
			current_apc = candidate_apcs[index]
			if(!current_apc)
				//oops this one got deleted after the event started
				candidate_apcs.Cut(index, index + 1)

				//pick another one next tick
				cycle_next_apc = 0
			else
				//dont do this one again
				candidate_apcs -= current_apc

				//blue screen of death
				current_apc.energy_fail(cycle_duration)

		else
			//finish here
			endWhen = activeFor

/datum/event/ship/grid_check/end()
	affected_faction.AnnounceUpdate("Affected APCs on the [target_ship] have been restarted. \
		We apologize for the inconvenience.", "Power distribution optimal", 'sound/AI/poweron.ogg')
