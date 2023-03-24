/datum/stings/blind
	name = "Blind Sting (20)"
	desc = "Sting target"
	icon_state = "sting_blind"
	chemical_cost = 20
	visible = 0 //because eyes are burning - it is hard to notice a tiny prick in such moment

/datum/stings/blind/sting_action(mob/user, mob/living/T)
	. = ..()
	to_chat(T, SPAN_DANGER("Your eyes burn horrificly!"))
	T.disabilities |= NEARSIGHTED
	addtimer(CALLBACK(src, .proc/mend_eyes, T), 40 SECONDS)
	T.eye_blind = 10
	T.eye_blurry = 20

/datum/stings/blind/proc/mend_eyes(mob/living/T)
	if(T)
		T.disabilities &= ~NEARSIGHTED
