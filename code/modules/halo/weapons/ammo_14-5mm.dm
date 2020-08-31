
/* Tracer visual effect */

/obj/effect/projectile/sniper_trail
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "sniper_trail"

/* M232 rounds */
//used by: SRS99 sniper rifle
//note: these were formerly called "M112" but I'm not sure that's lore accurate -C

/obj/item/ammo_casing/m232
	desc = "A 14.5mm bullet casing."
	caliber = "14.5mm"
	projectile_type = /obj/item/projectile/bullet/m232

/obj/item/projectile/bullet/m232
	damage = 55
	armor_penetration = 60
	tracer_type = /obj/effect/projectile/sniper_trail
	tracer_delay_time = 2 SECONDS
	shield_damage = 210
	kill_count = 125
	step_delay = 0

/* M232 tracerless rounds  */
//used by: SRS99 sniper rifle

/obj/item/ammo_casing/m232/tracerless
	desc = "A 14.5mm bullet casing with modifications to reduce tracers and penetration."
	caliber = "14.5mm"
	projectile_type = /obj/item/projectile/bullet/m232/tracerless

/obj/item/projectile/bullet/m232/tracerless //Modified slightly to provide a downside for using the innie-heavy-sniper-rounds over normal rounds.
	damage = 55
	armor_penetration = 55
	tracer_type = null
	tracer_delay_time = null
	pin_range = 3
	pin_chance = 70
	shield_damage = 150
