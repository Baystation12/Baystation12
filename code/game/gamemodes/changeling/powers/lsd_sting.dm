//This only exists to be abused, so it's highly recommended to ensure this file is unchecked.
/datum/power/changeling/LSDSting
	name = "Hallucination Sting"
	desc = "We evolve the ability to sting a target with a powerful hallunicationary chemical."
	helptext = "The target does not notice they have been stung.  The effect occurs after 30 to 60 seconds."
	genomecost = 1
	verbpath = /mob/proc/changeling_lsdsting
	sting_effect = /mob/proc/ling_lsd
	is_sting = TRUE
	sting_duration = 400
/mob/proc/time_lsd(T)
	if(T)
		ling_lsd(T,400)
/mob/proc/ling_lsd(mob/living/carbon/M, duration)
	M.hallucination(duration,80)
/mob/proc/changeling_lsdsting()
	set category = "Changeling"
	set name = "Hallucination Sting (15)"
	set desc = "Causes terror in the target."

	var/mob/living/carbon/T = changeling_sting(15,/mob/proc/changeling_lsdsting)
	if(!T)	return FALSE
	admin_attack_log(src,T,"Hallucination sting (changeling)")
	addtimer(new Callback(T,/mob/.proc/time_lsd), 400)

	return TRUE
