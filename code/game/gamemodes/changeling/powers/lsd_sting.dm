//This only exists to be abused, so it's highly recommended to ensure this file is unchecked.
/datum/power/changeling/LSDSting
	name = "Hallucination Sting"
	desc = "We evolve the ability to sting a target with a powerful hallunicationary chemical."
	helptext = "The target does not notice they have been stung.  The effect occurs after 30 to 60 seconds."
	genomecost = 3
	verbpath = /mob/proc/changeling_lsdsting

/mob/proc/changeling_lsdsting()
	set category = "Changeling"
	set name = "Hallucination Sting (15)"
	set desc = "Causes terror in the target."

	var/mob/living/carbon/T = changeling_sting(15,/mob/proc/changeling_lsdsting)
	if(!T)	return 0
	spawn(rand(300,600))
		if(T)	T.hallucination += 400
	feedback_add_details("changeling_powers","HS")
	return 1