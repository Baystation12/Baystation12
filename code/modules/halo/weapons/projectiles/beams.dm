/obj/item/projectile/beam/spartan
	name = "spartan laser"
	icon_state = "heavylaser"
	damage = 500 //This should one-hit kill all mobs, including lekgolo. Likely destroys most vehicles just as fast, if not instantly.
	armor_penetration = 100

	fire_sound = 'code/modules/halo/sounds/Spartan_Laser_Beam_Shot_Sound_Effect.ogg'

	muzzle_type = /obj/effect/projectile/laser_heavy/muzzle
	tracer_type = /obj/effect/projectile/laser_heavy/tracer
	impact_type = /obj/effect/projectile/laser_heavy/impact
