
#define CLEAR_CASINGS 1
#define FLAMER_FIRE_LEVEL 10
#define FLAMER_FIRE_FUEL 5

//NA4 Defoliant Projector
/obj/item/weapon/gun/projectile/na4_dp
	name = "\improper NA4/Defoliant Projector"
	desc = "A standard-issue defoliant projector, capable of using many flamable defoliants to rout entrenched enemies. Leaks often, requiring the use of a protective suit."
	icon = 'code/modules/halo/icons/hell.dmi'
	icon_state = "na4_unloaded"
	item_state = "na4"
	slot_flags = SLOT_BACK
	handle_casings = CLEAR_CASINGS
	burst = 8
	hud_bullet_usebar = 1
	caliber="flamethrower"
	one_hand_penalty = 3
	slowdown_general = 0.15
	dispersion = list(2.5)
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/na4_tank
	allowed_magazines = list(/obj/item/ammo_magazine/na4_tank)
	wielded_item_state="na4_loaded"
	fire_sound = 'sound/effects/extinguish.ogg'

	firemodes = list(\
	list(mode_name="wide spread",  burst=8, dispersion=list(2.5)),
	list(mode_name="accurate fire",  burst=4, dispersion=list(0.4))
	)

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		slot_back_str = 'code/modules/halo/weapons/icons/Back_Weapons.dmi',
		slot_s_store_str = 'code/modules/halo/weapons/icons/Armor_Weapons.dmi',
		)

//This is mostly just so you can't use the flamethrower without proper protection.//
//Amusingly, super prolonged firing also literally overheats you, as you surpass your armour's protection.//
/obj/item/weapon/gun/projectile/na4_dp/handle_post_fire(mob/living/user, atom/target, var/pointblank=0, var/reflex=0)
	. = ..()
	if(istype(user))
		user.adjust_fire_stacks(0.1)
		if(!user.on_fire)
			user.IgniteMob()

/obj/item/projectile/bullet/fire
	name = "Napalm burst"
	desc = "burning napalm"
	check_armour = "energy"
	embed = 0
	sharp = 0
	damage = 20 //Low, but has extra flame effects and such.
	shield_damage =30
	icon = 'icons/effects/fire.dmi'
	icon_state = "fire"
	kill_count = 6 //We change this when launched anyway. Limits shooting to  vis range.
	var/kill_half = 0 //Automatically set on proj launch.

/obj/item/projectile/bullet/fire/attack_mob(var/mob/living/carbon/C)
	damage_type = BURN
	damtype = BURN
	if(istype(C))
		C.adjust_fire_stacks(0.6)
		if(!C.on_fire)
			C.IgniteMob()
	return ..()

/obj/item/projectile/bullet/fire/proc/spawn_fire(var/turf/targloc,var/created_firelevel = FLAMER_FIRE_LEVEL)
	if(!ismob(targloc))
		var/obj/effect/fire/f = locate() in targloc
		if(f)
			f.fire_fuel++ //Only a small increase if there's already a fire there.
		else
			f = new /obj/effect/fire/noheat(targloc)
			f.firelevel = created_firelevel
			f.fire_fuel = FLAMER_FIRE_FUEL

/obj/item/projectile/bullet/fire/on_impact(var/atom/impacted)
	..()
	spawn_fire(impacted.loc)

/obj/item/projectile/bullet/fire/Move()
	if(kill_count <= kill_half && !ismob(loc))
		spawn_fire(loc)
	.=..()

/obj/item/projectile/bullet/fire/launch_from_gun(var/atom/target)
	. = ..()
	var/targturf = target
	if(!isturf(target))
		targturf = get_turf(target)
	kill_count = get_dist(loc,targturf)
	kill_half = round(kill_count/2)


/obj/item/ammo_magazine/na4_tank
	name = "\improper Napalm Tank"
	desc = "A tank of Napalm for the NA4/Defoliant Projector"
	icon = 'code/modules/halo/icons/hell.dmi'
	icon_state = "na4_tank"
	ammo_type = /obj/item/ammo_casing/fire
	max_ammo = 99
	caliber="flamethrower"
	mag_type=MAGAZINE

/obj/item/ammo_casing/fire
	name = "Napalm canister"
	desc = "A vial of dark liquid"
	caliber = "flamethrower"
	projectile_type = /obj/item/projectile/bullet/fire

#undef FLAMER_FIRE_LEVEL
#undef FLAMER_FIRE_FUEL
#undef CLEAR_CASINGS