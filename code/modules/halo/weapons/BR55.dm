
//BR55 Rattle Rifle

/obj/item/weapon/gun/projectile/br55
	name = "\improper BR55 Battle Rifle"
	desc = "The BR55 is an all-round infantry weapon with a 2x magnification scope."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "BR55-Loaded-Base"
	item_state = "br55"
	magazine_type = /obj/item/ammo_magazine/br55/m634
	allowed_magazines = list(/obj/item/ammo_magazine/br55)
	caliber = "9.5mm"
	slot_flags = SLOT_BACK
	fire_sound = 'code/modules/halo/sounds/Battle_Rifle_Fire_New.wav'
	reload_sound = 'code/modules/halo/sounds/Battle_Rifle_Reload_New.wav'
	load_method = MAGAZINE
	one_hand_penalty = -1
	burst = 3
	burst_delay = 1.2
	hud_bullet_row_num = 18
	w_class = ITEM_SIZE_LARGE
	dispersion=list(0.26, 0.26, 0.26)
	wielded_item_state = "br55-wielded"
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		slot_back_str = 'code/modules/halo/weapons/icons/Back_Weapons.dmi',
		slot_s_store_str = 'code/modules/halo/weapons/icons/Armor_Weapons.dmi',
		)
	crosshair_file = 'code/modules/halo/weapons/icons/dragaim_icon.dmi'
	attachment_slots = list("barrel","underbarrel rail","upper rail","upper stock")
	attachments_on_spawn = list(/obj/item/weapon_attachment/barrel/br55,/obj/item/weapon_attachment/br55_stock_cheekrest,/obj/item/weapon_attachment/br55_bottom,/obj/item/weapon_attachment/br55_upper,/obj/item/weapon_attachment/sight/br55_scope)

/obj/item/weapon/gun/projectile/br55/can_use_when_prone()
	return 1

/obj/item/weapon/gun/projectile/br55/update_icon()
	if(ammo_magazine)
		icon_state = "BR55-Loaded-Base"
	else
		icon_state = "BR55-Unloaded-Base"
	. = ..()

//Basic Magazine

/obj/item/ammo_magazine/br55
	name = "BR55 magazine"
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "BR55_Mag"
	mag_type = MAGAZINE
	caliber = "9.5mm"
	max_ammo = 36
	multiple_sprites = 1

//M634 Ammunition

/obj/item/ammo_magazine/br55/m634
	name = "BR55 magazine (9.5mm) M634"
	desc = "9.5x40mm M634 Experimental High-Powered Semi-Armor-Piercing (X-HP-SAP) magazine for the BR55 containing 36 rounds."
	ammo_type = /obj/item/ammo_casing/m634

/obj/item/weapon/storage/box/br55_m634
	name = "box of BR55 9.5mm M634 magazines"
	startswith = list(/obj/item/ammo_magazine/br55/m634 = 7)
