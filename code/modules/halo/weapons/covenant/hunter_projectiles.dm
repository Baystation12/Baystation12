
/obj/item/projectile/bullet/covenant/hunter_fuel_rod
	name = "Fuel Rod Bolt"

	damage = 50

	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "Overcharged_Plasmapistol shot"

/obj/item/projectile/bullet/covenant/hunter_fuel_rod/on_impact(var/atom/A)
	. = ..()
	explosion(A,0,1,2,5,guaranteed_damage = 60, guaranteed_damage_range = 2)
