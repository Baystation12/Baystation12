
/* M224 Rounds */
//used by: M6D, M6S

/obj/item/ammo_casing/m224 //Civvie ammo.
	desc = "A 12.7mm bullet casing."
	caliber = "12.7mm"
	projectile_type = /obj/item/projectile/bullet/m224

/obj/item/projectile/bullet/m224
	damage = 45
	armor_penetration = 15
	accuracy = 1
	shield_damage = 5

/* M224 TTR Rounds */

/obj/item/ammo_casing/m224_ttr
	desc = "A 12.7mm bullet casing."
	caliber = "12.7mm"
	projectile_type = /obj/item/projectile/bullet/m224_ttr

/obj/item/projectile/bullet/m224_ttr
	armor_penetration = 0
	nodamage = 1
	agony = 10
	damage_type = PAIN
	penetrating = 0

/* M225 Rounds */
//used by: M6D, M6S

/obj/item/ammo_casing/m225 //Standard Issue UNSC
	desc = "A 12.7mm HE bullet casing."
	caliber = "12.7mm"
	projectile_type = /obj/item/projectile/bullet/m225

/obj/item/projectile/bullet/m225
	damage = 50
	shield_damage = -10 //Let's make the shield damage a bit more reasonable.
	armor_penetration = 30

/* M228 Rounds */
//used by: M6D, M6S

/obj/item/projectile/bullet/m228
	damage = 40
	armor_penetration = 40

/obj/item/ammo_casing/m228
	desc = "A 12.7mm HP bullet casing."
	caliber = "12.7mm"
	projectile_type = /obj/item/projectile/bullet/m228
