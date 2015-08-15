/datum/power/changeling/deaf_sting
	name = "Deaf Sting"
	desc = "We silently sting a human, completely deafening them for a short time."
	genomecost = 1
	allowduringlesserform = 1
	verbpath = /mob/proc/changeling_deaf_sting


/mob/proc/changeling_deaf_sting()
	set category = "Changeling"
	set name = "Deaf sting (5)"
	set desc="Sting target:"

	var/mob/living/carbon/T = changeling_sting(5,/mob/proc/changeling_deaf_sting)
	if(!T)	return 0
	T << "<span class='danger'>Your ears pop and begin ringing loudly!</span>"
	T.sdisabilities |= DEAF
	spawn(300)	T.sdisabilities &= ~DEAF
	feedback_add_details("changeling_powers","DS")
	return 1