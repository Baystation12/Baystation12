
/obj/structure/turret/chaingun
	name = "Confetti Maker Chaingun Turret"
	desc = "A chaingun turret nicknamed the Confetti Maker due to it's inaccuracy and extraordinary rate of fire."

	icon_state = "chaingunturret"
	turret_gun = /obj/item/weapon/gun/projectile/turret/chaingun
	kit_undeploy = /obj/item/turret_deploy_kit/chaingun

/obj/item/weapon/gun/projectile/turret/chaingun
	name = "Confetti Maker Chaingun Turret"
	desc = "A lead-spewing gun, usually found mounted to a turret. It is known for it's inaccuracy and extraordinary rate of fire.."

	icon_state = "chaingun_obj"
	item_state = "chaingun_obj"

	caliber = "a762"
	magazine_type = /obj/item/ammo_magazine/chaingun_boxmag

	//Burst Settings irrelevant in the face of sustain fire settings//
	//burst = 15
	//burst_delay = 1
	fire_delay = 5 //1 lower than normal
	burst_accuracy = list(0,0,0,0,0,0,-1)
	dispersion = list(0.0,0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0)

	load_time = 5

	burst = 50
	burst_delay = 1

/obj/item/weapon/gun/projectile/turret/chaingun/detached
	removed_from_turret = 1
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/turrets/mob_turret.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/turrets/mob_turret.dmi',
		)

	move_delay_malus = 2
	fire_delay = 8
	burst = 30
