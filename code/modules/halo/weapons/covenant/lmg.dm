
/obj/item/weapon/gun/energy/plasmarepeater
	name = "Type-51 Directed Energy Rifle"
	desc = "Also known as the \"Plasma Repeater\", this weapon fires long bursts of superheated plasma. A unique ventilation and cooling system gives it a reversed dispersion and accuracy profile."
	icon = 'code/modules/halo/icons/Covenant Weapons.dmi'
	icon_state = "PlasmaRepeater"
	item_state = "plasmarifle"//Need an inhand sprite. Plasrifle used as placeholder.
	w_class = ITEM_SIZE_HUGE
	fire_sound = 'code/modules/halo/sounds/plasrifle3burst.ogg'
	projectile_type = /obj/item/projectile/bullet/covenant/plasmarepeater
	slot_flags = 0	//too unwieldy to carry on your back
	one_hand_penalty = -1
	//burst = 6
	max_shots =450
	//burst_delay = 1
	charge_meter = 0
	burst_accuracy = list(-4, -4, -4, -4, -3, -3, -3, -3, -2, -2, -2, -2, -1, -1, -1, -1,-1, 0)
	dispersion = list(2.5,2.5,2.4, 2.3, 2.2, 2.1, 2.0, 1.9, 2.2, 2.1, 2.0, 1.9, 1.8, 1.7, 2.0, 1.9, 1.8, 1.7, 1.6, 1.5, 1.8, 1.7, 1.6, 1.5, 1.4, 1.3, 1.5, 1.4, 1.3, 1.2, 1.1, 1.0)

	w_class = ITEM_SIZE_HUGE
	irradiate_non_cov = 5
	advanced_covenant = 1
	move_delay_malus = 1
	slowdown_general = 1

	//Due to reverse acc. and disp. profile, this might be more powerful than the others.//
	sustain_time = 4.5 SECONDS
	sustain_delay = 1.5


/obj/item/weapon/gun/energy/plasmarepeater/proc/cov_plasma_recharge_tick()
	if(max_shots > 0)
		if(power_supply.charge < power_supply.maxcharge)
			power_supply.give(charge_cost)
			update_icon()
			return 1