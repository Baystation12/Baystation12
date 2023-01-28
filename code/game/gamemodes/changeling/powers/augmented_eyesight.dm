//Augmented Eyesight: Gives you thermal vision. Also, higher DNA cost because of how powerful it is.

/datum/power/changeling/augmented_eyesight
	name = "Augmented Eyesight"
	desc = "Allows for extra sensory information in the eyes, increasing photon reception capabilities for a short span of time."
	helptext = "Grants us temporary thermal vision, allowing us to track organics beyond walls."
	ability_icon_state = "ling_augmented_eyesight"
	genomecost = 2
	verbpath = /mob/proc/changeling_augmented_eyesight

/mob/proc/changeling_augmented_eyesight()
	set category = "Changeling"
	set name = "Augmented Eyesight (5)"
	set desc = "We evolve our eyes to sense the infrared temporarily."

	var/datum/changeling/changeling = changeling_power(5,0,100,CONSCIOUS)
	if(!changeling)
		return FALSE

	var/mob/living/carbon/human/C = src

	changeling.thermal_sight = !changeling.thermal_sight

	var/active = changeling.thermal_sight

	if(active)
		src.mind.changeling.chem_charges -= 5
		to_chat(C, SPAN_NOTICE("We feel a minute twitch in our eyes, and a hidden layer to the world is revealed.</span>"))
		C.set_sight(C.sight | SEE_MOBS)
	return TRUE
