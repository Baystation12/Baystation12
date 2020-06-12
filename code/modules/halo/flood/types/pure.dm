
/mob/living/simple_animal/hostile/flood/combat_form/juggernaut
	name = "Flood Juggernanut"
	icon = 'code/modules/halo/flood/floodjuggernaut.dmi'
	icon_state = "movement state"
	icon_living = "movement state"
	icon_dead = "death state"
	move_to_delay = 15
	health = 300 //Combat forms need to be hardier.
	maxHealth = 300
	melee_damage_lower = 40
	melee_damage_upper = 55
	attacktext = "Whips"
	mob_size = MOB_LARGE
	resistance = 30 //MA5 Rounds literally can't damage this >:)
	bound_width = 96
	bound_height = 96

/mob/living/simple_animal/hostile/flood/combat_form/santa
	name = "A Christmas.. Abomination"
	desc = "A corruption of the christmas spirit, given human form. Dear God..."
	icon = 'code/modules/halo/flood/santaflood.dmi'
	icon_state = "normal"
	icon_living = "normal"
	icon_dead = "dead"
	bound_width = 32
	bound_height = 32
