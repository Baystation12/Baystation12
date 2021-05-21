
//below are prison related flood
//these flood are gamemode specific and shouldn't be used elsewhere as they're crafted
//specifically for the achlys gamemode. you've been warned.

/mob/living/simple_animal/hostile/flood/combat_form/prisoner/spawn_infestor()
	our_infestor = 1

/mob/living/simple_animal/hostile/flood/combat_form/prisoner
	name = "infected prisoner"
	desc = "Some sort of creature that clearly used to be human, wearing an orange jumpsuit."
	icon = 'code/modules/halo/flood/flood_combat_human.dmi'
	icon_state = "prisoner_infected2"
	icon_dead = "prisoner_infected2_dead"
	icon_living = "prisoner_infected2"
	move_to_delay = 8
	health = 50 //intentionally squishy to give melee combat a chance
	maxHealth = 50
	melee_damage_lower = 15
	melee_damage_upper = 25 //damage is scaled on the basis that there will be a lot of these and players will need to live after encounters
	attacktext = "stabs at"
	melee_infect = 1

/mob/living/simple_animal/hostile/flood/combat_form/prisoner/mutated
	name = "lumpy creature"
	desc = "Some kind of monster with tatters of an orange jumpsuit clinging to it's bulbous body."
	icon_state = "prisoner_infected1"
	icon_living = "prisoner_infected1"
	icon_dead = "prisoner_infected1_dead"
	move_to_delay = 10 //slower than common counterpart to give sense of weight to it
	health = 85 //beefier than it's common counterpart to give a better sense of danger and urgency to encounters
	maxHealth = 85
	melee_damage_lower = 20 //as above so below
	melee_damage_upper = 30

/mob/living/simple_animal/hostile/flood/combat_form/prisoner/guard
	name = "infected guard"
	desc = "Some sort of creature that used to be human, donning a gray prison guard jumpsuit."
	icon_state = "guard_infected1"
	icon_living = "guard_infected1"
	icon_dead = "guard_infected1_dead"

/mob/living/simple_animal/hostile/flood/combat_form/prisoner/mutated/guard
	desc = "Some kind of monster with shredded remains of a gray jumpsuit stuck to it's mishappen body."
	icon_state = "guard_infected2"
	icon_living = "guard_infected2"
	icon_dead = "guard_infected2_dead"

/mob/living/simple_animal/hostile/flood/combat_form/prisoner/abomination
	name = "abomination"
	desc = "A huge, bizarre monster that propels itself on two torso sized arms, leaving it's legs to dangle uselessly below it."
	icon_state = "abomination"
	icon_living = "abomination"
	icon_dead = "abomination_dead"
	move_to_delay = 4 //fast enough to give a sense of danger and muscle
	resistance = 5
	health = 250
	maxHealth = 250 //these will be specifically put in certain locations and not RNG based
	melee_damage_lower = 30
	melee_damage_upper = 40
	attacktext = "smashes"

/mob/living/simple_animal/hostile/flood/combat_form/prisoner/crew
	name = "sickly creature"
	desc = "This used to be a human male, and it's body has changed somehow."
	icon_state = "nudist"
	icon_living = "nudist"
	icon_dead = "nudist_dead"
