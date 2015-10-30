/datum/power/changeling/self_respiration
	name = "Self Respiration"
	desc = "We evolve our body to no longer require drawing oxygen from the atmosphere.."
	helptext = "We will no longer require internals, and we cannot inhale any gas, including harmful ones."
	genomecost = 1
	isVerb = 0
	verbpath = /mob/proc/changeling_self_respiration

//No breathing required
/mob/proc/changeling_self_respiration()
	if(istype(src,/mob/living/carbon))
		var/mob/living/carbon/C = src
		C.does_not_breathe = 1
		src << "<span class='notice'>We stop breathing, as we no longer need to.</span>"
		return 1
	return 0