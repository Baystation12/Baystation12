
/datum/faction/npc/olympus_council
	name = "Olympus Council"
	enemy_faction_names = list("UNSC","ONI")
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
	defender_mob_types = list(/mob/living/simple_animal/hostile/innie/white = 1,\
		/mob/living/simple_animal/hostile/innie/medium/white = 2,\
		/mob/living/simple_animal/hostile/innie/heavy/white = 1)

/datum/faction/npc/olympus_council/New()
	. = ..()
	leader_name = "Councillor [leader_name]"
