
/obj/item/ammo_magazine/m26
	name = "M-26 Bottle Rocket"
	desc = "A single tube of M-26 102mm HEAT rockets for the ACL-55."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "m26_exp"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/m26
	caliber = "m26"
	max_ammo = 1
	w_class = ITEM_SIZE_HUGE

/obj/item/ammo_casing/m26
	caliber = "rocket_used"
	projectile_type = /obj/item/projectile/bullet/m26

/obj/item/projectile/bullet/m26
	name = "bottle rocket"
	icon_state = "m26"
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	check_armour = "bomb"
	step_delay = 1.2
	shield_damage = 200

/obj/item/projectile/bullet/m26/on_impact(var/atom/target)
	explosion(get_turf(target), 0, 1, 2, 4,guaranteed_damage = 50,guaranteed_damage_range = 2)
	..()

/obj/item/weapon/storage/box/m26
	name = "M-26 Bottle Rocket crate"
	desc = "URF certified crate containing two four of M-26 Bottle Rocket rockets for a total of four rockets to be loaded in the ACL-55."
	icon = 'code/modules/halo/icons/objs/halohumanmisc.dmi'
	icon_state = "m26crate"
	max_storage_space = base_storage_capacity(6)
	startswith = list(/obj/item/ammo_magazine/m26 = 2)
	can_hold = list(/obj/item/ammo_magazine/m26)
	slot_flags = SLOT_BACK
	max_w_class = ITEM_SIZE_HUGE
