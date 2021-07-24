
//Magnum M6D pistol

/obj/item/weapon/gun/projectile/m6d_magnum
	name = "\improper M6D Magnum"
	desc = "A common UNSC sidearm and one of the variants of Misriah Armory's M6 handgun series. Takes 12.7mm calibre magazines."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "magnum"
	item_state = "halo_pistol"
	magazine_type = /obj/item/ammo_magazine/m6d/m225
	allowed_magazines = list(/obj/item/ammo_magazine/m6d/m224,/obj/item/ammo_magazine/m6d/m225, /obj/item/ammo_magazine/m6d/m228)
	caliber = "12.7mm"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	one_hand_penalty = 1
	fire_delay = 4 //Lower mag cap than the plaspistol, so we'll let it fire faster.
	fire_sound = 'code/modules/halo/sounds/Magnum_Fire_New.wav'
	reload_sound = 'code/modules/halo/sounds/Magnum_Reload_New.wav'
	load_method = MAGAZINE
	w_class = ITEM_SIZE_NORMAL
	scope_zoom_amount = 1.1

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		slot_belt_str = 'code/modules/halo/weapons/icons/Belt_Weapons.dmi',
		)
	crosshair_file = 'code/modules/halo/weapons/icons/dragaim_icon.dmi'

	dispersion = list(0)
	hud_bullet_row_num = 6
	hud_bullet_reffile = 'code/modules/halo/icons/hud_display/hud_bullet_7x8.dmi'
	hud_bullet_iconstate = "bigpistol"

	slowdown_general = 0

/obj/item/weapon/gun/projectile/m6d_magnum/update_icon()
	if(ammo_magazine)
		icon_state = "magnum"
	else
		icon_state = "magnum_unloaded"
	. = ..()

/obj/item/weapon/gun/projectile/m6d_magnum/verb/scope()
	set category = "Weapon"
	set name = "Use Scope (Sidearm)"
	set popup_menu = 1

	toggle_scope(usr, scope_zoom_amount)

/obj/item/weapon/gun/projectile/m6d_magnum/CO_magnum
	name = "\improper CO\'s Magnum"
	desc = "I don't keep it loaded, Son. You'll have to find ammo as you go."
	accuracy = 1
	burst = 2

/obj/item/weapon/gun/projectile/m6d_magnum/CO_magnum/New()
	. = ..()
	var/oldammo = ammo_magazine
	ammo_magazine = null
	qdel(oldammo)

//Basic Magazine

/obj/item/ammo_magazine/m6d
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "magnummag"
	mag_type = MAGAZINE
	caliber = "12.7mm"
	max_ammo = 12
	multiple_sprites = 1

//M224 Ammunition

/obj/item/ammo_magazine/m6d/m224
	name = "M6D magazine (12.7mm) M224"
	desc = "12.7x40mm M224 Semi-Armor-Piercing (SAP) magazine for Magnum M6D containing 12 shots."
	ammo_type = /obj/item/ammo_casing/m224

/obj/item/weapon/storage/box/m6d_m224
	name = "box of M6D 12.7mm M224 magazines"
	startswith = list(/obj/item/ammo_magazine/m6d/m224 = 7)

//M225 Ammunition

/obj/item/ammo_magazine/m6d/m225
	name = "M6D magazine (12.7mm) M225"
	desc = "12.7x40mm M225 Semi-Armor-Piercing High-Explosive (SAP-HE) magazine for the Magnum M6D containing 12 shots."
	ammo_type = /obj/item/ammo_casing/m225

/obj/item/weapon/storage/box/m6d_m225
	name = "box of M6D 12.7mm M225 magazines"
	startswith = list(/obj/item/ammo_magazine/m6d/m225 = 7)

//M228 Ammunition

/obj/item/ammo_magazine/m6d/m228
	name = "M6D magazine (12.7mm) M228"
	desc = "12.7x40mm M228 Semi-Armor-Piercing High-Penetration (SAP-HP) magazine for the Magnum M6D containing 12 rounds."
	ammo_type = /obj/item/ammo_casing/m228

/obj/item/weapon/storage/box/m6d_m228
	name = "box of M6D 12.7mm M228 magazines"
	startswith = list(/obj/item/ammo_magazine/m6d/m228 = 7)




//M6B Civvie and GCPD pistol

/obj/item/weapon/gun/projectile/m6d_magnum/civilian
	name = "\improper M6B Magnum"
	desc = "Common handgun accessible to civilians with a lack of a scope. Takes 12.7mm calibre magazines sized for the M6D."
	icon_state = "m6b"
	item_state = "m6b"
	fire_sound = 'code/modules/halo/sounds/MagnumShotSoundEffect.ogg'
	reload_sound = 'code/modules/halo/sounds/MagnumReloadSoundEffect.ogg'

	magazine_type = /obj/item/ammo_magazine/m6d/m224

	one_hand_penalty = 0

/obj/item/weapon/gun/projectile/m6d_magnum/civilian/update_icon()
	. = ..()
	if(ammo_magazine)
		icon_state = "m6b"
	else
		icon_state = "m6b_unloaded"

/obj/item/weapon/gun/projectile/m6d_magnum/police
	name = "\improper M6B Magnum"
	icon_state = "m6b_police"
	item_state = "m6b_police"
	fire_sound = 'code/modules/halo/sounds/MagnumShotSoundEffect.ogg'
	reload_sound = 'code/modules/halo/sounds/MagnumReloadSoundEffect.ogg'
	desc = "Common handgun accessible to civilians with a lack of a scope, in drab gray GCPD colors. Takes 12.7mm calibre magazines sized for an M6D."

	magazine_type = /obj/item/ammo_magazine/m6d/m224

/obj/item/weapon/gun/projectile/m6d_magnum/police/police/update_icon()
	. = ..()
	if(ammo_magazine)
		icon_state = "m6b_police"
	else
		icon_state = "m6b_police_unloaded"
