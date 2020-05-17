
/obj/item/weapon/gun/projectile/fuel_rod
	name = "Type-33 Light Anti-Armor Weapon"
	desc = "A man-portable weapon capable of inflicting heavy damage on both vehicles and infantry."
	icon = 'code/modules/halo/weapons/icons/fuel_rod_cannon.dmi'
	icon_state = "fuel_rod"
	item_state = "fuelrod"
	fire_sound = 'code/modules/halo/sounds/Fuelrodfire.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/fuel_rod
	fire_delay = 10 //Slightly higher due to higher magsize
	one_hand_penalty = -1
	caliber = "fuel rod"
	handle_casings = CASELESS
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		slot_back_str = 'code/modules/halo/weapons/icons/Back_Weapons.dmi',
		slot_s_store_str = 'code/modules/halo/weapons/icons/Armor_Weapons.dmi',
		)
	slowdown_general = 2
	wielded_item_state = "fuelrod-wielded"

/obj/item/weapon/gun/projectile/fuel_rod/update_icon()
	if(ammo_magazine)
		icon_state = "fuel_rod_loaded"
	else
		icon_state = "fuel_rod"

/obj/item/weapon/gun/projectile/fuel_rod/process_projectile(var/obj/item/projectile/bullet/P, mob/user, atom/target, var/target_zone, var/params=null, var/pointblank=0, var/reflex=0)
	P.kill_count = get_dist(src, target)
	P.kill_count += rand(0,6) - 3
	. = ..()

#define FUEL_ROD_IRRADIATE_RANGE 2
#define FUEL_ROD_IRRADIATE_AMOUNT 15

/obj/item/ammo_magazine/fuel_rod
	name = "Type-33 Light Anti-Armor Weapon Magazine"
	desc = "Contains a maximum of 5 fuel rods."
	icon = 'code/modules/halo/weapons/icons/fuel_rod_cannon.dmi'
	icon_state = "fuel_rod_mag"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/fuel_rod
	caliber = "fuel rod"
	max_ammo = 5
	multiple_sprites = 1
	w_class = ITEM_SIZE_NORMAL

/obj/item/ammo_casing/fuel_rod
	icon = 'code/modules/halo/weapons/icons/fuel_rod_cannon.dmi'
	icon_state = "fuel_rod_casing"
	caliber = "fuel rod"
	projectile_type = /obj/item/projectile/bullet/fuel_rod

/obj/item/projectile/bullet/fuel_rod
	name = "fuel rod"
	check_armour = "bomb"
	step_delay = 1.2
	dispersion = 0.5	//random offset of 4.5 tiles
	icon = 'code/modules/halo/weapons/icons/Covenant_Projectiles.dmi'
	icon_state = "Overcharged_Plasmapistol shot"
	muzzle_type = /obj/effect/projectile/muzzle/cov_green

/obj/item/projectile/bullet/fuel_rod/throw_impact(atom/hit_atom)
	return on_impact(hit_atom)

/obj/item/projectile/bullet/fuel_rod/on_impact(var/atom/A)
	new /obj/effect/plasma_explosion/green(get_turf(src))
	explosion(A,-1,1,2,4,guaranteed_damage = 30, guaranteed_damage_range = 2)
	for(var/mob/living/l in range(FUEL_ROD_IRRADIATE_RANGE,loc))
		l.rad_act(FUEL_ROD_IRRADIATE_AMOUNT)
	qdel(src)

#undef FUEL_ROD_IRRADIATE_RANGE
#undef FUEL_ROD_IRRADIATE_AMOUNT
