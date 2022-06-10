/datum/state_machine/weather
	expected_type = /obj/abstract/weather_system

/datum/state_machine/weather/choose_transition(list/valid_transitions)
	var/list/transitions = list()
	for(var/decl/state_transition/weather/state_transition in valid_transitions)
		transitions[state_transition] = state_transition.likelihood_weighting
	if(length(transitions))
		return pick(transitions) //pickweight(transitions)
	return ..()
