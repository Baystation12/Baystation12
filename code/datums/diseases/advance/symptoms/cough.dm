/*
//////////////////////////////////////

Coughing

	Noticable.
	No Resistance.
	Doesn't increase stage speed.
	Transmittable.
	Low Level.

BONUS
	Will force the affected mob to drop items!

//////////////////////////////////////
*/

/datum/symptom/cough

	name = "Cough"
	stealth = -1
	resistance = 0
	stage_speed = 0
	transmittable = 2
	level = 1

/datum/symptom/cough/Activate(var/datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/M = A.affected_mob
		switch(A.stage)
			if(1, 2, 3)
				M << "<span notice='notice'>[pick("You swallow excess mucus.", "You lightly cough.")]</span>"
			else
				M.emote("cough")
				M.drop_item()
	return