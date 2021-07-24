
//SRS99 sniper rifle
/obj/item/weapon/gun/projectile/srs99_sniper
	name = "SRS99 sniper rifle"
	desc = "Special Applications Rifle, system 99 Anti-Matériel. Deadly at extreme range.  Takes 14.5mm calibre magazines."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "SRS99"
	item_state = "SRS99"
	load_method = MAGAZINE
	caliber = "14.5mm"
	slot_flags = SLOT_BACK
	magazine_type = /obj/item/ammo_magazine/srs99/m232
	fire_sound = 'code/modules/halo/sounds/Sniper_Fire_New.wav'
	reload_sound = 'code/modules/halo/sounds/Sniper_Reload_New.wav'
	one_hand_penalty = -1
	scoped_accuracy = 7
	screen_shake = 0
	fire_delay = 12
	accuracy = -6 //Honestly stop hipfiring snipers damn it
	dispersion = list(0)
	scope_zoom_amount = 8
	min_zoom_amount = 3
	is_scope_variable = 1
	wielded_item_state = "SRS99-wielded"
	hud_bullet_row_num = 2
	hud_bullet_reffile = 'code/modules/halo/icons/hud_display/hud_bullet_32x16.dmi'
	hud_bullet_iconstate = "sniper"
	w_class = ITEM_SIZE_HUGE
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		slot_back_str = 'code/modules/halo/weapons/icons/Back_Weapons.dmi',
		slot_s_store_str = 'code/modules/halo/weapons/icons/Armor_Weapons.dmi',
		)
	crosshair_file = 'code/modules/halo/weapons/icons/dragaim_icon.dmi'

/obj/item/weapon/gun/projectile/srs99_sniper/can_use_when_prone()
	return 1

/obj/item/weapon/gun/projectile/srs99_sniper/verb/scope()
	set category = "Weapon"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(usr, scope_zoom_amount)

/obj/item/weapon/gun/projectile/srs99_sniper/update_icon()
	if(ammo_magazine)
		icon_state = "SRS99"
	else
		icon_state = "SRS99_unloaded"
	. = ..()

//Basic Magazine

/obj/item/ammo_magazine/srs99
	name = "SRS99 magazine"
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "SRS99mag"
	mag_type = MAGAZINE
	caliber = "14.5mm"
	max_ammo = 4
	multiple_sprites = 1

//M232 Ammunition APFSDS

/obj/item/ammo_magazine/srs99/m232
	name = "SRS99 magazine (14.5mm) M232"
	desc = "14.5×114mm M232 armor piercing, fin-stabilized, discarding sabot (AP-FS-DS) magazine for the SRS99 containing 4 rounds. Not much this won't penetrate."
	ammo_type = /obj/item/ammo_casing/m232

/obj/item/weapon/storage/box/srs99_m232
	name = "box of SRS99 (14.5mm) M232 magazines"
	startswith = list(/obj/item/ammo_magazine/srs99/m232 = 4)

//M233 tracerless Ammunition

/obj/item/ammo_magazine/srs99/m233
	name = "SRS99 magazine (14.5mm) M233"
	desc = "14.5×114mm M233 armor piercing, fin-stabilized, discarding sabot (AP-FS-DS) magazine for the SRS99 containing 4 rounds. Reduced velocity and penetration but no tracers."
	ammo_type = /obj/item/ammo_casing/m233

/obj/item/weapon/storage/box/srs99_m233
	name = "box of SRS99 (14.5mm) M232 tracerless magazines"
	startswith = list(/obj/item/ammo_magazine/srs99/m233 = 4)

//M234 HVAP ammounition

/obj/item/ammo_magazine/srs99/m234
	name = "SRS99 magazine (14.5mm) M234"
	desc = "14.5×114mm M234 high velocity armor piercing (HVAP) magazine for the SRS99 containing 4 rounds. Take the hat off an Elite at 2000 yards."
	ammo_type = /obj/item/ammo_casing/m234

/obj/item/weapon/storage/box/srs99_m234
	name = "box of SRS99 (14.5mm) M234 magazines"
	startswith = list(/obj/item/ammo_magazine/srs99/m234 = 4)

//M235 HEAP ammunition

/obj/item/ammo_magazine/srs99/m235
	name = "SRS99 magazine (14.5mm) M235"
	desc = "14.5×114mm M232 high explosive armor piercing (HEAP) magazine for the SRS99 containing 4 rounds. High damage rounds."
	ammo_type = /obj/item/ammo_casing/m235

/obj/item/weapon/storage/box/srs99_m235
	name = "box of SRS99 (14.5mm) M235 magazines"
	startswith = list(/obj/item/ammo_magazine/srs99/m235 = 4)
