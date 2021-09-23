// Webslingers do what their name implies, shoot web at enemies to slow them down.
/mob/living/simple_animal/hostile/giant_spider/webslinger
	desc = "Furry and green, it makes you shudder to look at it. This one has brilliant green eyes, and a cloak of web."

	icon_state = "webslinger"
	icon_living = "webslinger"
	icon_dead = "webslinger_dead"
	maxHealth = 90
	health = 90

	projectile_dispersion = 1
	projectile_accuracy = -2

	projectilesound = 'sound/weapons/thudswoosh.ogg'
	projectiletype = /obj/item/projectile/webball
	base_attack_cooldown = 2 SECONDS

	natural_weapon = /obj/item/natural_weapon/bite/spider/webslinger

	poison_per_bite = 2
	poison_type = /datum/reagent/psilocybin
	ai_holder_type = /datum/ai_holder/simple_animal/ranged

// Check if we should bola, or just shoot the pain ball
/mob/living/simple_animal/hostile/giant_spider/webslinger/should_special_attack(atom/A)

	if (ishuman(A))
		var/mob/living/carbon/human/H = A
		if (!H.incapacitated())
			return TRUE
	return FALSE

// Now we've got a running human in sight, time to throw the bola
/mob/living/simple_animal/hostile/giant_spider/webslinger/do_special_attack(atom/A)
	set waitfor = FALSE
	set_AI_busy(TRUE)
	var/obj/item/projectile/bola/B = new /obj/item/projectile/bola(src.loc)
	playsound(src, 'sound/weapons/thudswoosh.ogg', 100, 1)
	if (!B)
		return
	set_AI_busy(FALSE)

/obj/item/natural_weapon/bite/spider/webslinger
	force = 8
