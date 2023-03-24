/mob/living/carbon/MiddleClickOn(atom/A)
	if(!stat && mind && iscarbon(A) && A != src)
		var/datum/changeling/C = mind.changeling
		if(C?.chosen_sting)
			C.chosen_sting.try_to_sting(src, A)
			next_click = world.time + 2 SECONDS
			return
	..()

/mob/living/carbon/AltClickOn(atom/A)
	if(!stat && mind && iscarbon(A) && A != src)
		var/datum/changeling/C = mind.changeling
		if(C?.chosen_sting)
			C.chosen_sting.try_to_sting(src,A)
			next_click = world.time + 2 SECONDS
			return
	..()
