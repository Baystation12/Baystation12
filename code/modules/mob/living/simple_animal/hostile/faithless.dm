/mob/living/simple_animal/hostile/faithless
	name = "Faithless"
	desc = "The Wish Granter's faith in humanity, incarnate"
	icon_state = "faithless"
	icon_living = "faithless"
	icon_dead = "faithless_dead"

	faction = "faithless"

	mob_class = MOB_CLASS_DEMONIC

	maxHealth = 50
	health = 50

	response_help = "passes through"
	response_disarm = "shoves"
	response_harm = "hits"

	attack_armor_pen = 5	//It's a horror from beyond, I ain't gotta explain 5 AP

	attacktext = list("gripped")
	attack_sound = 'sound/hallucinations/growl1.ogg'

	ai_holder = /datum/ai_holder/simple_animal/melee

	taser_kill = FALSE

	natural_weapon = /obj/item/natural_weapon/faithless

/obj/item/natural_weapon/faithless
	name = "shadow tendril"
	attack_verb = list("gripped")
	hitsound = 'sound/hallucinations/growl1.ogg'
	damtype = BURN
	force = 15

/mob/living/simple_animal/hostile/faithless/Allow_Spacemove(var/check_drift = 0)
	return 1

/mob/living/simple_animal/hostile/faithless/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(prob(12))
			L.Weaken(3)
			L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")

// Strong Variant
/mob/living/simple_animal/hostile/faithless/strong
	maxHealth = 100
	health = 100

// Cult Variant
/mob/living/simple_animal/hostile/faithless/cult
	faction = "cult"
	supernatural = TRUE

/mob/living/simple_animal/hostile/faithless/cult/cultify()
	return

// Strong Cult Variant
/mob/living/simple_animal/hostile/faithless/cult/strong
	maxHealth = 100
	health = 100