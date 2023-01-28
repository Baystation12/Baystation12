/datum/power/changeling/self_respiration
	name = "Self Respiration"
	desc = "We evolve our body to no longer require drawing oxygen from the atmosphere."
	helptext = "We will no longer require internals, and we cannot inhale any gas, including harmful ones."
	ability_icon_state = "ling_toggle_breath"
	genomecost = 0
	verbpath = /mob/proc/changeling_self_respiration

//No breathing required
/mob/proc/changeling_self_respiration()
	set category = "Changeling"
	set name = "Activate Internal Air Sacs"
	set desc = "We choose whether or not to breathe."

	var/datum/changeling/changeling = changeling_power(0,0,100,UNCONSCIOUS)
	if(!changeling)
		return FALSE

	if(istype(src,/mob/living/carbon))
		var/mob/living/carbon/C = src
		if(C.does_not_breathe == 0)
			C.does_not_breathe = 1
			to_chat(src, "<span class='notice'>We stop breathing, as we no longer need to.</span>")
			return TRUE
		else
			C.does_not_breathe = 0
			to_chat(src, "<span class='notice'>We resume breathing, as we now need to again.</span>")
	return FALSE
