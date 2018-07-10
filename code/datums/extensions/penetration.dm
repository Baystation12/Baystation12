/datum/extension/penetration
	expected_type = /atom

// Returns a value between 0 and 100
/datum/extension/penetration/proc/PenetrationProbability(var/base_probability, var/damage, var/damage_type)
	return 100


/datum/extension/penetration/simple
	var/static_probability

/datum/extension/penetration/simple/New(host, static_probability)
	..()
	src.static_probability = static_probability

/datum/extension/penetration/simple/PenetrationProbability()
	return static_probability


/datum/extension/penetration/proc_call
	var/proc_call

/datum/extension/penetration/proc_call/New(host, proc_call)
	..()
	src.proc_call = proc_call

/datum/extension/penetration/proc_call/PenetrationProbability(var/base_probability, var/damage, var/damage_type)
	return call(holder, proc_call)(base_probability, damage, damage_type)
