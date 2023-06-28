// These hivebots are harder to kill than normal, and are meant to protect their squad by
// distracting their enemies. This is done by being seen as very threatening.
// Their melee attacks weaken whatever they hit.

/mob/living/simple_animal/hostile/hivebot/tank
	attacktext = list("prodded")
	projectiletype = null // To force the AI to melee.
	movement_cooldown = 10
	natural_weapon = /obj/item/natural_weapon/hivebot/tank

/mob/living/simple_animal/hostile/hivebot/tank/Initialize()
	SetTransform(scale = 1.5)
	return ..()


/obj/item/natural_weapon/hivebot/tank
	name = "baton"
	attack_verb = list("prodded")
	hitsound = 'sound/weapons/Egloves.ogg'
	force = 3

// This one is tanky by having a massive amount of health.
/mob/living/simple_animal/hostile/hivebot/tank/meatshield
	name = "bulky hivebot"
	desc = "A large robot."
	maxHealth = 300
	health = 300

/mob/living/simple_animal/hostile/hivebot/tank/meatshield/Initialize()
	SetTransform(scale = 1.5)
	return ..()


// This one is tanky by having armor.
/mob/living/simple_animal/hostile/hivebot/tank/armored
	name = "armored hivebot"
	desc = "A robot clad in heavy armor."
	maxHealth = 150
	health = 150
	natural_armor = list(
				melee	= ARMOR_MELEE_RESISTANT,
				bullet	= ARMOR_BALLISTIC_PISTOL,
				laser	= ARMOR_LASER_HANDGUNS,
				energy	= ARMOR_ENERGY_SMALL,
				bomb	= ARMOR_BOMB_PADDED,
				bio		= ARMOR_BIO_SHIELDED,
				rad		= ARMOR_RAD_SHIELDED
				)

/mob/living/simple_animal/hostile/hivebot/tank/armored/Initialize()
	SetTransform(scale = 1.5)
	return ..()


/mob/living/simple_animal/hostile/hivebot/tank/armored/anti_melee
	name = "riot hivebot"
	desc = "A robot specialized in close quarters combat."
	natural_armor = list(
				melee	= ARMOR_MELEE_VERY_HIGH,
				bio		= ARMOR_BIO_SHIELDED,
				rad		= ARMOR_RAD_SHIELDED
				)

/mob/living/simple_animal/hostile/hivebot/tank/armored/anti_bullet
	name = "bulletproof hivebot"
	desc = "A robot specialized in ballistic defense."
	natural_armor = list(
				bullet	= ARMOR_BALLISTIC_RESISTANT,
				bio		= ARMOR_BIO_SHIELDED,
				rad		= ARMOR_RAD_SHIELDED
				)

/mob/living/simple_animal/hostile/hivebot/tank/armored/anti_laser
	name = "ablative hivebot"
	desc = "A robot specialized in photonic defense."
	natural_armor = list(
				laser	= ARMOR_LASER_RIFLES,
				bio		= ARMOR_BIO_SHIELDED,
				rad		= ARMOR_RAD_SHIELDED
				)
	var/reflect_chance = 70 // Same as regular ablative.

// Ablative Hivebots can reflect lasers just like humans.
/mob/living/simple_animal/hostile/hivebot/tank/armored/anti_laser/bullet_act(obj/item/projectile/P)
	if(istype(P, /obj/item/projectile/energy) || istype(P, /obj/item/projectile/beam))
		var/reflect_prob = reflect_chance - round(P.damage/3)
		if(prob(reflect_prob))
			visible_message(SPAN_DANGER("The [P.name] gets reflected by \the [src]'s armor!"))

			// Find a turf near or on the original location to bounce to
			if(P.starting)
				var/new_x = P.starting.x + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
				var/new_y = P.starting.y + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
				var/turf/curloc = get_turf(src)

				// redirect the projectile
				P.redirect(new_x, new_y, curloc, src)

				return PROJECTILE_CONTINUE

	return (..(P))
