
/obj/item/weapon/gun/energy/plasmapistol
	name = "Type-25 Directed Energy Pistol"
	desc = "A dual funtionality pistol: It fires bolts of plasma, and when overcharged is capable of emitting a small emp burst at the point of impact."
	icon = 'code/modules/halo/icons/Covenant Weapons.dmi'
	icon_state = "Plasma Pistol"
	slot_flags = SLOT_BELT|SLOT_HOLSTER|SLOT_POCKET|SLOT_BACK
	fire_sound = 'code/modules/halo/sounds/haloplasmapistol.ogg'
	charge_meter = 0
	self_recharge = 1
	max_shots = 20
	var/overcharge = 0
	projectile_type = /obj/item/projectile/covenant/plasmapistol
	screen_shake = 0

/obj/item/weapon/gun/energy/plasmapistol/attack_self(var/mob/user)
	if(overcharge) //tell user overcharge deactivated, reset stats.
		visible_message("<span class='notice'>[user.name]'s [src]'s lights darken</span>","<span class='notice'>You deactivate your [src]'s overcharge</span>")
		projectile_type = /obj/item/projectile/covenant/plasmapistol
		overcharge = 0
		charge_cost = initial(charge_cost)
		return
	else
		visible_message("<span class='notice'>[user.name]'s [src]'s lights brighten</span>","<span class='notice'>You activate your [src]'s overcharge</span>")
		projectile_type = /obj/item/projectile/covenant/plasmapistol/overcharge
		charge_cost = initial(charge_cost)*(max_shots/2)
		overcharge = 1
		return


/obj/item/weapon/gun/energy/plasmapistol/disabled
	name = "Type-25 Directed Energy Pistol"
	desc = "A dual funtionality pistol: It fires bolts of plasma, and when overcharged is capable of emitting a small emp burst at the point of impact. This one appears to be disabled"
	icon = 'code/modules/halo/icons/Covenant Weapons.dmi'
	icon_state = "Plasma Pistol"
	slot_flags = SLOT_BELT||SLOT_HOLSTER
	fire_sound = 'code/modules/halo/sounds/haloplasmapistol.ogg'
	charge_meter = 1
	self_recharge = 0
	max_shots = 0
	projectile_type = /obj/item/projectile/covenant/plasmapistol
	screen_shake = 0

/obj/item/weapon/gun/energy/plasmapistol/disabled/attack_self(var/mob/user)
	if(overcharge) //tell user overcharge deactivated, reset stats.
		visible_message("<span class='notice'>[user.name]'s [src]'s lights darken</span>","<span class='notice'>You deactivate your [src]'s overcharge</span>")
		projectile_type = /obj/item/projectile/covenant/plasmapistol
		overcharge = 0
		charge_cost = initial(charge_cost)
		return
	else
		visible_message("<span class='notice'>[user.name]'s [src]'s lights brighten</span>","<span class='notice'>You activate your [src]'s overcharge</span>")
		projectile_type = /obj/item/projectile/covenant/plasmapistol/overcharge
		charge_cost = initial(charge_cost)*(max_shots/2)
		overcharge = 1
		return


/obj/item/weapon/gun/projectile/needler // Uses "magazines" to reload rather than inbuilt cells.
	name = "Type-33 Guided Munitions Launcher"
	desc = "This weapon fire razor-sharp crystalline shards which can explode violently when embedded into targets."
	icon = 'code/modules/halo/icons/Covenant Weapons.dmi'
	icon_state = "Needler"
	item_state = "needler"
	slot_flags = SLOT_BELT||SLOT_HOLSTER
	fire_sound = 'code/modules/halo/sounds/needlerfire.ogg'
	magazine_type = /obj/item/ammo_magazine/needles
	handle_casings = CLEAR_CASINGS
	caliber = "needler"
	load_method = MAGAZINE
	burst = 3

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)
