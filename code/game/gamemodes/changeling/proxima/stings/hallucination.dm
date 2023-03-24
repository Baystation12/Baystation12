/datum/stings/hallucination
	name = "Hallucination Sting (15)"
	desc = "Sting target"
	icon_state = "sting_lsd"
	chemical_cost = 15
	visible = 0

/datum/stings/hallucination/sting_action(user, mob/living/carbon/T)
	. = ..()
	addtimer(CALLBACK(src, .proc/hallucination_time, T), rand(10 SECONDS, 20 SECONDS))

/datum/stings/hallucination/proc/hallucination_time(mob/living/carbon/T)
	if(T)
		T.hallucination(400, 120)
