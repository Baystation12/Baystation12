/obj/item/grenade/fake
	icon_state = "frggrenade"


/obj/item/grenade/fake/detonate(mob/living/user)
	playsound(loc, get_sfx("explosion"), 50, 1, 30)
	active = FALSE




/obj/item/grenade/spawnergrenade/fake_carp
	origin_tech = list(TECH_MATERIAL = 2, TECH_MAGNET = 2, TECH_BLUESPACE = 5)
	spawn_type = /mob/living/simple_animal/hostile/carp/holodeck
	spawn_amount = 4
	spawn_throw_range = 3


/obj/item/grenade/spawnergrenade/fake_carp/AfterSpawn(mob/living/user, list/spawned)
	for (var/mob/living/simple_animal/hostile/carp/holodeck/carp as anything in spawned)
		carp.faction = null
		carp.environment_smash = 0
		carp.destroy_surroundings = 0
		var/obj/item/weapon = carp.get_natural_weapon()
		weapon.force = 0
