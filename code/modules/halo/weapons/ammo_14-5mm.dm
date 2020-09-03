
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
	damage = 50
	armor_penetration = 50
	tracer_type = /obj/effect/projectile/sniper_trail
	tracer_delay_time = 2 SECONDS
	shield_damage = 150
	kill_count = 125
	step_delay = 0

/* M233 tracerless rounds  */
//used by: SRS99 sniper rifle

/obj/item/ammo_casing/m233
	desc = "A 14.5mm bullet casing."
	caliber = "14.5mm"
	projectile_type = /obj/item/projectile/bullet/m233

/obj/item/projectile/bullet/m233 //Modified slightly to provide a downside for using the innie-heavy-sniper-rounds over normal rounds.
	damage = 40
	armor_penetration = 40
	tracer_type = null
	tracer_delay_time = null
	pin_range = 3
	pin_chance = 70
	shield_damage = 100

/* M234 HVAP rounds */
//used by: SRS99 sniper rifle

/obj/item/ammo_casing/m234
	desc = "A 14.5mm bullet casing."
	caliber = "14.5mm"
	projectile_type = /obj/item/projectile/bullet/m234

/obj/item/projectile/bullet/m234
	damage = 40
	armor_penetration = 60
	tracer_type = /obj/effect/projectile/sniper_trail
	tracer_delay_time = 2 SECONDS
	shield_damage = 150
	kill_count = 125
	step_delay = 0

/* M235 HEAP rounds */
//used by: SRS99 sniper rifle

/obj/item/ammo_casing/m235
	desc = "A 14.5mm bullet casing."
	caliber = "14.5mm"
	projectile_type = /obj/item/projectile/bullet/m235

/obj/item/projectile/bullet/m235
	damage = 60
	armor_penetration = 40
	tracer_type = /obj/effect/projectile/sniper_trail
	tracer_delay_time = 2 SECONDS
	shield_damage = 200
	kill_count = 125
	step_delay = 0
