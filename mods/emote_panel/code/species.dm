/datum/species/proc/hug(mob/living/carbon/human/H, mob/living/target)

	var/t_him = "them"
	var/obj/item/organ/external/affecting
	if(ishuman(target))
		var/mob/living/carbon/human/T = target
		affecting = T.get_organ(H.zone_sel.selecting)
		switch(target.gender)
			if(MALE)
				t_him = "him"
			if(FEMALE)
				t_him = "her"
	if(H.zone_sel.selecting == "head")
		H.visible_message( \
			"<span class='notice'>[H] pats [target] on the head.</span>", \
			"<span class='notice'>You pat [target] on the head.</span>", )
	else if((H.zone_sel.selecting == "r_hand" || H.zone_sel.selecting == "l_hand") && (affecting && !affecting.is_stump()))
		H.visible_message( \
			"<span class='notice'>[H] shakes [target]'s hand.</span>", \
			"<span class='notice'>You shake [target]'s hand.</span>", )
	else H.visible_message("<span class='notice'>[H] hugs [target] to make [t_him] feel better!</span>", \
				"<span class='notice'>You hug [target] to make [t_him] feel better!</span>")

	if(H != target)
		H.update_personal_goal(/datum/goal/achievement/givehug, TRUE)
		target.update_personal_goal(/datum/goal/achievement/gethug, TRUE)
