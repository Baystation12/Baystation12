
/datum/faction/npc/gao_republic
	name = "Reublic of Gao"
	enemy_factions = list("UNSC","ONI")
	blurb = "While Gao is an incredibly bio diverse place, with plenty of unique creatures, such as great apes and snails with no \
	shells, a functioning government is still operational, and democracy is still maintained, ran by a Cabinet of Ministers and an \
	elected president. One would consider this to be the perfect UEG world, but this isn't quite the case. The Gao Charter declares \
	their sovereignty, and requires all members of government to oppose anyone who would dare impeach their freedom. Their primary \
	tactics and doctorine focus stealth, infiltration and sabotage, which has won them many \"battles\" in the past without having to \
	fire a single bullet, instead burning the supplies of their enemies and forcing them to starve or surrender. They have tried on \
	a few occasions to justify conflict against the UNSC, with little success. Despite this, they remain one of the most technologically \
	advanced competitors to the UNSC, and maintain public support for the Insurrection movement. Their supplies are invaluable to the \
	insurrection, and assist wherever they can through their agents in the Ministry of Protection. Democracy may slow their action, \
	but they will never stop until the UNSC submits to the freedom fighters they support."
	defender_mob_types = list(/mob/living/simple_animal/hostile/innie/black = 1,\
		/mob/living/simple_animal/hostile/innie/medium/black = 2,\
		/mob/living/simple_animal/hostile/innie/heavy/black = 1)

/datum/faction/npc/gao_republic/New()
	. = ..()
	leader_name = "War Minister [leader_name]"
