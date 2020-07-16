
/obj/vehicles/air/overmap/sparrowhawk
	name = "AV-22 Sparrowhawk"
	desc = "The AV-22 is armed with twin-linked autocannons, with the original nose mounted spartan laser omitted in the place of two rocket pods."
	icon = 'code/modules/halo/vehicles/types/sparrowhawk.dmi'
	icon_state = "sparrowhawk"
	faction = "unsc"
	anchored = 1

	bound_height = 64
	bound_width = 64

	comp_prof = /datum/component_profile/sparrowhawk

	ammo_containers = newlist(/obj/item/ammo_magazine/hawk_autocannon,/obj/item/ammo_magazine/hawk_rockets)

	exposed_positions = list()

	occupants = list(0,0)

	vehicle_size = ITEM_SIZE_VEHICLE

	move_sound = null

	vehicle_view_modifier = 1.5

	light_color = "#C1CEFF"

	move_sound = 'code/modules/halo/sounds/sparrowhawk_move.ogg'

	min_speed = 16.75
	max_speed = 1.75
	acceleration = 5
	drag = 6

/obj/item/vehicle_component/health_manager/sparrowhawk
	integrity = 400
	resistances = list("bullet"=60,"energy"=60,"emp"=40,"bomb"=65)

/datum/component_profile/sparrowhawk
	pos_to_check = "driver"
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/switchable/hawk_gun)
	vital_components = newlist(/obj/item/vehicle_component/health_manager/sparrowhawk)


/obj/item/weapon/gun/vehicle_turret/switchable/hawk_gun
	name = "Sparrowhawk Autocannons"
	desc = "A set of twin linked, high calibre autocannons used for anti infantry and light anti-vehicle"

	fire_delay = 8
	burst = 5
	dispersion = list(0.15,0.3,0.45,0.6,0.73)
	fire_sound = 'code/modules/halo/sounds/Assault_Rifle_Fire_New.wav'

	guns_switchto = newlist(/datum/vehicle_gun/hawk_autocannon,/datum/vehicle_gun/hawk_rockets)
	magazine_type = /obj/item/ammo_magazine/hawk_autocannon

/datum/vehicle_gun/hawk_rockets
	name = "Mounted Rocket Launchers"
	desc = "A set of mounted rocket launchers, used for anti-vehicle and anti-group purposes."
	burst_size = 1
	fire_delay = 30
	dispersion = list(3)
	fire_sound = 'code/modules/halo/sounds/Rocket_Launcher_Fire_New.wav'
	mag_used = /obj/item/ammo_magazine/hawk_rockets

/datum/vehicle_gun/hawk_autocannon
	name = "Twin-Linked Autocannons"
	desc = "A vehicle mounted, twin-linked set of autocannons, used for anti-infantry and light anti-vehicle purposes."
	fire_delay = 8
	burst_size = 5
	dispersion = list(0.15,0.3,0.45,0.6,0.73)
	fire_sound = 'code/modules/halo/sounds/Assault_Rifle_Fire_New.wav'
	mag_used = /obj/item/ammo_magazine/hawk_autocannon

/obj/item/ammo_magazine/hawk_autocannon
	name = "Internal Autocannon Round Storage"
	caliber = "hawkCannon"
	max_ammo = 200
	ammo_type = /obj/item/ammo_casing/hawk_autocannon

/obj/item/ammo_casing/hawk_autocannon
	name = "autocannon round"
	projectile_type = /obj/item/projectile/bullet/a762_ap/hawk_mounted

/obj/item/projectile/bullet/a762_ap/hawk_mounted
	damage = 35
	armor_penetration = 20
	shield_damage = 10

/obj/item/ammo_magazine/hawk_rockets
	name = "Internal Sparrowhawk Rocket Storage"
	caliber = "hawkRockets"
	max_ammo = 10
	ammo_type = /obj/item/ammo_casing/hawk_rocket

/obj/item/ammo_casing/hawk_rocket
	name = "rocket"
	caliber = "hawkRockets"
	projectile_type = /obj/item/projectile/bullet/hawk_rocket

/obj/item/projectile/bullet/hawk_rocket
	name = "rocket"
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "ssr"
	check_armour = "bomb"
	step_delay = 1.2
	shield_damage = 150

/obj/item/projectile/bullet/hawk_rocket/on_impact(var/atom/impacted)
	explosion(get_turf(impacted), 0, 1, 3, 4,guaranteed_damage = 50,guaranteed_damage_range = 2)
	. = ..()