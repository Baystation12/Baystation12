/mob/living/simple_animal/hostile/scarybat
	name = "space bat swarm"
	desc = "A swarm of cute little blood sucking bats that looks pretty upset."
	icon = 'icons/mob/simple_animal/bats.dmi'
	icon_state = "bat"
	icon_living = "bat"
	icon_dead = "bat_dead"
	icon_gib = "bat_dead"

	faction = "scarybat"

	maxHealth = 20
	health = 20

	attacktext = list("bitten")
	attack_sound = 'sound/weapons/bite.ogg'

	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	harm_intent_damage = 10

	natural_weapon = /obj/item/natural_weapon/bite

	ai_holder = /datum/ai_holder/simple_animal/melee/evasive

	// meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat

	// say_list_type = /datum/say_list/mouse	// Close enough

	var/scare_chance = 15

/mob/living/simple_animal/hostile/scarybat/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(prob(scare_chance))
			L.Stun(1)
			L.visible_message("<span class='danger'>\the [src] scares \the [L]!</span>")

// Spookiest of bats
/mob/living/simple_animal/hostile/scarybat/cult
	faction = "cult"
	supernatural = TRUE

/mob/living/simple_animal/hostile/scarybat/cult/cultify()
	return

/mob/living/simple_animal/hostile/scarybat/cult/strong
	maxHealth = 60
	health = 60
