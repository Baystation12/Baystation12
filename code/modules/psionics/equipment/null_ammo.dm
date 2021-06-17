/obj/item/projectile/bullet/nullglass
	name = "nullglass bullet"
	damage = 40
	shrapnel_type = /obj/item/material/shard/nullglass

/obj/item/projectile/bullet/nullglass/disrupts_psionics()
	return src

/obj/item/ammo_casing/pistol/magnum/nullglass
	desc = "A revolver bullet casing with a nullglass coating."
	projectile_type = /obj/item/projectile/bullet/nullglass

/obj/item/ammo_casing/pistol/magnum/nullglass/disrupts_psionics()
	return src

/obj/item/ammo_magazine/speedloader/magnum/nullglass
	ammo_type = /obj/item/ammo_casing/pistol/magnum/nullglass
