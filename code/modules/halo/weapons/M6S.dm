
//Magnum M6S silenced pistol

/obj/item/weapon/gun/projectile/m6c_magnum_s
	name = "\improper M6S silenced magnum"
	desc = "The M6C/SOCOM is a special operations variant of the popular M6C but with a whole host of inbuilt attachments. Takes 12.7mm calibre magazines."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "SOCOM"
	item_state = "halo_spistol"
	magazine_type = /obj/item/ammo_magazine/m6s/m225
	allowed_magazines = list(/obj/item/ammo_magazine/m6s,/obj/item/ammo_magazine/m6s/m225,/obj/item/ammo_magazine/m6s_m228)
	caliber = "12.7mm"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	fire_sound = 'code/modules/halo/sounds/Magnum_SOCOM_Fire.wav'
	reload_sound = 'code/modules/halo/sounds/MagnumReloadSoundEffect.ogg'
	load_method = MAGAZINE
	dispersion = list(0.4)
	silenced = 1
	one_hand_penalty = 1
	scope_zoom_amount = 1.1
	slowdown_general = 0

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)
	crosshair_file = 'code/modules/halo/weapons/icons/dragaim_icon.dmi'

/obj/item/weapon/gun/projectile/m6c_magnum_s/verb/scope()
	set category = "Weapon"
	set name = "Use Scope (Sidearm)"
	set popup_menu = 1

	toggle_scope(usr, scope_zoom_amount)

/obj/item/weapon/gun/projectile/m6c_magnum_s/update_icon()
	if(ammo_magazine)
		icon_state = "SOCOM"
	else
		icon_state = "SOCOM_unloaded"
	. = ..()

//Magazine

/obj/item/ammo_magazine/m6s
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "SOCOMmag"
	mag_type = MAGAZINE
	caliber = "12.7mm"
	max_ammo = 12
	multiple_sprites = 1

//M224 Ammunition

/obj/item/ammo_magazine/m6s/m224
	name = "M6S magazine (12.7mm) M224"
	desc = "12.7x40mm M224 Semi-Armor-Piercing (SAP) magazine for Magnum M6S containing 12 shots."
	ammo_type = /obj/item/ammo_casing/m224

/obj/item/weapon/storage/box/m6s_m224
	name = "box of M6S 12.7mm M224 magazines"
	startswith = list(/obj/item/ammo_magazine/m6s/m224 = 7)

//M225 Ammunition

/obj/item/ammo_magazine/m6s/m225
	name = "M6S magazine (12.7mm) M225"
	desc = "12.7x40mm M225 Semi-Armor-Piercing High-Explosive (SAP-HE) magazine for the Magnum M6S containing 12 shots."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "SOCOMmag"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/m225
	caliber = "12.7mm"
	max_ammo = 12
	multiple_sprites = 1

/obj/item/weapon/storage/box/m6s_m225
	name = "box of M6S 12.7mm M225 magazines"
	startswith = list(/obj/item/ammo_magazine/m6s/m225 = 7)

//M228 Ammunition

/obj/item/ammo_magazine/m6s_m228
	name = "M6S magazine (12.7mm) M228"
	desc = "12.7x40mm M228 Semi-Armor-Piercing High-Penetration (SAP-HP) magazine for the Magnum M6S containing 12 rounds."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "SOCOMmag"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/m228
	caliber = "12.7mm"
	max_ammo = 12
	multiple_sprites = 1

/obj/item/weapon/storage/box/m6s_m228
	name = "box of M6S 12.7mm M228 magazines"
	startswith = list(/obj/item/ammo_magazine/m6s_m228 = 7)
