
//BR85 Rattle Rifle

/obj/item/weapon/gun/projectile/br85
	name = "\improper BR85 Battle Rifle"
	desc = "When nothing else gets the job done, the BR85 Battle Rifle will do. Takes 9.5mm calibre magazines."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "Br85"
	item_state = "br85"
	caliber = "9.5mm"
	slot_flags = SLOT_BACK
	fire_sound = 'code/modules/halo/sounds/BattleRifleShotSoundEffect.ogg'
	reload_sound = 'code/modules/halo/sounds/AssaultRifle&BattleRifle_ReloadSound_Effect.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/br85/m634
	allowed_magazines = list(/obj/item/ammo_magazine/br85)
	one_hand_penalty = -1
	burst = 3
	burst_delay = 1.2
	hud_bullet_row_num = 18
	w_class = ITEM_SIZE_LARGE
	dispersion=list(0.26, 0.26, 0.26) //About a third of a tile at 7 tile range.
	scope_zoom_amount = 2
	is_scope_variable = 1
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)
	crosshair_file = 'code/modules/halo/weapons/icons/dragaim_icon.dmi'

/obj/item/weapon/gun/projectile/br85/can_use_when_prone()
	return 1

/obj/item/weapon/gun/projectile/br85/verb/scope()
	set category = "Weapon"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(usr, scope_zoom_amount)

/obj/item/weapon/gun/projectile/br85/update_icon()
	if(ammo_magazine)
		icon_state = "Br85"
	else
		icon_state = "Br85_unloaded"
	. = ..()

//Basic Magazine

/obj/item/ammo_magazine/br85
	name = "BR85 magazine"
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "Br85_mag"
	mag_type = MAGAZINE
	caliber = "9.5mm"
	max_ammo = 36
	multiple_sprites = 1

//M634 Ammunition

/obj/item/ammo_magazine/br85/m634
	name = "BR55 magazine (9.5mm) M634"
	desc = "9.5x40mm M634 High-Powered Semi-Armor-Piercing (HP-SAP) magazine for the BR85 containing 36 rounds."
	ammo_type = /obj/item/ammo_casing/m634

/obj/item/weapon/storage/box/br85_m634
	name = "box of BR85 9.5mm M634 magazines"
	startswith = list(/obj/item/ammo_magazine/br85/m634 = 7)
