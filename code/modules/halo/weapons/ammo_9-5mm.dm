
/* M634 Rounds */
//used by: BR55, BR85

/obj/effect/projectile/br_trail
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "br_trail"
	alpha = 160

/obj/item/ammo_casing/m634
	desc = "A 9.5mm bullet casing."
	caliber = "9.5mm"
	projectile_type = /obj/item/projectile/bullet/m634

/obj/item/projectile/bullet/m634
	damage = 25
	armor_penetration = 10
	steps_between_delays = 3
	tracer_type = /obj/effect/projectile/br_trail
	tracer_delay_time = 1.5 SECONDS
