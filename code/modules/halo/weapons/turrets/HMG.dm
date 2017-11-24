
/obj/structure/turret/HMG
	name = "HMG Turret"
	desc = "A HMG Turret"

	icon_state = "hmgturret"

	turret_gun = /obj/item/weapon/gun/projectile/turret/HMG

/obj/item/weapon/gun/projectile/turret/HMG
	name = "HMG Turret"
	desc = "YATATATATATATATA"

	icon_state = "m247h_obj"
	item_state = "m247h_obj"

	caliber = "12.7mm"
	magazine_type = /obj/item/ammo_magazine/HMG_boxmag

	burst = 10
	burst_delay = 3
	burst_accuracy = list(3,2,2,1,0,-1,-1,-3,-4,-5)
	dispersion = list(0,0,1,1,2,2,3,4,4,5)

	load_time = 7

/obj/item/weapon/gun/projectile/turret/HMG/detached
	removed_from_turret = 1
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/turrets/mob_turret.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/turrets/mob_turret.dmi',
		)
	burst_accuracy = list(0,-1,-1,-1,-2,-3,-3,-5,-5,-6)
	dispersion = list(1,1,2,2,3,4,4,4,5,5)