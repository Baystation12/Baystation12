
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

	fire_delay = 5 //1 lower than normal
	accuracy = -1
	dispersion = list(0.2,0.2,0.2,0.3,0.3,0.4,0.4,0.5,0.5,0.5,0.5,0.55)

	load_time = 5

	firemodes = list(\
	list(mode_name="long bursts",  burst=50,burst_delay = 1,fire_delay = 5, accuracy = -1,dispersion=list(0.2,0.2,0.2,0.3,0.3,0.4,0.4,0.5,0.5,0.5,0.5,0.55)),
	list(mode_name="paced shots",  burst=25,burst_delay = 4,fire_delay = 7, accuracy = 0,dispersion=list(0.1,0.1,0.1,0.2,0.2,0.3,0.3,0.4,0.4,0.4,0.4,0.45))
	)

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
	accuracy = -2
	//Accuracy drops by -1 on both modes.
	firemodes = list(\
	list(mode_name="long bursts",  burst=30,burst_delay = 1,fire_delay = 8, accuracy = -2,dispersion=list(0.2,0.2,0.2,0.3,0.3,0.4,0.4,0.5,0.5,0.5,0.5,0.55)),
	list(mode_name="paced shots",  burst=12,burst_delay = 4,fire_delay = 10, accuracy = -1,dispersion=list(0.0,0.0,0.1,0.1,0.1,0.2,0.2,0.3,0.3,0.3,0.3,0.35))
	)

	burst = 30
