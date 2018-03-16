/obj/vehicles/air/pelican
	name = "D77-TC Pelican"
	desc = "A versatile aircraft used by the UNSC for medium-lift operations of personnel, vehicles and equipment. It can also be used as a support gunship. An M370 Autocannon is mounted on the nose."

	icon = 'code/modules/halo/shuttles/pelican.dmi'
	icon_state = "base"
	vehicle_move_delay = 1.5

	density = 1

	bound_height = 128
	bound_width = 128

	pixel_x = -32
	pixel_y = -32

	takeoff_overlay_icon_state = "thrust"
	takeoff_sound = 'code/modules/halo/shuttles/pelican_takeoff.ogg'

	passengers = list(13)
	gunners = list(1)
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/pelican_autocannon)

	health = list(300,300) //Actually pretty fragile if you can get past the armor.
	exposed_positions = list("driver","passengers")//Passengers could technically be hit by bullets through the troop bay.
	damage_resistances = list("brute" = 70.0, "burn" = 65.0,"emp" = 50.0)//Brute resistance is equal to HMG bullets

/obj/vehicles/air/pelican/unsc
	faction = "unsc"

/obj/item/weapon/gun/vehicle_turret/pelican_autocannon
	name = "M370 Autocannon"

	icon = 'code/modules/halo/weapons/turrets/turret_items.dmi'
	icon_state = "chaingun_obj"
	item_state = "chaingun_obj"

	projectile_fired = /obj/item/projectile/bullet/hmg127_he

	fire_delay = 1.5 SECONDS

	burst = 5

/obj/vehicles/air/overmap/pelican
	name = "D77-TC Pelican"
	desc = "A versatile aircraft used by the UNSC for medium-lift operations of personnel, vehicles and equipment. It can also be used as a support gunship. An M370 Autocannon is mounted on the nose."

	icon = 'code/modules/halo/shuttles/pelican.dmi'
	icon_state = "base"
	vehicle_move_delay = 1.5

	density = 1

	bound_height = 128
	bound_width = 128

	pixel_x = -32
	pixel_y = -32

	overmap_range = 1

	takeoff_overlay_icon_state = "thrust"
	takeoff_sound = 'code/modules/halo/shuttles/pelican_takeoff.ogg'

	passengers = list(13)
	gunners = list(1)
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/pelican_autocannon)

	health = list(300,300) //Actually pretty fragile if you can get past the armor.
	exposed_positions = list("driver","passengers")//Passengers could technically be hit by bullets through the troop bay.
	damage_resistances = list("brute" = 70.0, "burn" = 65.0,"emp" = 50.0)//Brute resistance is equal to HMG bullets

/obj/vehicles/air/overmap/pelican/unsc
	faction = "unsc"

/obj/vehicles/air/pelican/civ
	desc = "A civilian pelican lacking in both weapons and armor."
	faction = "police"
	passengers = list(6)

	damage_resistances = list("brute" = 50.0, "burn" = 35.0,"emp" = 20.0)//Severely reduced resistances due to being civillian.

/obj/vehicles/air/pelican/innie
	desc = "A versatile aircraft used by the UNSC for medium-lift operations of personnel, vehicles and equipment. This one has a red fist painted onto the armor. A 40mm Chain-Gun is mounted on the nose."
	faction = "innie"
	passengers = list(13)
	gunners = list(1)
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/pelican_autocannon_innie)

	damage_resistances = list("brute" = 60.0, "burn" = 45.0,"emp" = 35.0)//Reduced resistances due to being innie-salvaged.

/obj/item/weapon/gun/vehicle_turret/pelican_autocannon_innie
	name = "40mm Chain-Gun"

	icon = 'code/modules/halo/weapons/turrets/turret_items.dmi'
	icon_state = "chaingun_obj"
	item_state = "chaingun_obj"

	projectile_fired = /obj/item/projectile/bullet/a762_ap

	fire_delay = 2.5 SECONDS

	burst = 7
