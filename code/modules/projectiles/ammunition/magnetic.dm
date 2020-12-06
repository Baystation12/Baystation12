/obj/item/weapon/magnetic_ammo
	name = "flechette magazine"
	desc = "A magazine containing steel flechettes."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "assault_rifle"
	var/projectile_type = /obj/item/projectile/bullet/magnetic/flechette
	var/projectile_name = "flechette"
	var/basetype = /obj/item/weapon/magnetic_ammo
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_STEEL = 1800)
	origin_tech = list(TECH_COMBAT = 1)
	var/remaining = 9

/obj/item/weapon/magnetic_ammo/examine(mob/user)
	. = ..()
	to_chat(user, "There [(remaining == 1)? "is" : "are"] [remaining] [projectile_name]\s left!")
	
/obj/item/weapon/magnetic_ammo/skrell
	name = "flechette cylinder"
	desc = "A magazine containing flechettes, the design harkening back to cylinders on revolvers."
	icon = 'icons/obj/guns/skrell_rifle.dmi'
	icon_state = "skrell_magazine"
	projectile_type = /obj/item/projectile/bullet/magnetic/flechette
	projectile_name = "slug"
	basetype = /obj/item/weapon/magnetic_ammo/skrell
	
/obj/item/weapon/magnetic_ammo/skrell/slug
	name = "slug cylinder"
	desc = "A magazine containing slugs, the design harkening back to cylinders on revolvers."
	projectile_type = /obj/item/projectile/bullet/magnetic/slug