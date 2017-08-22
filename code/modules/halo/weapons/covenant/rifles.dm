/obj/item/weapon/gun/energy/plasmarifle
	name = "Plasma Rifle"
	desc = "Type=25 Directed Energy Rifle"
	icon = 'code/modules/halo/icons/Covenant Weapons.dmi'
	icon_state = "Plasma Rifle"
	slot_flags = SLOT_BACK
	fire_sound = 'code/modules/halo/sounds/plasrifle3burst.ogg' // need fire sound
	charge_meter = 0
	self_recharge = 1
	max_shots = 24 //Less shots, more damage. Exactly 8 bursts.
	recharge_time = 10
	burst = 3
	projectile_type = /obj/item/projectile/covenant/plasmarifle

