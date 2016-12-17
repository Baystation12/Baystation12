/datum/technomancer/spell/summon_creature
	name = "Summon Creature"
	desc = "Teleports a specific creature from their current location in the universe to the targeted tile, \
	after a delay. The creature summoned can be chosen by using the ability in your hand. \
	Available creatures are; mice, crabs, parrots, bats, goats, cats, corgis, spiders, and space carp. \
	The creatures take a few moments to be teleported to the targeted tile. Note that the creatures summoned are \
	not inherently loyal to the technomancer, and that the creatures will be hurt slightly from being teleported to you."
	enhancement_desc = "Summoned entities will never harm their summoner."
	cost = 100
	ability_icon_state = "tech_summon"
	obj_path = /obj/item/weapon/spell/summon/summon_creature
	category = UTILITY_SPELLS

/obj/item/weapon/spell/summon/summon_creature
	name = "summon creature"
	desc = "Chitter chitter."
	icon_state = "summon"
	summoned_mob_type = null
	summon_options = list(
		"Mouse"			=	/mob/living/simple_animal/mouse,
		"Lizard"		=	/mob/living/simple_animal/lizard,
		"Chicken"		=	/mob/living/simple_animal/chicken,
		"Chick"			=	/mob/living/simple_animal/chick,
		"Crab"			=	/mob/living/simple_animal/crab,
		"Parrot"		=	/mob/living/simple_animal/parrot,
		"Goat"			=	/mob/living/simple_animal/hostile/retaliate/goat,
		"Cat"			=	/mob/living/simple_animal/cat,
		"Kitten"		=	/mob/living/simple_animal/cat/kitten,
		"Corgi"			=	/mob/living/simple_animal/corgi,
		"Corgi Pup"		=	/mob/living/simple_animal/corgi/puppy,
		"BAT"			=	/mob/living/simple_animal/hostile/scarybat,
		"SPIDER"		=	/mob/living/simple_animal/hostile/giant_spider,
		"SPIDER HUNTER"	=	/mob/living/simple_animal/hostile/giant_spider/hunter,
		"SPIDER NURSE"	=	/mob/living/simple_animal/hostile/giant_spider/nurse,
		"CARP"			=	/mob/living/simple_animal/hostile/carp,
		"BEAR"			=	/mob/living/simple_animal/hostile/bear
		)
	cooldown = 30
	instability_cost = 10
	energy_cost = 1000

/obj/item/weapon/spell/summon/summon_creature/on_summon(var/mob/living/summoned)
	if(check_for_scepter())
//		summoned.faction = "technomancer"
		if(istype(summoned, /mob/living/simple_animal/hostile))
			var/mob/living/simple_animal/hostile/SA = summoned
			SA.friends.Add(owner)
	summoned.health = round(summoned.maxHealth * 0.7)