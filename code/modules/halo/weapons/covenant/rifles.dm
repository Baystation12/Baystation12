/obj/item/weapon/gun/energy/plasmarifle
	name = "Type-25 Directed Energy Rifle"
	desc = "Also known as the \"Plasma Rifle\", this weapon fires 3-shot bursts of superheated plasma."
	icon = 'code/modules/halo/icons/Covenant Weapons.dmi'
	icon_state = "Plasma Rifle"
	item_state = "plasmarifle"
	slot_flags = SLOT_BELT|SLOT_BACK
	fire_sound = 'code/modules/halo/sounds/plasrifle3burst.ogg'
	charge_meter = 1
	max_shots = 120 //Less shots, more damage. Exactly 40 bursts.
	burst = 3
	projectile_type = /obj/item/projectile/bullet/covenant/plasmarifle
	screen_shake = 0
	is_heavy = 1
	fire_delay = 10 //4 more ticks than usual
	dispersion=list(0.0, 0.6, 0.8)
	accuracy = 1
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		slot_back_str = 'code/modules/halo/weapons/icons/Back_Weapons.dmi',
		slot_s_store_str = 'code/modules/halo/weapons/icons/Armor_Weapons.dmi',
		slot_s_belt_str = 'code/modules/halo/weapons/icons/Belt_Weapons.dmi',
		)

	firemodes = list(
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=6,    burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 0.8)),
		list(mode_name="semi-auto", 	burst=1, fire_delay=null, move_delay=6,    burst_accuracy=list(0.4), dispersion=list(0.0)),
		)

	irradiate_non_cov = 10

/obj/item/weapon/gun/energy/plasmarifle/proc/cov_plasma_recharge_tick()
	if(max_shots > 0)
		if(power_supply.charge < power_supply.maxcharge)
			power_supply.give(charge_cost)
			update_icon()
			return 1

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
	projectile_type = /obj/item/projectile/bullet/covenant/plasmarifle
	screen_shake = 0
	dispersion=list(0.0, 0.6, 0.8)
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

/obj/item/weapon/gun/energy/plasmarifle/brute
	name = "Type-25 Directed Energy Rifle (overcharged)"
	icon_state = "Brute Plasma Rifle"
	desc = "Also known as the \"Plasma Rifle\", this weapon fires 3-shot bursts of superheated plasma at an accelerated rate. This one appears to be overcharged for fire speed."
	projectile_type = /obj/item/projectile/bullet/covenant/plasmarifle/brute
	fire_delay = 6
	accuracy = 0
	burst_delay = 1
	irradiate_non_cov = 8
