
/obj/structure/bipod/cov
	icon = 'code/modules/halo/weapons/turrets/turrets_covenant.dmi'
	icon_state = "stand"

/obj/structure/turret/plas
	name = "Type-52 Directed Energy Support Weapon"
	desc = "A Type-52 Directed Energy Support Weapon"

	icon = 'code/modules/halo/weapons/turrets/turrets_covenant.dmi'
	icon_state = "covturret"

	turret_gun = /obj/item/weapon/gun/projectile/turret/plas
	kit_undeploy = /obj/item/turret_deploy_kit/plasturret
	stand = /obj/structure/bipod/cov

/obj/item/weapon/gun/projectile/turret/plas
	name = "Type-52 Directed Energy Support Weapon"
	desc = "Superheated plasma bolts at a greatly increased rate of fire. What's not to love?"

	icon_state = "plasmaturret_obj"
	item_state = "plasmaturret_obj"

	caliber = "plas_turret_cells"
	magazine_type = /obj/item/ammo_magazine/plasturret_boxmag

	fire_sound = 'code/modules/halo/sounds/plasrifle3burst.ogg'
	handle_casings = CASELESS

	//burst = 10
	//burst_delay = 2
	fire_delay = 5
	burst_accuracy = list(0,0,0,0,0,0,0,0,0,0,-1)
	dispersion = list(0,0,0,0,0,0.3,0.6,0.9,1.0)

	load_time = 5

	burst = 30
	burst_delay = 1.3

/obj/item/weapon/gun/projectile/turret/plas/detached
	removed_from_turret = 1
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/turrets/mob_turret.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/turrets/mob_turret.dmi',
		)
	burst_accuracy = list(0,0,0,0,0,0,0,0,0,0,-1)

	move_delay_malus = 2
	fire_delay = 8
	burst = 15