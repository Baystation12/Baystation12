
/obj/item/weapon/gun/energy/plasmarepeater
	name = "Type-51 Directed Energy Rifle"
	desc = "Also known as the \"Plasma Repeater\", this weapon fires long bursts of superheated plasma. A unique ventilation and cooling system gives it a reversed dispersion and accuracy profile."
	icon = 'code/modules/halo/weapons/icons/Covenant Weapons.dmi'
	icon_state = "plasmarepeater"
	item_state = "repeater"
	w_class = ITEM_SIZE_HUGE
	fire_sound = 'code/modules/halo/sounds/plasrifle3burst.ogg'
	projectile_type = /obj/item/projectile/bullet/covenant/plasmarepeater
	slot_flags = SLOT_BACK
	one_hand_penalty = -1
	max_shots = 500
	charge_meter = 0
	burst_accuracy = list(0, 0, -1, -1, -1, -2, -2, -2, -3, -3, 0, 0, -1, -1, -1, -2, -2, -2, -3, -3, 0, 0, -1, -1, -1, -2, -2, -2, -3, -3,0,0,-1)
	dispersion = list(0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 1.0, 1.0, 1.0, 1.2, 1.2, 1.2, 1.4, 1.4, 1.4, 1.6, 1.6, 1.6, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8)
	w_class = ITEM_SIZE_HUGE
	irradiate_non_cov = 7
	move_delay_malus = 1.5
	slowdown_general = 1
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)
	wielded_item_state = "repeater-wielded"
	salvage_components = list(/obj/item/plasma_core)
	matter = list("nanolaminate" = 2)

	overheat_capacity = 121 //4 bursts, overheating on first round of 5th burst
	overheat_fullclear_delay = 35
	overheat_sfx = 'code/modules/halo/sounds/plasrifle_overheat.ogg'

	sustain_time = 4.5 SECONDS
	sustain_delay = 1.5

	alt_charge_method = 1


/obj/item/weapon/gun/energy/plasmarepeater/proc/cov_plasma_recharge_tick()
	if(max_shots > 0)
		if(power_supply.charge < power_supply.maxcharge)
			power_supply.give(charge_cost*20)
			update_icon()
			return 1