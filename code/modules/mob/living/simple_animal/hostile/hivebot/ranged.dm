// These hivebots are intended for general damage causing, at range.

/mob/living/simple_animal/hostile/hivebot/ranged_damage
	maxHealth = 60
	health = 60
	projectiletype = /obj/item/projectile/bullet/hivebot

// The regular ranged hivebot, that fires somewhat weak projectiles.
/mob/living/simple_animal/hostile/hivebot/ranged_damage/basic
	name = "ranged hivebot"
	desc = "A robot with a makeshift integrated ballistic weapon."
	projectile_dispersion = 2
	projectile_accuracy = -1

// This one shoots quickly, and is considerably more dangerous.
/mob/living/simple_animal/hostile/hivebot/ranged_damage/rapid
	name = "rapid hivebot"
	desc = "A robot with a crude but deadly integrated rifle."
	base_attack_cooldown = 5 // Two attacks a second or so.
	projectile_dispersion = 2
	projectile_accuracy = -2

// Shoots deadly lasers.
/mob/living/simple_animal/hostile/hivebot/ranged_damage/laser
	name = "laser hivebot"
	desc = "A robot with a photonic weapon integrated into itself."
	projectiletype = /obj/item/projectile/beam/blue
	projectilesound = 'sound/weapons/Laser.ogg'
	projectile_dispersion = 2
	projectile_accuracy = -1

// Shoots EMPs, to screw over other robots.
/mob/living/simple_animal/hostile/hivebot/ranged_damage/ion
	name = "ionic hivebot"
	desc = "A robot with an electromagnetic pulse projector."
	icon_state = "yellow"
	icon_living = "yellow"

	projectiletype = /obj/item/projectile/ion
	projectilesound = 'sound/weapons/Laser.ogg'
	projectile_dispersion = 1
	projectile_accuracy = -2
	base_attack_cooldown = 28


// Beefy and ranged.
/mob/living/simple_animal/hostile/hivebot/ranged_damage/strong
	name = "strong hivebot"
	desc = "A robot with a crude ballistic weapon and strong armor."
	maxHealth = 120
	health = 120
	projectile_dispersion = 2
	projectile_accuracy = -1
	projectilesound = 'sound/weapons/gunshot/mech_autocannon.ogg'

// Also beefy, but tries to stay at their 'home', ideal for base defense.
/mob/living/simple_animal/hostile/hivebot/ranged_damage/strong/guard
	name = "guard hivebot"
	desc = "A robot that seems to be guarding something."

// Inflicts a damage-over-time modifier on things it hits.
// It is able to stack with repeated attacks.
/mob/living/simple_animal/hostile/hivebot/ranged_damage/dot
	name = "ember hivebot"
	desc = "A robot that appears to utilize fire to cook their enemies."
	icon_state = "red"
	icon_living = "red"

	projectiletype = /obj/item/projectile/beam/incendiary_laser
	heat_resist = 1

/obj/item/projectile/fire
	name = "ember"
	icon = 'icons/effects/effects.dmi'
	icon_state = "explosion_particle"
	damage = 0
	nodamage = TRUE

/obj/item/projectile/fire/on_hit(atom/target, blocked, def_zone)
	. = ..()
	if (blocked)
		return

	if (istype(target, /mob/living))
		var/mob/living/C = target
		C.fire_stacks += 1
		if (!C.on_fire)
			C.IgniteMob()
