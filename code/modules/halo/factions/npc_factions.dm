
/datum/faction/npc
	max_npc_quests = 4
	defender_mob_types = list(/mob/living/simple_animal/hostile/defender_mob/innie/medium = 3, /mob/living/simple_animal/hostile/defender_mob/innie/heavy)

/datum/faction/npc/New()
	. = ..()
	GLOB.npc_factions.Add(src)
	GLOB.innie_factions.Add(src)
	GLOB.innie_factions_by_name[name] = src

/datum/faction/npc/Initialize()
	start_processing()
	generate_quest()

/datum/faction/npc/khoros_desert_raiders
	name = "Khoros Desert Raiders"
	enemy_factions = list("UNSC","ONI")
	blurb = "Deserts are a vast and empty place. The rich don't understand the appeals of living in a place so lifeless, \
		and the poor fear a land so hospitable, cruel and indifferent. Many are lost in deserts, forgotten to the vast \
		sands of time, only those who leave their marks on the land are ever remembered, atleast more so then simple \
		skeletal remains. In such a cruel land, only the strongest can survive, and the weak will perish. Such philosophy \
		embodies the Khoros Desert Raiders, who chose to operate outside the walls of Talista's capital and instead make \
		their home on the moon's many mountains. Raids are constant, and most who venture outside of the safe walls never \
		return. And for what purpose? Many claim they need the supplies, but in reality, they do it to prove their strength, \
		and to satisfy their passion for battle. Justifying their violent tendencies like a simple hobby, they are resolute \
		in proving their strength and satisfying their desire for war. Despite the might of the UNSC, they dare not step \
		under the shadow of the mountains or head out to rescue a dammed trading convoy. After all, only the strong can rule \
		over the weak. "

/datum/faction/npc/olympus_council
	name = "Olympus Council"
	enemy_factions = list("UNSC","ONI")
	blurb = "Not much is known about the Olympus Council from the outside. Most people will have never heard of them, and the \
		majority that have some knowledge of what the council is, will assume they are the collective 15 owners of Adept Robotics. \
		While this is technically true, they are not just the creators of AI ran machines and human piloted drones. Beneath \
		most of their factories, they practise their less then legal methods. Their factories are simply disguises for humanities \
		biggest unregulated black market, and this woulldn't be possible without Tradestar. While on the surface, Tradestar is \
		their main competitor, the council of 15 is comprised of 5 Tradestar members, who specialise in helping pioneer laser \
		and electrical energy use. With both of their collective wealth and skills, both experimental electric powered weapons \
		and fully functional machines of war were created, and without any legal barriers, they quickly overwhelmed the \
		criminal underworld with their influence, many desperate to get into their illusive black market. There is nothing \
		the council won't do to maintain their secrecy and profits. Once you enter their factory, the council will decide your fate... "

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

/datum/faction/random_criminal/New()
	name = "[random_syndicate_name()] (criminals)"
	GLOB.criminal_factions.Add(src)
	GLOB.criminal_factions_by_name[name] = src

	. = ..()

	switch(pick(1,2,3))
		if(1)
			defender_mob_types = list(\
				/mob/living/simple_animal/hostile/russian = 3,\
				/mob/living/simple_animal/hostile/russian/ranged,\
				/mob/living/simple_animal/hostile/bear = 2)
		if(2)
			defender_mob_types = list(\
				/mob/living/simple_animal/hostile/pirate = 3,\
				/mob/living/simple_animal/hostile/pirate/ranged,\
				/mob/living/simple_animal/hostile/carp = 2)
		if(3)
			defender_mob_types = list(\
				/mob/living/simple_animal/hostile/syndicate = 3,\
				/mob/living/simple_animal/hostile/syndicate/melee = 2,\
				/mob/living/simple_animal/hostile/syndicate/melee/space = 2,\
				/mob/living/simple_animal/hostile/syndicate/ranged = 1,\
				/mob/living/simple_animal/hostile/syndicate/ranged/space = 1)
