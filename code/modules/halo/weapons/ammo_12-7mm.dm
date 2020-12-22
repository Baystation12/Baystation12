
/* M224 Rounds */
//used by: M6D, M6S

/obj/item/ammo_casing/m224
	desc = "A 12.7mm bullet casing."
	caliber = "12.7mm"
	projectile_type = /obj/item/projectile/bullet/m224

/obj/item/projectile/bullet/m224
	damage = 45
	accuracy = 1
	shield_damage = -10 //Unspecialised kinetics are less powerful vs shields

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

/obj/item/ammo_casing/m225
	desc = "A 12.7mm HE bullet casing."
	caliber = "12.7mm"
	projectile_type = /obj/item/projectile/bullet/m225

/obj/item/projectile/bullet/m225
	damage = 55
	shield_damage = 10 //Unspecialised kinetics are less powerful vs shields

/* M228 Rounds */
//used by: M6D, M6S

/obj/item/projectile/bullet/m228
	damage = 40
	armor_penetration = 10
	shield_damage = 10 //Unspecialised kinetics are less powerful vs shields

/obj/item/ammo_casing/m228
	desc = "A 12.7mm HP bullet casing."
	caliber = "12.7mm"
	projectile_type = /obj/item/projectile/bullet/m228
