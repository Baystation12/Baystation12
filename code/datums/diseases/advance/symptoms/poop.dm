/*
//////////////////////////////////////

Diarrhea

	Very Very Noticable.
	Decreases resistance.
	Doesn't increase stage speed.
	Little transmittable.
	Intense Level.

Bonus
	Forces the affected mob to shit their pants!
	Meaning your disease can spread via
	people walking on the poop.
	Makes the affected mob lose nutrition and
	heal toxin damage.

//////////////////////////////////////
*/

/datum/symptom/poop

	name = "Diarrhea"
	stealth = -2
	resistance = -1
	stage_speed = 0
	transmittable = 1
	level = 3

/datum/symptom/poop/Activate(var/datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB / 2))
		var/mob/living/M = A.affected_mob
		switch(A.stage)
			if(1, 2, 3, 4)
				M << "<span class='notice'>[pick("Your stomach rumbles strangely.", "You feel like you're going shit your pants any second now!")]</span>"
			else
				Poop(M)

	return

/datum/symptom/poop/proc/Poop(var/mob/living/M)

	M.visible_message("<B>[M]</B> has explosive diarrhea all over the floor!")

	M.nutrition -= 20
	M.adjustToxLoss(-3)

	var/turf/pos = get_turf(M)
	pos.add_poop_floor(M)
	playsound(pos, 'sound/effects/splat.ogg', 50, 1)