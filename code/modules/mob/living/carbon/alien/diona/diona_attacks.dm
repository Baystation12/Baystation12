/mob/living/carbon/alien/diona/MouseDrop(atom/over_object)
	var/mob/living/carbon/H = over_object
	if(!istype(H) || !Adjacent(H)) return ..()
	if(H.a_intent == "help")
		if(H.species && H.species.name == "Diona" && do_merge(H))
			return
		get_scooped(H)
		return
	else
		return ..()
