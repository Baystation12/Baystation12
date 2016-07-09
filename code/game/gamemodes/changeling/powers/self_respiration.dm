/datum/power/changeling/self_respiration
	name = "Self Respiration"
	desc = "We evolve our body to no longer require drawing oxygen from the atmosphere."
	helptext = "We will no longer require internals, and we cannot inhale any gas, including harmful ones."
	genomecost = 0
	verbpath = /mob/proc/changeling_self_respiration

//No breathing required
/mob/proc/changeling_self_respiration()
	set category = "Changeling"
	set name = "Toggle Breathing"
	set desc = "We choose whether or not to breathe."

	var/datum/changeling/changeling = changeling_power(0,0,100,UNCONSCIOUS)
	if(!changeling)
		return 0

	if(istype(src,/mob/living/carbon))
		var/mob/living/carbon/C = src
		C.does_not_breathe = !C.does_not_breathe

		if(C.does_not_breathe)
			src << "<span class='notice'>We stop breathing, as we no longer need to.</span>"
		else
			src << "<span class='notice'>We resume breathing, as we now need to again.</span>"

		return 1
	return 0
