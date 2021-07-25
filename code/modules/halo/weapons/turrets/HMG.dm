
/obj/structure/turret/HMG
	name = "HMG Turret"
	desc = "A HMG Turret"

	icon_state = "hmgturret"

	turret_gun = /obj/item/weapon/gun/projectile/turret/HMG
	kit_undeploy = /obj/item/turret_deploy_kit/HMG

/obj/item/weapon/gun/projectile/turret/HMG //Slowfiring, so we're going to cap our dispersion much lower.
	name = "HMG Turret"
	desc = "Fires slower than the Confetti Maker, but with more stopping power per round."

	icon_state = "m247h_obj"
	item_state = "m247h_obj"

	caliber = "12.7mm"
	magazine_type = /obj/item/ammo_magazine/HMG_boxmag

	fire_delay = 5 //1 lower than normal
	dispersion = list(0.1,0.1,0.1,0.2,0.2,0.3,0.3,0.4,0.4,0.4,0.4,0.45)

	load_time = 7
	//Chaingun dispersions on paced shots with worse dispersion on longburst. Higher damage, but faster firing on paced shots
	//Than chaingun provides.
	firemodes = list(\
	list(mode_name="paced shots",  burst=30,burst_delay = 3,fire_delay = 5, accuracy = 0, dispersion=list(0.1,0.1,0.1,0.2,0.2,0.3,0.3,0.4,0.4,0.4,0.4,0.45)),
	list(mode_name="long bursts",  burst=40,burst_delay = 2,fire_delay = 7, accuracy = -1,dispersion=list(0.2,0.2,0.3,0.3,0.4,0.4,0.5,0.5,0.55,0.55,0.6,0.6))
	)

	burst = 30
	burst_delay = 3

/obj/item/weapon/gun/projectile/turret/HMG/detached
	removed_from_turret = 1
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/turrets/mob_turret.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/turrets/mob_turret.dmi',
		)

	move_delay_malus = 2
	fire_delay = 8
	accuracy = -1

	firemodes = list(\
	list(mode_name="paced shots",  burst=20,burst_delay = 3,fire_delay = 8, accuracy = -1, dispersion=list(0.1,0.1,0.1,0.2,0.2,0.3,0.3,0.4,0.4,0.4,0.4,0.45)),
	list(mode_name="long bursts",  burst=10,burst_delay = 2,fire_delay = 10, accuracy = -2,dispersion=list(0.2,0.2,0.3,0.3,0.4,0.4,0.5,0.5,0.55,0.55,0.6,0.6))
	)

	burst = 20
