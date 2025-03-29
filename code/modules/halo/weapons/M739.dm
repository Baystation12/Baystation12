
//M739 Light Machine Gun.

/obj/item/weapon/gun/projectile/m739_lmg
	name = "\improper M739 Light Machine Gun"
	desc = "Standard-issue squad automatic weapon, designed for use in heavy engagements. Takes 7.62mm box type magazines."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "M739"
	item_state = "SAW"
	caliber = "7.62mm"
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m739/m118
	allowed_magazines = list(/obj/item/ammo_magazine/m739)
	fire_sound = 'code/modules/halo/sounds/lmg_fire.ogg'
	reload_sound = 'code/modules/halo/sounds/UNSC_Saw_Reload_Sound_Effect.ogg'
	one_hand_penalty = -1
	dispersion = list(0.2, 0.2, 0.2, 0.2, 0.3, 0.3, 0.3, 0.3, 0.4, 0.4, 0.4, 0.5)
	w_class = ITEM_SIZE_HUGE
	hud_bullet_row_num = 50
	hud_bullet_reffile = 'code/modules/halo/icons/hud_display/hud_bullet_2x5.dmi'
	wielded_item_state = "SAW-wielded"
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		slot_back_str = 'code/modules/halo/weapons/icons/Back_Weapons.dmi',
		)
	slowdown_general = 0.3
	move_delay_malus = 1.1
	fire_delay = 5 //Slightly lower than normal.

	burst = 12

	firemodes = list(\
	list(mode_name="short bursts",  burst=12,accuracy=0, dispersion=list(0.2, 0.2, 0.2, 0.2, 0.3, 0.3, 0.3, 0.3, 0.4, 0.4, 0.4, 0.5)),
	list(mode_name="extended bursts", burst=24, accuracy=-1,dispersion=list(0.3, 0.3, 0.3, 0.3, 0.4, 0.4, 0.4, 0.4, 0.5, 0.5, 0.5, 0.6))
	)

/obj/item/weapon/gun/projectile/m739_lmg/update_icon()
	if(ammo_magazine)
		icon_state = "M739"
	else
		icon_state = "M739_unloaded"
	. = ..()

//Basic Magazine

/obj/item/ammo_magazine/m739
	name = "M739 box magazine"
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "M739mag"
	mag_type = MAGAZINE
	caliber = "7.62mm"
	max_ammo = 150
	multiple_sprites = 1
	w_class = ITEM_SIZE_NORMAL

//M118 Ammunition

/obj/item/ammo_magazine/m739/m118
	name = "M739 box magazine (7.62mm) M118"
	desc = "7.62x51mm M118 Full Metal Jacket Armour Piercing (FMJ-AP) box magazine for the M739 squad support weapon containing 150 shots."
	ammo_type = /obj/item/ammo_casing/m118

/obj/item/weapon/storage/box/large/m739_m118
	name = "box of M739 7.62mm M118 box magazines"
	startswith = list(/obj/item/ammo_magazine/m739/m118 = 3)
