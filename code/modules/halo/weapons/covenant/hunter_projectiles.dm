
/obj/item/projectile/covenant/hunter_fuel_rod
	name = "Fuel Rod Bolt"

	damage = 50

	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "Overcharged_Plasmapistol shot"

/obj/item/projectile/covenant/hunter_fuel_rod/on_impact()
	. = ..()
	explosion(loc,0,2,1,5)
