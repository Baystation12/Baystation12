/datum/stings/deaf
	name = "Deaf Sting (20)"
	desc = "Sting target"
	icon_state = "sting_deaf"
	chemical_cost = 20
	no_lesser = 0

/datum/stings/deaf/sting_action(mob/user, mob/living/T)
	. = ..()
	to_chat(T, SPAN_DANGER("Your ears pop and begin ringing loudly!"))
	T.sdisabilities |= DEAFENED
	addtimer(CALLBACK(src, .proc/undeaf, T), rand(40 SECONDS, 60 SECONDS))

/datum/stings/deaf/proc/undeaf(mob/living/T)
	if(T)
		T.sdisabilities &= ~DEAFENED
