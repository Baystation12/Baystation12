//Augmented Eyesight: Gives you thermal vision. Also, higher DNA cost because of how powerful it is.
//needs to be fixed to act per tick, polaris port didn't work in that respect

/datum/power/changeling/augmented_eyesight
	name = "Augmented Eyesight"
	desc = "Allows for extra sensory information in the eyes, increasing photon reception capabilities for a short span of time."
	helptext = "Grants us temporary thermal vision, allowing us to track organics beyond walls."
	ability_icon_state = "ling_augmented_eyesight"
	genomecost = 2
	verbpath = /mob/proc/changeling_augmented_eyesight

/mob/proc/changeling_augmented_eyesight()
	set category = "Changeling"
	set name = "Augmented Eyesight (3 per tick)"
	set desc = "We evolve our eyes to sense the infrared temporarily."

	var/datum/changeling/changeling = changeling_power(3,0,100,CONSCIOUS)
	var/mob/living/carbon/human/H = src
	var/obj/item/organ/external/parent = H.get_organ(BP_HEAD)
	var/has_organ = FALSE;
	for(var/obj/item/organ/internal/augment/ling_lenses/eyes in H.internal_organs)
		has_organ++
	if(!changeling)
		return FALSE
	if(!has_organ)
		var/obj/item/organ/internal/augment/eyes = new /obj/item/organ/internal/augment/ling_lenses
		eyes.forceMove(src)
		eyes.replaced(src, parent)
		eyes = null
		has_organ++
	if(has_organ)
		if(H.seedarkness)
			H.seedarkness = FALSE
		for(var/obj/item/organ/internal/augment/ling_lenses/eyes in H.internal_organs)
			if(!eyes.is_active)
				to_chat(src, SPAN_NOTICE("We feel a minute twitch in our eyes, and a hidden layer to the world is revealed."))
				eyes.is_active = TRUE
			else
				to_chat(src,SPAN_NOTICE("Our lenses retract, causing us to lose our augmented vision."))
				eyes.is_active = FALSE
	changeling.chem_charges -= 5
	return TRUE
