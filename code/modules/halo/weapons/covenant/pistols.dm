
/obj/item/weapon/gun/energy/plasmapistol
	name = "Plasma Pistol"
	desc = "A Type 25 Directed Energy Pistol"
	icon = 'code/modules/halo/icons/Covenant Weapons.dmi'
	icon_state = "Plasma Pistol"
	slot_flags = SLOT_BELT||SLOT_HOLSTER
	fire_sound = 'code/modules/halo/sounds/haloplasmapistol.ogg'
	charge_meter = 0
	self_recharge = 1
	max_shots = 20
	var/overcharge = 0
	projectile_type = /obj/item/projectile/covenant/plasmapistol

/obj/item/weapon/gun/energy/plasmapistol/attack_self()
	if(overcharge) //tell user overcharge deactivated, reset stats.
		visible_message("<span class='notice'>[usr]'s [src]'s lights darken</span>","<span class='notice'>You deactivate your [src]'s overcharge</span>")
		max_shots = 20
		projectile_type = /obj/item/projectile/covenant/plasmapistol
		overcharge = 0
		charge_cost = 200
		return
	else
		visible_message("<span class='notice'>[usr]'s [src]'s lights brighten</span>","<span class='notice'>You activate your [src]'s overcharge</span>")
		projectile_type = /obj/item/projectile/covenant/plasmapistol/overcharge
		charge_cost = 2000 // half of inbuiilt cell charge
		overcharge = 1
		max_shots = 2
		return


/obj/item/weapon/gun/projectile/needler // Uses "magazines" to reload rather than inbuilt cells.
	name = "Needler"
	desc = "A Type 33 Guided Munitions Launcher"
	icon = 'code/modules/halo/icons/Covenant Weapons.dmi'
	icon_state = "Needler"
	slot_flags = SLOT_BELT||SLOT_HOLSTER
	fire_sound = 'code/modules/halo/sounds/needlerfire.ogg'
	magazine_type = /obj/item/ammo_magazine/needles
	handle_casings = CASELESS
	caliber = "needler"
	load_method = MAGAZINE
