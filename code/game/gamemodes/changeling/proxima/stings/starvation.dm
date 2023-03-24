/datum/stings/starvation
	name = "Starvation Sting (10)"
	desc = "Sting target"
	icon_state = "sting_starvation"
	chemical_cost = 10
	visible = 0

/datum/stings/starvation/sting_action(user, mob/living/carbon/T)
	. = ..()
	addtimer(CALLBACK(src, .proc/starve, T), rand(10 SECONDS, 20 SECONDS))

/datum/stings/starvation/proc/starve(mob/living/carbon/T)
	if(T)
		T.nutrition -= rand(100, 200)
		T.hydration -= rand(100, 200)
