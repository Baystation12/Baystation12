
/obj/item/weapon/gun/projectile/m41
	name = "M41 SSR"
	desc = "Surface to surface rocket launcher for anti armor and anti infantry purposes. Takes SPNKr tubes."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "M41closed"
	item_state = "m41"
	fire_sound = 'code/modules/halo/sounds/Rocket_Launcher_Fire_New.wav'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/spnkr
	fire_delay = 8
	one_hand_penalty = -1
	dispersion = list(0.73)
	hud_bullet_row_num = 2
	hud_bullet_reffile = 'code/modules/halo/icons/hud_display/hud_bullet_32x16.dmi'
	hud_bullet_iconstate = "rocket"
	caliber = "spnkr"
	handle_casings = CASELESS
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)
	arm_time = 15
	charge_sound = null
	slowdown_general = 1

/obj/item/weapon/gun/projectile/m41/update_icon()
	if(ammo_magazine)
		icon_state = "M41closed"
	else
		icon_state = "M41open-empty"
	..()

//M41 rocket launcher
/obj/item/ammo_magazine/spnkr
	name = "M19 SPNKr"
	desc = "A dual tube of M19 102mm HEAT rockets for the M41 SSR."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "SPNKr"
	mag_type = MAGAZINE
	slot_flags = SLOT_BELT | SLOT_MASK //Shhh it's a joke
	ammo_type = /obj/item/ammo_casing/spnkr
	caliber = "spnkr"
	max_ammo = 2
	w_class = ITEM_SIZE_HUGE

/obj/item/ammo_casing/spnkr
	caliber = "spnkr"
	projectile_type = /obj/item/projectile/bullet/ssr

/obj/item/projectile/bullet/ssr
	name = "rocket"
	icon_state = "ssr"
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	check_armour = "bomb"
	step_delay = 1.2
	shield_damage = 200 //just below elite minor shields, meaning subsequent explosion and guaranteed damage will collapse it.

/obj/item/projectile/bullet/ssr/on_impact(var/atom/target)
	explosion(get_turf(target), 1, 1, 2, 4,guaranteed_damage = 50,guaranteed_damage_range = 2)
	..()

/obj/item/weapon/storage/box/spnkr
	name = "102mm HEAT SPNKr crate"
	desc = "UNSC certified crate containing three tubes of SPNKr rockets for a total of six rockets to be loaded in the M41 SSR."
	icon = 'code/modules/halo/icons/objs/halohumanmisc.dmi'
	icon_state = "ssrcrate"
	max_storage_space = base_storage_capacity(12)
	startswith = list(/obj/item/ammo_magazine/spnkr = 3)
	can_hold = list(/obj/item/ammo_magazine/spnkr)
	slot_flags = SLOT_BACK | SLOT_BELT
	max_w_class = ITEM_SIZE_HUGE
