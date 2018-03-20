/obj/item/weapon/gun/energy/plasmarifle
	name = "Type-25 Directed Energy Rifle"
	desc = "Also known as the \"Plasma Rifle\", this weapon fires 3-shot bursts of superheated plasma."
	icon = 'code/modules/halo/icons/Covenant Weapons.dmi'
	icon_state = "Plasma Rifle"
	item_state = "plasmarifle"
	slot_flags = SLOT_BACK | SLOT_BELT
	fire_sound = 'code/modules/halo/sounds/plasrifle3burst.ogg'
	charge_meter = 0
	self_recharge = 1
	max_shots = 30 //Less shots, more damage. Exactly 10 bursts.
	recharge_time = 5
	burst = 3
	projectile_type = /obj/item/projectile/covenant/plasmarifle
	screen_shake = 0
	dispersion=list(0.0, 0.6, 0.8)
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)
