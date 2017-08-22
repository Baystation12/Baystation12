


//MA5B assault rifle

/obj/item/weapon/gun/projectile/ma5b_ar
	name = "\improper MA5B Assault Rifle"
	desc = "Standard-issue service rifle of the UNSC Marines. Takes 7.62mm calibre magazines."
	icon = 'code/modules/halo/icons/Weapon Sprites.dmi'
	icon_state = "MA5D"		//we'll just pretend ok?
	item_state = "halo_ar"
	caliber = "a762"
	slot_flags = SLOT_BACK
	fire_sound = 'code/modules/halo/sounds/Assault_Rifle_Short_Burst_Sound_Effect.ogg'
	//fire_sound_burst = 'code/modules/halo/sounds/Assault_Rifle_Short_Burst_Sound_Effect.ogg'
	reload_sound = 'code/modules/halo/sounds/AssaultRifle&BattleRifle_ReloadSound_Effect.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m762_ap
	burst = 3
	burst_delay = 2

	firemodes = list(
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=6,    burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 0.6)),
		list(mode_name="short bursts", 	burst=5, fire_delay=null, move_delay=6,    burst_accuracy=list(-1,-1,-2,-2,-3), dispersion=list(0.6, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/weapon/gun/projectile/ma5b_ar/update_icon()
	if(ammo_magazine)
		icon_state = "MA5D"
	else
		icon_state = "MA5D_unloaded"



//BR55 battle

/obj/item/weapon/gun/projectile/br55
	name = "\improper BR55 Battle Rifle"
	desc = "When nothing else gets the job done, the BR55 Battle Rifle will do. Takes 9.5mm calibre magazines."
	icon = 'code/modules/halo/icons/Weapon Sprites.dmi'
	icon_state = "BattleRifle"
	item_state = "halo_br"
	caliber = "9.5mm"
	slot_flags = SLOT_BACK
	fire_sound = 'code/modules/halo/sounds/BattleRifleShotSoundEffect.ogg'
	reload_sound = 'code/modules/halo/sounds/AssaultRifle&BattleRifle_ReloadSound_Effect.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m95_sap
	burst = 3
	burst_delay = 1
	accuracy = 1

/obj/item/weapon/gun/projectile/br55/update_icon()
	if(ammo_magazine)
		icon_state = "BattleRifle"
	else
		icon_state = "BattleRifle_unloaded"
