
/obj/item/weapon/gun/projectile/m41
	name = "M41 SSR"
	desc = "Surface to surface rocket launcher for anti armor and anti infantry purposes. Takes SPNKr tubes."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "M41closed"
	item_state = "m41"
	fire_sound = 'code/modules/halo/sounds/Rocket_Launcher_Fire_New.wav'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/spnkr
	fire_delay = 20
	one_hand_penalty = -1
	dispersion = list(0)
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
	crosshair_file = 'code/modules/halo/weapons/icons/dragaim_missile.dmi'
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
	slot_flags = SLOT_BELT
	ammo_type = /obj/item/ammo_casing/spnkr
	caliber = "spnkr"
	max_ammo = 2
	w_class = ITEM_SIZE_LARGE

/obj/item/ammo_casing/spnkr
	caliber = "spnkr"
	projectile_type = /obj/item/projectile/bullet/ssr

/obj/item/projectile/bullet/ssr
	name = "rocket"
	icon_state = "ssr"
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	check_armour = "bomb"
	step_delay = 1.3
	kill_count = 21
	shield_damage = 100
	damage = 70
	armor_penetration = 50

/obj/item/projectile/bullet/ssr/on_impact(var/atom/target)
	explosion(get_turf(target), -1, 1, 3, 4,guaranteed_damage = 65,guaranteed_damage_range = 2)
	..()
