/mob/living/simple_animal/hostile/legion/scavenger
	name = "legion scavenger"
	desc = "An amalgation of various parts scrapped together to make this lopsided heap of metal. <span class='legion'>You feel some form of malicious intelligence behind its shell...</span>"
	icon = 'packs/legion/icons/scavenger.dmi'
	icon_state = "base"
	maxHealth = 100
	ranged = TRUE

	/// List of melee weapon types. Used by `randomize_stats()`.
	var/list/random_melee_options = list(
		/obj/item/natural_weapon/drone_slicer,
		/obj/item/natural_weapon/hivebot/strong
	)
	/// List of ranged weapon types. Used by `randomize_stats()`.
	var/list/random_ranged_options = list(
		/obj/item/projectile/beam/midlaser,
		/obj/item/projectile/beam/stun,
		/obj/item/projectile/beam/stun/shock,
		/obj/item/projectile/beam/plasmacutter,
		/obj/item/projectile/beam/incendiary_laser,
		/obj/item/projectile/bullet/pistol,
		/obj/item/projectile/bullet/flechette,
		/obj/item/projectile/bullet/rifle,
		/obj/item/projectile/bullet/pellet/shotgun
	)


/mob/living/simple_animal/hostile/legion/scavenger/Initialize(mapload, obj/structure/legion/beacon/spawner)
	. = ..()
	randomize_stats()
	update_icon()


/mob/living/simple_animal/hostile/legion/scavenger/on_update_icon()
	ClearOverlays()
	..()
	if (icon_state == "base")
		AddOverlays(emissive_appearance(icon, "emissive", FLOAT_LAYER + 1))


/// Randomizes the scavenger's stats and weapons. Generally should only be used during `Initialize()`.
/mob/living/simple_animal/hostile/legion/scavenger/proc/randomize_stats()
	set_max_health(rand(80, 120))
	speed = rand(5, 7)

	natural_weapon = pick(random_melee_options)

	projectiletype = pick(random_ranged_options)
	var/obj/item/projectile/projectile = projectiletype
	projectilesound = initial(projectile.fire_sound)
	projectile_accuracy = rand(-10, 10) / 10
	projectile_dispersion = rand(-10, 10) / 10

	base_attack_cooldown = rand(2 SECONDS, 4 SECONDS)

	natural_armor["melee"] = rand(0, 25)
	natural_armor["bullet"] = rand(0, 25)
	natural_armor["laser"] = rand(0, 25)
	natural_armor["energy"] = rand(0, 25)
	natural_armor["bomb"] = rand(0, 25)
