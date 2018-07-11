////////////////Basilisk////////////////

/mob/living/simple_animal/hostile/asteroid/basilisk
	name = "basilisk"
	desc = "A territorial beast, covered in a thick shell that absorbs energy. Its stare causes victims to freeze from the inside."
	icon = 'icons/mob/asteroid/basilisk.dmi'
	icon_state = "Basilisk"
	icon_living = "Basilisk"
	icon_aggro = "Basilisk_alert"
	icon_dead = "Basilisk_dead"
	icon_gib = "syndicate_gib"
	move_to_delay = 20
	projectiletype = /obj/item/projectile/temp/basilisk
	projectilesound = 'sound/weapons/pierce.ogg'
	ranged = 1
	ranged_message = "stares"
	ranged_cooldown_cap = 20
	throw_message = "does nothing against the hard shell of"
	vision_range = 2
	speed = 3
	maxHealth = 200
	health = 200
	harm_intent_damage = 5
	melee_damage_lower = 12
	melee_damage_upper = 12
	attacktext = "bites into"
	a_intent = "harm"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	ranged_cooldown_cap = 4
	aggro_vision_range = 9
	idle_vision_range = 2

/obj/item/projectile/temp/basilisk
	name = "freezing blast"
	damage = 0
	damage_type = BURN
	nodamage = 1
	check_armour = "energy"
	temperature = 50

/mob/living/simple_animal/hostile/asteroid/basilisk/GiveTarget(new_target)
	target_mob = new_target
	if(target_mob != null)
		Aggro()
		stance = HOSTILE_STANCE_ATTACK
		if(isliving(target_mob))
			var/mob/living/L = target_mob
			if(L.bodytemperature > 261)
				L.bodytemperature = 261
				visible_message("<span class='danger'>The [src.name]'s stare chills [L.name] to the bone!</span>")
	return

/mob/living/simple_animal/hostile/asteroid/basilisk/ex_act(severity, target_mob)
	switch(severity)
		if(1.0)
			gib()
		if(2.0)
			adjustBruteLoss(140)
		if(3.0)
			adjustBruteLoss(110)

/mob/living/simple_animal/hostile/asteroid/basilisk/death(gibbed)
	var/counter
	for(counter=0, counter<2, counter++)
		var/obj/item/weapon/ore/diamond/D = new /obj/item/weapon/ore/diamond(src.loc)
		D.layer = 4.1
	..(gibbed)



////////////////Spectator////////////////

/mob/living/simple_animal/hostile/asteroid/basilisk/spectator
	name = "spectator"
	desc = "Floating orb of flesh with a large creepy mouth, hateful single central eye, and many smaller flexible eyestalks on top. It looks kinda ancient."
	icon = 'icons/mob/asteroid/spectator.dmi'
	icon_state = "Spectator"
	icon_living = "Spectator"
	icon_aggro = "Spectator_alert"
	icon_dead = "Spectator_dead"
	speed = 4
	maxHealth = 300
	health = 300
	ranged_cooldown_cap = 3
	var/list/projectiletypes = list(/obj/item/projectile/temp/basilisk,
									/obj/item/projectile/ion/small,
									/obj/item/projectile/energy/plasmastun,
									/obj/item/projectile/energy/declone,
									/obj/item/projectile/energy/dart,
									/obj/item/projectile/energy/neurotoxin,
									/obj/item/projectile/energy/phoron,
									/obj/item/projectile/energy/electrode,
									/obj/item/projectile/energy/flash)

/mob/living/simple_animal/hostile/asteroid/basilisk/spectator/OpenFire()
	. = ..()
	projectiletype = pick(projectiletypes)