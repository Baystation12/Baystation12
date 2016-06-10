//Ships are on a time limit as far as being around goes.
//They are ALSO the only ones that can appear after round start
/datum/trader/ship
	var/duration_of_stay = 0
	var/typical_duration = 20 //20 minutes (since trader processes only tick once a minute)

/datum/trader/ship/New()
	..()
	duration_of_stay = rand(typical_duration,typical_duration * 2)

/datum/trader/ship/tick()
	..()
	return --duration_of_stay > 0