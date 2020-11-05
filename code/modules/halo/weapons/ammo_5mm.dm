
/obj/item/ammo_casing/m443
	desc = "A 5mm bullet casing."
	caliber = "5mm"
	projectile_type = /obj/item/projectile/bullet/m443

/obj/item/projectile/bullet/m443
	damage = 25
	shield_damage = 15

/obj/item/ammo_casing/m443_rubber
	desc = "A 5mm rubber bullet casing."
	caliber = "5mm"
	projectile_type = /obj/item/projectile/bullet/m443_rubber

/obj/item/projectile/bullet/m443_rubber //"rubber" bullets
	name = "rubber bullet"
	check_armour = "melee"
	damage = 5
	shield_damage = 0
	agony = 20
	embed = 0
	sharp = 0
	armor_penetration = 0
	penetrating = 0
