


//M7 submachine gun

/obj/item/weapon/gun/projectile/m7_smg
	name = "M7 submachine gun"
	desc = "The M7/Caseless Submachine Gun is a fully automatic close quarters infantry and special operations weapon. Takes 5mm calibre magazines."
	icon = 'code/modules/halo/icons/Weapon Sprites.dmi'
	icon_state = "m7smg"
	item_state = "halo_smg"
	caliber = "5mm"
	slot_flags = SLOT_BACK
	fire_sound = 'code/modules/halo/sounds/SMG_Mini_Burst_Sound_Effect.ogg'
	//fire_sound_burst = 'code/modules/halo/sounds/SMG_Short_Burst_Sound_Effect.ogg'
	reload_sound = 'code/modules/halo/sounds/SMG_Reload_Sound_Effect.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m5
	handle_casings = CASELESS
	burst = 3
	burst_delay = 2
	accuracy = -1

	firemodes = list(
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="short bursts",   burst=5, fire_delay=null, move_delay=4,    burst_accuracy=list(0,-1,-1,-2,-2), dispersion=list(0.6, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/weapon/gun/projectile/m7_smg/update_icon()
	if(ammo_magazine)
		icon_state = "m7smg"
	else
		icon_state = "m7smg_unloaded"

/obj/item/weapon/gun/projectile/m7_smg/silenced
	name = "M7S submachine gun"
	desc = "The M7S is a special operations variant of with inbuilt suppressor and host of other . Takes 5mm calibre magazines."
	silenced = 1
