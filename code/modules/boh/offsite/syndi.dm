/////////
// Syndi Drone
/////////

/mob/living/simple_animal/hostile/retaliate/malf_drone/syndi
	speak = list("ALERT.","Hostile entities detected.","Threat parameters set.","Bring sub-systems up to combat alert alpha.")
	projectiletype = /obj/item/projectile/beam/drone/weak
	faction = "syndicate"

/obj/item/projectile/beam/drone/weak
	damage = 5

/////////
// Guard Drone
/////////

/mob/living/simple_animal/hostile/retaliate/malf_drone/guard
	speak = list("Unregistered personnel detected. Engaging.")
	projectiletype = /obj/item/projectile/beam/drone/weak
	faction = "syndicate"