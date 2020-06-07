
/obj/item/weapon/gun/energy/plasmapistol
	name = "Type-25 Directed Energy Pistol"
	desc = "A dual funtionality pistol: It fires bolts of plasma, and when overcharged is capable of emitting a small emp burst at the point of impact."
	icon = 'code/modules/halo/icons/Covenant Weapons.dmi'
	icon_state = "Plasma Pistol"
	slot_flags = SLOT_BELT|SLOT_HOLSTER|SLOT_POCKET|SLOT_BACK
	fire_sound = 'code/modules/halo/sounds/haloplasmapistol.ogg'
	charge_meter = 1
	max_shots = 100
	slowdown_general = 0
	fire_delay = 5 //Lower damage projectile, so we fire just slightly faster.
	dispersion = list(0.45)
	var/overcharge = 0
	var/overcharge_type = /obj/item/projectile/bullet/covenant/plasmapistol/overcharge
	projectile_type = /obj/item/projectile/bullet/covenant/plasmapistol
	screen_shake = 0
	irradiate_non_cov = 10
	var/overcharge_cost = 1

	overheat_capacity = 12
	overheat_fullclear_delay = 25
	overheat_sfx = 'code/modules/halo/sounds/plaspistol_overheat.ogg'

	item_state = "plasmapistol"
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		slot_back_str = 'code/modules/halo/weapons/icons/Back_Weapons.dmi',
		slot_s_store_str = 'code/modules/halo/weapons/icons/Armor_Weapons.dmi',
		slot_s_belt_str = 'code/modules/halo/weapons/icons/Belt_Weapons.dmi',
		)

/obj/item/weapon/gun/energy/plasmapistol/New()
	. = ..()
	overcharge_cost = initial(charge_cost)*4

/obj/item/weapon/gun/energy/plasmapistol/attack_self(var/mob/user)
	if(power_supply.charge >= overcharge_cost)
		set_overcharge(!overcharge, user)

/obj/item/weapon/gun/energy/plasmapistol/proc/cov_plasma_recharge_tick()
	if(max_shots > 0)
		if(power_supply.charge < power_supply.maxcharge)
			power_supply.give(charge_cost)
			update_icon()
			return 1

/obj/item/weapon/gun/energy/plasmapistol/proc/set_overcharge(var/new_overcharge = 1, var/mob/user = null)
	if(new_overcharge != overcharge)
		if(new_overcharge)
			if(user)
				visible_message("<span class='notice'>[user.name]'s [src]'s lights brighten</span>","<span class='notice'>You activate your [src]'s overcharge</span>")
			projectile_type = overcharge_type
			charge_cost = overcharge_cost
			overcharge = 1
			overlays += "overcharge"
			set_light(3, 1, "66FF00")
			burst = 1
			fire_delay = initial(fire_delay) * 3 //triples the fire delay.
		else
			if(user)
				visible_message("<span class='notice'>[user.name]'s [src]'s lights darken</span>","<span class='notice'>You deactivate your [src]'s overcharge</span>")
			projectile_type = initial(projectile_type)
			overcharge = 0
			charge_cost = initial(charge_cost)
			overlays -= "overcharge"
			set_light(0, 0, "66FF00")
			burst = initial(burst)
			fire_delay = initial(fire_delay)

/obj/item/weapon/gun/energy/plasmapistol/disabled
	desc = "A dual funtionality pistol: It fires bolts of plasma, and when overcharged is capable of emitting a small emp burst at the point of impact. This one appears to be disabled"
	max_shots = 0

/obj/item/weapon/gun/energy/plasmapistol/disabled/attack_self(var/mob/user)
 return

/obj/item/weapon/gun/energy/plasmapistol/trainingpistol
	name = "Type-25B Directed Energy (Training) Pistol"
	desc = "A dual funtionality pistol: It fires bolts of plasma, and when overcharged is capable of emitting a small emp burst at the point of impact. This one appears to be modified to fire very weak bolts of energy."
	icon = 'code/modules/halo/icons/Covenant Weapons.dmi'
	icon_state = "Training Pistol"
	projectile_type = /obj/item/projectile/bullet/covenant/trainingpistol

/obj/item/weapon/gun/energy/plasmapistol/trainingpistol/set_overcharge(var/new_overcharge = 1, var/mob/user = null)
	return

/obj/item/weapon/gun/energy/plasmapistol/fastfire //Used as an SMG counterpart for first-contact.
	name = "Type-25 Directed Energy Pistol, Modified"
	desc = "A dual funtionality pistol: It fires bolts of plasma, and when overcharged is capable of emitting a small emp burst at the point of impact. This one appears to have been modified for usage by Kig-Yar and Unggoy, with an increased fire-rate and decreased damage."
	max_shots = 240 // 4 smg mags worth
	projectile_type = /obj/item/projectile/bullet/covenant/plasmapistol/fastfire
	overcharge_type = /obj/item/projectile/bullet/covenant/plasmapistol/overcharge/fastfire
	one_hand_penalty = -1
	burst = 6
	burst_delay = 1.4
	fire_delay = 6 //Resetting to default
	burst_accuracy = list(0,0,-1,-1,-1,-1)
	dispersion = list(0.2, 0.4, 0.6, 0.8, 1.1,1.4)

/obj/item/weapon/gun/energy/plasmapistol/fastfire/special_check(var/mob/user)
	. = ..()
	if(.)
		var/mob/living/carbon/human/h = user
		if(istype(h))
			if(!istype(h.species,/datum/species/unggoy) && !istype(h.species,/datum/species/kig_yar))
				to_chat(user,"<span class = 'notice'>[src] hasn't been modified for your species!</span>")
				return 0

/obj/item/weapon/gun/projectile/needler // Uses "magazines" to reload rather than inbuilt cells.
	name = "Type-33 Guided Munitions Launcher"
	desc = "This weapon fire razor-sharp crystalline shards which can explode violently when embedded into targets."
	icon = 'code/modules/halo/icons/Covenant Weapons.dmi'
	icon_state = "Needler"
	item_state = "needler"
	slot_flags = SLOT_BELT||SLOT_HOLSTER
	fire_sound = 'code/modules/halo/sounds/needlerfire.ogg'
	magazine_type = /obj/item/ammo_magazine/needles
	handle_casings = CASELESS
	caliber = "needler"
	load_method = MAGAZINE
	one_hand_penalty = 1
	burst = 6
	burst_delay = 1.5
	burst_accuracy = list(0,0,0,-1,-1,-1)
	dispersion = list(0.3, 0.5, 0.7, 0.9, 1.1,1.4)
	is_heavy = 1
	irradiate_non_cov = 5
	slowdown_general = 0

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		slot_back_str = 'code/modules/halo/weapons/icons/Back_Weapons.dmi',
		)
