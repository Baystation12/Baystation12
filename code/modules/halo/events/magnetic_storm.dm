GLOBAL_LIST_EMPTY(emp_candidates)

/datum/event/magnetic_storm
	endWhen = 60
	var/list/emp_victims = list()

/datum/event/magnetic_storm/announce()
	command_announcement.Announce("Magnetic turbulence detected in proximity to [system_name()]. Monitor all electronic equipment in case of failure.", "Magnetic Turbulence Detected", new_sound = 'sound/AI/ionstorm.ogg')

/datum/event/magnetic_storm/tick()

	//do a bunch of machines at once
	for(var/i=0,i<20,i++)
		do_emp()

/datum/event/magnetic_storm/proc/do_emp()
	if(GLOB.emp_candidates.len)
		//grab a random EMP target
		var/index = rand(1, GLOB.emp_candidates.len)
		var/atom/victim = GLOB.emp_candidates[index]
		if(victim)
			//only do it once this round
			GLOB.emp_candidates -= victim
			emp_victims += victim
			victim.emp_act(severity)
		else
			//clear out null values
			GLOB.emp_candidates.Cut(index, index + 1)
	else
		//reset the list of possible targets
		GLOB.emp_candidates = emp_victims
		emp_victims = list()

/datum/event/magnetic_storm/end()
	//reset the list of possible targets
	GLOB.emp_candidates += emp_victims
