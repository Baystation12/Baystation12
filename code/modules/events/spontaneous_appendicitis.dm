/datum/event/spontaneous_appendicitis/start()
	for(var/mob/living/carbon/human/H in shuffle(GLOB.living_mob_list_))
		if(H.client && H.stat != DEAD)
			var/obj/item/organ/internal/appendix/A = H.internal_organs_by_name[BP_APPENDIX]
			if(!istype(A) || (A && A.inflamed))
				continue
			A.inflamed = 1
			ADD_ICON_QUEUE(A)
			break
