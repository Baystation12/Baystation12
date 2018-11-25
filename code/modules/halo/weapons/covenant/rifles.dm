/obj/item/weapon/gun/energy/plasmarifle
	name = "Type-25 Directed Energy Rifle"
	desc = "Also known as the \"Plasma Rifle\", this weapon fires 3-shot bursts of superheated plasma."
	icon = 'code/modules/halo/icons/Covenant Weapons.dmi'
	icon_state = "Plasma Rifle"
	item_state = "plasmarifle"
	slot_flags = SLOT_BELT|SLOT_HOLSTER|SLOT_POCKET|SLOT_BACK
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


/obj/item/weapon/gun/energy/plasmarifle/decorative
	name = "Type-25 Directed Energy Rifle"
	desc = "Also known as the \"Plasma Rifle\", this weapon fires 3-shot bursts of superheated plasma. This one appears to be disabled"
	icon = 'code/modules/halo/icons/Covenant Weapons.dmi'
	icon_state = "Plasma Rifle"
	item_state = "plasmarifle"
	slot_flags = SLOT_BACK | SLOT_BELT
	fire_sound = 'code/modules/halo/sounds/plasrifle3burst.ogg'
	charge_meter = 1
	self_recharge = 0
	max_shots = 0 //Less shots, more damage. Exactly 10 bursts.
	recharge_time = 500
	burst = 1
	projectile_type = /obj/item/projectile/covenant/plasmarifle
	screen_shake = 0
	dispersion=list(0.0, 0.6, 0.8)
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

/obj/item/weapon/gun/energy/plasmarifle/brute
	name = "Type-25 Directed Energy Rifle (overcharged)"
	icon_state = "Brute Plasma Rifle"
	desc = "Also known as the \"Plasma Rifle\", this weapon fires 3-shot bursts of superheated plasma at an accelerated rate. This one appears to be overcharged for extra damage."
	recharge_time = 3
	projectile_type = /obj/item/projectile/covenant/plasmarifle/brute
