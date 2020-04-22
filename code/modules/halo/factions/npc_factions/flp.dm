
/datum/faction/npc/freedom_liberation_party
	name = "Freedom and Liberation Party"
	enemy_factions = list("UNSC","ONI")
	blurb = "The Freedom and Liberation Party (FLP) is an insurrectionist group based in the Eridanus sector, but with strong ties \
	to the planet Mamore. In 2511, they detonated a nuclear device near one of Mamore's landmarks, killing 2 million and injuring \
	8 million more. Many have suspected to have died of radiation based illnesses, such as cancer, much later after the attacking, \
	making the death toll given a vast understatement. They wish for the Colonial Millitary Administration (and by extension, the \
	UNSC) to leave the Eridanus system, their proud home. To them, their home is simply not the same under the control of the filth \
	that is the UEG. the UEG don't deserve the worlds they subjugate, and the FLP would rather see their homeworld in a blazing \
	inferno rather then owned by the \"Cancer of the Colonies\". If the people don't own it, no one should. They will stop at nothing \
	to achieve their goals. After all, a million deaths is just a statistic. "
	defender_mob_types = list(/mob/living/simple_animal/hostile/innie/blue = 1,\
		/mob/living/simple_animal/hostile/innie/medium/blue = 2,\
		/mob/living/simple_animal/hostile/innie/heavy/blue = 1)

/datum/faction/npc/freedom_liberation_party/New()
	. = ..()
	leader_name = "General [leader_name]"
