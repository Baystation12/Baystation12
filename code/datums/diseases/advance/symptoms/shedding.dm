/*
//////////////////////////////////////
Alopecia

	Noticable.
	Decreases resistance slightly.
	Reduces stage speed slightly.
	Transmittable.
	Intense Level.

BONUS
	Makes the mob lose hair.

//////////////////////////////////////
*/

/datum/symptom/shedding

	name = "Alopecia"
	stealth = -1
	resistance = -1
	stage_speed = -1
	transmittable = 2
	level = 4

/datum/symptom/shedding/Activate(var/datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/M = A.affected_mob
		M << "<span class='notice'>[pick("Your scalp itches.", "Your skin feels flakey.")]</span>"
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			switch(A.stage)
				if(3, 4)
					if(!(H.h_style == "Bald") && !(H.h_style == "Balding Hair"))
						H << "<span class='danger'>Your hair starts to fall out in clumps...</span>"
						spawn(50)
							H.h_style = "Balding Hair"
							H.update_hair()
				if(5)
					if(!(H.f_style == "Shaved") || !(H.h_style == "Bald"))
						H << "<span class='danger'>Your hair starts to fall out in clumps...</span>"
						spawn(50)
							H.f_style = "Shaved"
							H.h_style = "Bald"
							H.update_hair()
	return