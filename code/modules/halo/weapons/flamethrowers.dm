//For whatever reason this wasn't defined here?
#define CLEAR_CASINGS 1

//NA4 Defoliant Projector
/obj/item/weapon/gun/projectile/na4_dp
	name = "\improper NA4/Defoliant Projector"
	desc = "A standard-issue defoliant projector, capable of using many flamable defoliants to rout entrenched enemies"
	icon = 'code/modules/halo/icons/hell.dmi'
	icon_state = "na4_unloaded"
	item_state = "na4"
	slot_flags = SLOT_BACK
	is_heavy = 1
	handle_casings = CLEAR_CASINGS
	burst = 3
	caliber="flamethrower"
	load_method = MAGAZINE
	wielded_item_state="na4_loaded"
	fire_sound = 'sound/effects/extinguish.ogg'

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/icons/hell.dmi',
		slot_r_hand_str = 'code/modules/halo/icons/hell.dmi',
		)


/obj/item/projectile/bullet/fire
	name = "Napalm burst"
	desc = "burning napalm"
	check_armour = "energy"
	embed = 0
	sharp = 0
	damage = 30
	icon = 'icons/effects/fire.dmi'
	icon_state = "fire"
	kill_count = 10

/obj/item/projectile/bullet/fire/attack_mob(var/mob/living/carbon/C)
	damage_type = BURN
	damtype = BURN
	if(istype(C))
		C.fire_stacks += 10
		C.IgniteMob()
		if(isturf(C.loc))
			var/turf/T = get_turf(C.loc)
			T.hotspot_expose(700, 2)
	return ..()

/obj/item/projectile/bullet/fire/on_impact(var/atom/impacted)
	..()
	if(isturf(impacted.loc))
		(get_turf(impacted.loc)).hotspot_expose(700, 2) //from BS12 flamethrower. Starts fire at turf if possible

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