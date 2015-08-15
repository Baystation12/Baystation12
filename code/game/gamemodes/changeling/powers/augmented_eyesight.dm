//Augmented Eyesight: Gives you thermal and night vision - bye bye, flashlights. Also, high DNA cost because of how powerful it is.

/datum/power/changeling/augmented_eyesight
	name = "Augmented Eyesight"
	desc = "Creates heat receptors in our eyes and dramatically increases light sensing ability."
	helptext = "Grants us night vision and thermal vision. It may be toggled on or off. We will become more vulnerable to flash-based devices while active."
	genomecost = 2
	var/active = 0 //Whether or not vision is enhanced
	verbpath = /mob/proc/changeling_augmented_eyesight

/mob/proc/changeling_augmented_eyesight()
	set category = "Changeling"
	set name = "Augmented Eyesight (5)"
	set desc = "We evolve our eyes to sense the infrared."

	var/datum/changeling/changeling = changeling_power(5,0,100,CONSCIOUS)
	if(!changeling)
		return 0
	src.mind.changeling.chem_charges -= 5
	src.sight |= SEE_MOBS
	/*
	var/mob/living/carbon/human/C = src

	active = !active
	if(active)
		C << "<span class='notice'>We feel a minute twitch in our eyes, and darkness creeps away.</span>"
		C.sight |= SEE_MOBS
		C.permanent_sight_flags |= SEE_MOBS
		C.see_in_dark = 8
		C.dna.species.invis_sight = SEE_INVISIBLE_MINIMUM
	else
		C << "<span class='notice'>Our vision dulls. Shadows gather.</span>"
		C.sight &= ~SEE_MOBS
		C.permanent_sight_flags &= ~SEE_MOBS
		C.see_in_dark = 0
		C.dna.species.invis_sight = initial(user.dna.species.invis_sight)
	return 1
	*/