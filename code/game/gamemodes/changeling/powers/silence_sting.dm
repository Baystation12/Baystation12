/datum/power/changeling/silence_sting
	name = "Silence Sting"
	desc = "We silently sting a human, completely silencing them for a short time."
	helptext = "Does not provide a warning to a victim that they have been stung, until they try to speak and cannot."
	genomecost = 2
	allowduringlesserform = 1
	verbpath = /mob/proc/changeling_silence_sting

/mob/proc/changeling_silence_sting()
	set category = "Changeling"
	set name = "Silence sting (10)"
	set desc="Sting target"

	var/mob/living/carbon/T = changeling_sting(10,/mob/proc/changeling_silence_sting)
	if(!T)	return 0
	T.silent += 30
	feedback_add_details("changeling_powers","SS")
	return 1