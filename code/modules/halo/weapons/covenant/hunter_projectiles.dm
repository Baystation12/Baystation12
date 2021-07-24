
/obj/item/projectile/bullet/covenant/hunter_fuel_rod
	name = "Fuel Rod Bolt"

	damage = 50
	shield_damage = 200
	//kill_count = 8 //Just outside view range. Turns out this is kinda op.

	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "Overcharged_Plasmapistol shot"

/obj/item/projectile/bullet/covenant/hunter_fuel_rod/on_impact(var/atom/A)
	. = ..()
	new /obj/effect/plasma_explosion/green(get_turf(src))
	explosion(get_turf(A),-1,0,2,5,guaranteed_damage = 50, guaranteed_damage_range = 2)
