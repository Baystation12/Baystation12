
//M7 submachine gun

/obj/item/weapon/gun/projectile/m7_smg
	name = "M7 submachine gun"
	desc = "The M7/Caseless Submachine Gun is a fully automatic close quarters infantry and special operations weapon. Takes 5mm calibre magazines."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "m7smg"
	item_state = "m7"
	caliber = "5mm"
	slot_flags = SLOT_BACK|SLOT_BELT
	fire_sound = 'code/modules/halo/sounds/SMG_Mini_Burst_Sound_Effect.ogg'
	//fire_sound_burst = 'code/modules/halo/sounds/SMG_Short_Burst_Sound_Effect.ogg'
	reload_sound = 'code/modules/halo/sounds/SMG_Reload_New.wav'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m7/m443
	handle_casings = CASELESS
	burst = 4
	burst_delay = 1.5
	dispersion = list(0.2, 0.4, 0.7, 1.0)
	one_hand_penalty = 2
	allowed_magazines = list(/obj/item/ammo_magazine/m7)
	w_class = ITEM_SIZE_NORMAL
	hud_bullet_row_num = 20
	wielded_item_state = "m7-wielded"
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		slot_back_str = 'code/modules/halo/weapons/icons/Back_Weapons.dmi',
		slot_s_store_str = 'code/modules/halo/weapons/icons/Armor_Weapons.dmi',
		slot_belt_str = 'code/modules/halo/weapons/icons/Belt_Weapons.dmi',
		)

	slowdown_general = 0

	firemodes = list(\
	list(mode_name="short bursts",  burst=4,dispersion=list(0.2, 0.4, 0.7, 1.0)),
	list(mode_name="extended bursts",  burst=12, dispersion=list(0.3, 0.3, 0.5, 0.5, 0.9, 0.9, 1.2, 1.2))
	)

/obj/item/weapon/gun/projectile/m7_smg/update_icon()
	if(ammo_magazine)
		icon_state = "m7smg"
	else
		icon_state = "m7smg_unloaded"
	. = ..()

/obj/item/weapon/gun/projectile/m7_smg/silenced
	name = "M7S submachine gun"
	desc = "The M7S is a special operations variant of the M7 submachine gun with inbuilt suppressor and host of other attachments. Takes 5mm calibre magazines."
	silenced = 1
	is_heavy = 1
	scoped_accuracy = 1
	magazine_type = /obj/item/ammo_magazine/m7/m443/rnd48
	allowed_magazines = list(/obj/item/ammo_magazine/m7/m443/rnd48)
	fire_sound = 'code/modules/halo/sounds/SMG_SOCOM_Fire.wav'
	//fire_sound_burst = 'code/modules/halo/sounds/SMG_SOCOM_Fire.wav'
	dispersion = list(0.1, 0.3, 0.6, 1.0)
	one_hand_penalty = 2
	scope_zoom_amount = 2.0
	allowed_magazines = list(/obj/item/ammo_magazine/m7, /obj/item/ammo_magazine/m7)

	firemodes = list(\
	list(mode_name="short bursts",  burst=4, dispersion=list(0.1, 0.3, 0.6, 1.0)),
	list(mode_name="extended bursts",  burst=12, dispersion=list(0.3, 0.3, 0.4, 0.5, 0.6, 0.8, 1.1))
	)

/obj/item/weapon/gun/projectile/m7_smg/silenced/verb/scope()
	set category = "Weapon"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(usr, scope_zoom_amount)

/obj/item/weapon/gun/projectile/m7_smg/silenced/update_icon()
	if(ammo_magazine)
		icon_state = "m7smgs"
	else
		icon_state = "m7smgs_unloaded"

/obj/item/weapon/gun/projectile/m7_smg/rubber
	magazine_type = /obj/item/ammo_magazine/m7/rubber

//Basic Magazine

/obj/item/ammo_magazine/m7
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "m7mag"
	mag_type = MAGAZINE
	caliber = "5mm"
	max_ammo = 60
	multiple_sprites = 1

//M443 Ammunition

/obj/item/ammo_magazine/m7/m443
	name = "M7 magazine (5mm) M443"
	desc = "5x23mm M443 Caseless Full Metal Jacket magazine for the M7. Fun sized with no pesky casing!"
	ammo_type = /obj/item/ammo_casing/m443

/obj/item/ammo_magazine/m7/m443/rnd48
	name = "M7s magazine (5mm) M443"
	max_ammo = 48

/obj/item/weapon/storage/box/m7_m443
	name = "box of M7 5mm M443 magazines"
	startswith = list(/obj/item/ammo_magazine/m7/m443 = 7)

//M443 Rubber Ammunition

/obj/item/ammo_magazine/m7/rubber
	name = "M7 magazine (5mm) M443 rubber"
	desc = "5x23mm rubber bullets for the M7 used in for riot suppression."
	ammo_type = /obj/item/ammo_casing/m443_rubber

/obj/item/weapon/storage/box/m7_rubber
	name = "box of M7 5mm M443 magazines"
	startswith = list(/obj/item/ammo_magazine/m7/rubber = 7)
