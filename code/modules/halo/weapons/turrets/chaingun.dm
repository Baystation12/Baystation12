
/obj/structure/turret/chaingun
	name = "Confetti Maker Chaingun Turret"
	desc = "A chaingun turret nicknamed the Confetti Maker due to it's inaccuracy and extraordinary rate of fire."

	icon_state = "chaingunturret"
	turret_gun = /obj/item/weapon/gun/projectile/turret/chaingun

/obj/item/weapon/gun/projectile/turret/chaingun
	name = "Confetti Maker Chaingun Turret"
	desc = "Dakka."

	icon_state = "chaingun_obj"
	item_state = "chaingun_obj"

	caliber = "a762"
	magazine_type = /obj/item/ammo_magazine/chaingun_boxmag

	//Burst Settings irrelevant in the face of sustain fire settings//
	//burst = 15
	//burst_delay = 1
	burst_accuracy = list(2,1,1,0,-1,-2,-3,-4,-4,-3,-3,-2,-2,-3)
	dispersion = list(0,0,0,0.5,0.5,0.5,1,1,1,2,2,2,2,2.5,2.5)

	load_time = 5

	sustain_time = 5 SECONDS
	sustain_delay = 1

/obj/item/weapon/gun/projectile/turret/chaingun/detached
	removed_from_turret = 1
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/turrets/mob_turret.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/turrets/mob_turret.dmi',
		)
	burst_accuracy = list(0,-1,-1,-1,-2,-3,-3,-5,-5,-6)
	dispersion = list(0.5,0.5,0.5,1,1,1,1.5,1.5,1.5,2.5,2.5,2.5,2.5,3,3)

	sustain_time = 2.5 SECONDS
