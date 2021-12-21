
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
	move_to_delay = 10  //slower than common counterpart to give sense of weight to it
	health = 85 		//beefier than it's common counterpart to give a better sense of danger and urgency to encounters
	maxHealth = 85
	melee_damage_lower = 20 //as above so below
	melee_damage_upper = 30

/mob/living/simple_animal/hostile/flood/combat_form/prisoner/guard
	name = "infected guard"
	desc = "Some sort of creature that used to be human, donning a gray prison guard jumpsuit."
	icon_state = "guard_infected1"
	icon_living = "guard_infected1"
	icon_dead = "guard_infected1_dead"

/mob/living/simple_animal/hostile/flood/combat_form/prisoner/guard/New()
	inventory = pick(list(/obj/item/ammo_magazine/ma37/m118),list(/obj/item/ammo_magazine/m6d/m224),list(/obj/item/ammo_box/shotgun),\
				list(/obj/item/weapon/melee/baton/humbler),list(/obj/item/ammo_box/shotgun/beanbag),list(/obj/item/weapon/melee/telebaton))
	spawn_with_gun = pick(list(/obj/item/weapon/gun/projectile/shotgun/pump/m45_ts/achlys),list(/obj/item/weapon/gun/projectile/m6d_magnum/police/achlys),
						list(/obj/item/weapon/gun/projectile/ma37_ar/achlys),list(/obj/item/weapon/gun/projectile/shotgun/pump/m45_ts/police/achlys))

/mob/living/simple_animal/hostile/flood/combat_form/prisoner/mutated/guard
	desc = "Some kind of monster with shredded remains of a gray jumpsuit stuck to it's mishappen body."
	icon_state = "guard_infected2"
	icon_living = "guard_infected2"
	icon_dead = "guard_infected2_dead"

/mob/living/simple_animal/hostile/flood/combat_form/prisoner/mutated/guard/New()
	inventory = pick(list(/obj/item/ammo_magazine/ma37/m118),list(/obj/item/weapon/melee/baton/humbler),list(/obj/item/ammo_box/shotgun/beanbag),\
					list(/obj/item/ammo_magazine/m6d/m224),list(/obj/item/ammo_box/shotgun),list(/obj/item/weapon/melee/telebaton))

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

/mob/living/simple_animal/hostile/flood/combat_form/prisoner/crew/New()
	inventory = pickweight(list(/obj/item/weapon/reagent_containers/food/snacks/liquidfood/floody = 2),list(/obj/item/weapon/research = 2),list(/obj/item/weapon/scalpel/achlys = 1),\
							list(/obj/item/device/flashlight/flare/unsc = 1),list(/obj/item/device/flashlight/unsc = 1),list(/obj/item/device/healthanalyzer = 1),\
							list(/obj/item/device/multitool = 1),list(/obj/item/device/radio = 1))

//These two are static spawns and should only have one each across all 5Z, possibility of 2 XO
//If detachment marines have no engineers to hack doors or C4, these will access the necessary doors
/mob/living/simple_animal/hostile/flood/combat_form/prisoner/abomination/captain
	inventory = list(/obj/item/weapon/card/id/the_gold) //this is required to access the bridge, 2nd navconsole

/mob/living/simple_animal/hostile/flood/combat_form/prisoner/crew/XO
	inventory = list(/obj/item/weapon/card/id/the_silver) //this is required to access Z1 front, leads to bridge
