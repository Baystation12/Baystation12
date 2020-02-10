
/obj/structure/bipod/cov
	icon = 'code/modules/halo/weapons/turrets/turrets_covenant.dmi'
	icon_state = "stand"

/obj/structure/turret/plas
	name = "Type-52 Directed Energy Support Weapon"
	desc = "A Type-52 Directed Energy Support Weapon"

	icon = 'code/modules/halo/weapons/turrets/turrets_covenant.dmi'
	icon_state = "covturret"

	turret_gun = /obj/item/weapon/gun/projectile/turret/plas
	stand = /obj/structure/bipod/cov

/obj/item/weapon/gun/projectile/turret/plas
	name = "Type-52 Directed Energy Support Weapon"
	desc = "YATATATATATATATA"

	icon_state = "plasmaturret_obj"
	item_state = "plasmaturret_obj"

	caliber = "plas_turret_cells"
	magazine_type = /obj/item/ammo_magazine/plasturret_boxmag
	fire_sound = 'code/modules/halo/sounds/plasrifle3burst.ogg'
	handle_casings = CASELESS

	//burst = 10
	//burst_delay = 2
	burst_accuracy = list(1,1,1,1,0,0,-1,-1,-1,-2)
	dispersion = list(0,0,0,0,0,1,1,1,1.5,2,2)

	load_time = 5

	sustain_time = 4 SECONDS
	sustain_delay = 2

/obj/item/weapon/gun/projectile/turret/plas/detached
	removed_from_turret = 1
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/turrets/mob_turret.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/turrets/mob_turret.dmi',
		)
	burst_accuracy = list(0,0,0,0,-1,-1,-2,-2,-2,-3)
	dispersion = list(0.5,0.5,0.5,0.5,0.5,1.5,1.5,1.5,2,2.5,2.5)

	sustain_time = 2 SECONDS