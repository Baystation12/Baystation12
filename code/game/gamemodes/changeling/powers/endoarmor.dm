/datum/power/changeling/endoarmor
	name = "Endoarmor"
	desc = "We grow hard plating underneath our skin, making us more resilient to harm by increasing our maximum health potential by 50 points."
	helptext = "Our maximum health is increased by 50 points."
	genomecost = 1
	isVerb = 0
	verbpath = /mob/proc/changeling_endoarmor

/datum/modifier/endoarmor
	name = "endoarmor"
	desc = "We have hard plating underneath our skin, making us more durable."

	on_created_text = "<span class='notice'>We feel protective plating form underneath our skin.</span>"
	on_expired_text = "<span class='notice'>Our protective armor underneath our skin fades as we absorb it.</span>"
	max_health_flat = 50

/mob/proc/changeling_endoarmor()
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		H.add_modifier(/datum/modifier/endoarmor)
	//	H.maxHealth += 50
	return TRUE
