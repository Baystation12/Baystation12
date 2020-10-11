//For whatever reason this wasn't defined here?
#define CLEAR_CASINGS 1

//NA4 Defoliant Projector
/obj/item/weapon/gun/projectile/na4_dp
	name = "\improper NA4/Defoliant Projector"
	desc = "A standard-issue defoliant projector, capable of using many flamable defoliants to rout entrenched enemies. Leaks often, requiring the use of a protective suit."
	icon = 'code/modules/halo/icons/hell.dmi'
	icon_state = "na4_unloaded"
	item_state = "na4"
	slot_flags = SLOT_BACK
	handle_casings = CLEAR_CASINGS
	burst = 3
	hud_bullet_usebar = 1
	caliber="flamethrower"
	one_hand_penalty = 3
	slowdown_general = 0.35
	dispersion = list(0.4)
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/na4_tank
	allowed_magazines = list(/obj/item/ammo_magazine/na4_tank)
	wielded_item_state="na4_loaded"
	fire_sound = 'sound/effects/extinguish.ogg'

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
	shield_damage = 10
	icon = 'icons/effects/fire.dmi'
	icon_state = "fire"
	kill_count = 6 //No sniping!

/obj/item/projectile/bullet/fire/attack_mob(var/mob/living/carbon/C)
	damage_type = BURN
	damtype = BURN
	if(istype(C))
		C.adjust_fire_stacks(0.6)
		if(!C.on_fire)
			C.IgniteMob()
	return ..()

/obj/item/projectile/bullet/fire/on_impact(var/atom/impacted)
	..()
	var/do_fire = 0
	var/impacted_loc = impacted
	if(!ismob(impacted_loc))
		if(isturf(impacted_loc))
			do_fire = 1
		else
			impacted_loc = impacted.loc
			if(isturf(impacted_loc))
				do_fire = 1
	if(do_fire)
		new /obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel(impacted_loc)
		new /obj/effect/fire(impacted_loc)

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

#undef CLEAR_CASINGS