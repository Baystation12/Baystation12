/datum/power/changeling/endoarmor
	name = "Endoarmor"
	desc = "We grow hard plating underneath our skin, making us more resilient to harm by increasing our maximum health potential by 50 points."
	helptext = "Our maximum health is increased to 150 health."
	genomecost = 1
	isVerb = 0
	verbpath = /mob/proc/changeling_endoarmor

//Increases macimum chemical storage
/mob/proc/changeling_endoarmor()
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		H.maxHealth += 50
	return 1