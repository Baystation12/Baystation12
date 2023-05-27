/singleton/hierarchy/skill/organizational/bureaucracy/update_special_effects(mob/mob, level)
	. = ..()
	mob.remove_language(LANGUAGE_LEGALESE)
	if(level == SKILL_MASTER)
		if(ishuman(mob))
			var/mob/living/carbon/human/H = mob
			if(istype(H.species, /datum/species/human))
				H.add_language(LANGUAGE_LEGALESE)
