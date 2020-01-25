


//Magnum M6D pistol

/obj/item/weapon/gun/projectile/m6d_magnum
	name = "\improper M6D Magnum"
	desc = "A common UNSC sidearm and one of the variants of Misriah Armory's M6 handgun series. Takes 12.7mm calibre magazines."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "magnum"
	item_state = "halo_pistol"
	magazine_type = /obj/item/ammo_magazine/m127_saphe
	caliber = "12.7mm"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	fire_sound = 'code/modules/halo/sounds/Magnum_Fire_New.wav'
	reload_sound = 'code/modules/halo/sounds/Magnum_Reload_New.wav'
	load_method = MAGAZINE
	w_class = ITEM_SIZE_NORMAL

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		slot_belt_str = 'code/modules/halo/weapons/icons/Belt_Weapons.dmi',
		)

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

	toggle_scope(usr, 1.1)

/obj/item/weapon/gun/projectile/m6d_magnum/CO_magnum
	name = "\improper CO\'s Magnum"
	desc = "I don't keep it loaded, Son. You'll have to find ammo as you go."
	accuracy = 2
	burst = 2

/obj/item/weapon/gun/projectile/m6d_magnum/CO_magnum/New()
	. = ..()
	var/oldammo = ammo_magazine
	ammo_magazine = null
	qdel(oldammo)

//M6B Civvie and GCPD pistol

/obj/item/weapon/gun/projectile/m6d_magnum/m6b
	name = "\improper M6B Magnum"
	desc = "Common handgun accessible to civilians with a lack of a scope. Takes 12.7mm calibre magazines."
	icon_state = "m6b"
	item_state = "m6b"
	fire_sound = 'code/modules/halo/sounds/MagnumShotSoundEffect.ogg'
	reload_sound = 'code/modules/halo/sounds/MagnumReloadSoundEffect.ogg'
	magazine_type = /obj/item/ammo_magazine/r127

/obj/item/weapon/gun/projectile/m6d_magnum/m6b/update_icon()
	. = ..()
	if(ammo_magazine)
		icon_state = "m6b"
	else
		icon_state = "m6b_unloaded"

/obj/item/weapon/gun/projectile/m6d_magnum/m6b/scope()
	..()
	return

/obj/item/weapon/gun/projectile/m6d_magnum/m6b/police
	icon_state = "m6b_police"
	item_state = "m6b_police"
	desc = "Common handgun accessible to civilians with a lack of a scope, in drab gray GCPD colors. Takes 12.7mm calibre magazines."

/obj/item/weapon/gun/projectile/m6d_magnum/m6b/police/update_icon()
	. = ..()
	if(ammo_magazine)
		icon_state = "m6b_police"
	else
		icon_state = "m6b_police_unloaded"

//Magnum M6S silenced pistol

/obj/item/weapon/gun/projectile/m6c_magnum_s
	name = "\improper M6S silenced magnum"
	desc = "The M6C/SOCOM is a special operations variant of the popular M6C but with a whole host of inbuilt attachments. Takes 12.7mm calibre magazines."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "SOCOM"
	item_state = "halo_spistol"
	magazine_type = /obj/item/ammo_magazine/m127_saphp
	caliber = "12.7mm"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	fire_sound = 'code/modules/halo/sounds/Magnum_SOCOM_Fire.wav'
	reload_sound = 'code/modules/halo/sounds/MagnumReloadSoundEffect.ogg'
	load_method = MAGAZINE
	fire_delay = 3
	silenced = 1
	screen_shake = 0

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

/obj/item/weapon/gun/projectile/m6c_magnum_s/verb/scope()
	set category = "Weapon"
	set name = "Use Scope (Sidearm)"
	set popup_menu = 1

	toggle_scope(usr, 1.1)

/obj/item/weapon/gun/projectile/m6c_magnum_s/update_icon()
	if(ammo_magazine)
		icon_state = "SOCOM"
	else
		icon_state = "SOCOM_unloaded"
	. = ..()

//Hand Cannon

/obj/item/weapon/gun/projectile/heavysniper/handgonne
	name = "Handgonne"
	desc = "A very rare sidearm made for some kind of big game hunting. Takes 14.5mm shells."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "handcannon"
	item_state = "handgonne"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	caliber = "14.5mm"
	screen_shake = 1 //extra kickback
	max_shells = 3
	one_hand_penalty = 0
	ammo_type = /obj/item/ammo_casing/a145_ap/tracerless
	w_class = ITEM_SIZE_NORMAL
	accuracy = 0
	wielded_item_state = "handgonne"

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

/obj/item/weapon/gun/projectile/heavysniper/handgonne/scope()
	 return
