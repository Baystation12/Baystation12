/datum/power/changeling/darksight
	name = "Dark Sight"
	desc = "We change the composition of our eyes, banishing the shadows from our vision."
	helptext = "We will be able to see in the dark."
	ability_icon_state = "ling_augmented_eyesight"
	genomecost = 0
	power_category = CHANGELING_POWER_INHERENT
	verbpath = /mob/proc/changeling_darksight

/mob/proc/changeling_darksight()
	set category = "Changeling"
	set name = "Toggle Darkvision"
	set desc = "We are able see in the dark."

	var/datum/changeling/changeling = changeling_power(0,0,100,UNCONSCIOUS)
	if(!changeling)
		return 0

	if(istype(src,/mob/living/carbon))
		var/mob/living/carbon/C = src
		//disables thermals if we have it to prevent permanent double stacking
		src.sight &= ~(SEE_MOBS)
		if(C.seedarkness)
			to_chat(C, SPAN_NOTICE("We no longer need light to see."))
			C.seedarkness = 0
		else
			to_chat(C, SPAN_NOTICE("We allow the shadows to return."))
			C.seedarkness = 1

	return 0
