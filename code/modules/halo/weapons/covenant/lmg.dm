
/obj/item/weapon/gun/energy/plasmarepeater
	name = "Type-51 Directed Energy Rifle"
	desc = "Also known as the \"Plasma Repeater\", this weapon fires fast 6 shot bursts of superheated plasma. A unique ventilation and cooling system gives it a reversed dispersion and accuracy profile."
	icon = 'code/modules/halo/icons/Covenant Weapons.dmi'
	icon_state = "PlasmaRepeater"
	item_state = "plasmarifle"//Need an inhand sprite. Plasrifle used as placeholder.
	w_class = ITEM_SIZE_HUGE
	fire_sound = 'code/modules/halo/sounds/plasrifle3burst.ogg'
	projectile_type = /obj/item/projectile/covenant/plasmarifle
	slot_flags = 0	//too unwieldy to carry on your back
	one_hand_penalty = -1
	burst = 6
	max_shots =200
	burst_delay = 1.3
	charge_meter = 0
	burst_accuracy = list(-2,-2,-2,-1,0,0)
	dispersion = list(2, 1.8, 1.5, 1.2,0.8, 0.8)
	w_class = ITEM_SIZE_HUGE
	irradiate_non_cov = 5
	advanced_covenant = 1


/obj/item/weapon/gun/energy/plasmarepeater/proc/cov_plasma_recharge_tick()
	if(max_shots > 0)
		if(power_supply.charge < power_supply.maxcharge)
			power_supply.give(charge_cost)
			update_icon()
			return 1