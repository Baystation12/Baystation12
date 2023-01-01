/// The actual particles if it ever enters the real world.
/obj/item/projectile/particles
	name = "accelerated bluespace particle"
	/// The amount of particles.
	var/particle_amount

/// Will provide accurate count of the amount of particles in the projectile.
/obj/item/projectile/particles/proc/update_name()
	name = "[particle_amount] accelerated bluespace particle\s"