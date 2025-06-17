// Base front line combat mob.
/mob/living/simple_animal/hostile/legion/bellator
	name = "legion bellator"
	desc = "A hulking mass of floating dark spikes and menacing yellow lights."
	icon = 'packs/legion/icons/bellator.dmi'
	icon_state = "base"
	default_pixel_x = -16
	default_pixel_y = -16
	pixel_x = -16
	pixel_y = -16

	maxHealth = 300
	health = 300
	armor_type = /datum/extension/armor
	natural_armor = list(
		"melee" = ARMOR_MELEE_RESISTANT,
		"bullet" = ARMOR_BALLISTIC_RESISTANT,
		"laser" = ARMOR_LASER_MAJOR,
		"energy" = ARMOR_ENERGY_RESISTANT,
		"bomb" = ARMOR_BOMB_RESISTANT,
		"bio" = 100,
		"rad" = 100
	)
	speed = 5
	ai_holder = /datum/ai_holder/simple_animal/ranged/kiting/legion

	mob_size = MOB_LARGE

	projectiletype = /obj/item/projectile/beam/legion/bellator
	base_attack_cooldown = 2 SECONDS


/mob/living/simple_animal/hostile/legion/bellator/Initialize(mapload, obj/structure/legion/beacon/spawner)
	. = ..()
	update_icon()


/mob/living/simple_animal/hostile/legion/bellator/on_update_icon()
	ClearOverlays()
	..()
	if (icon_state == "base")
		AddOverlays(emissive_appearance(icon, "base-emissive", FLOAT_LAYER + 1))
