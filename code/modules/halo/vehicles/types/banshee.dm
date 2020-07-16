
/obj/vehicles/air/overmap/banshee
	name = "Type-26 Ground Support Aircraft"
	desc = "The Type-26 is armed with twin linked plasma cannons for infantry elimination, with a singlular, mid-mounted fuel rod cannon for anti-vehicle or anti-group use."
	icon = 'code/modules/halo/vehicles/types/banshee.dmi'
	icon_state = "banshee"
	faction = "covenant"
	anchored = 1

	bound_height = 64
	bound_width = 64

	comp_prof = /datum/component_profile/banshee

	ammo_containers = newlist(/obj/item/ammo_magazine/banshee_plas,/obj/item/ammo_magazine/banshee_fuel)

	exposed_positions = list()

	occupants = list(0,0)

	vehicle_size = ITEM_SIZE_VEHICLE

	move_sound = null

	vehicle_view_modifier = 1.5

	light_color = "#C1CEFF"
	pixel_x = -16
	pixel_y = -16

	move_sound = 'code/modules/halo/sounds/banshee_move.ogg'

	min_speed = 16.75
	max_speed = 1.75
	acceleration = 5
	drag = 6

/obj/item/vehicle_component/health_manager/banshee
	integrity = 400
	resistances = list("bullet"=60,"energy"=60,"emp"=40,"bomb"=65)
	repair_materials = list("nanolaminate")

/datum/component_profile/banshee
	pos_to_check = "driver"
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/switchable/banshee_gun)
	vital_components = newlist(/obj/item/vehicle_component/health_manager/banshee)

/obj/item/weapon/gun/vehicle_turret/switchable/banshee_gun
	name = "Banshee Twin-Linked Plasma Cannons"
	desc = "A set of twin linked plasma cannons used for anti infantry and light anti-vehicle"

	fire_delay = 8
	burst = 5
	dispersion = list(0.15,0.3,0.45,0.6,0.73)
	fire_sound = 'code/modules/halo/sounds/plasrifle3burst.ogg'

	guns_switchto = newlist(/datum/vehicle_gun/banshee_plas,/datum/vehicle_gun/banshee_fuel)
	magazine_type = /obj/item/ammo_magazine/banshee_plas
	irradiate_non_cov = 15

/datum/vehicle_gun/banshee_fuel
	name = "Mounted Fuel Rod Cannon"
	desc = "A higher-power fuel rod cannon, mounted on a vehicle. Used for anti-vehicle and anti-group attacks."
	burst_size = 1
	fire_delay = 30
	dispersion = list(3)
	fire_sound = 'code/modules/halo/sounds/wraith_cannon_fire.ogg'
	mag_used = /obj/item/ammo_magazine/banshee_fuel

/datum/vehicle_gun/banshee_plas
	name = "Twin-Linked Plasma Cannons"
	desc = "A vehicle mounted, twin-linked plasma cannon. Useful for anti-infantry and light anti-vehicle."
	fire_delay = 8
	burst_size = 5
	dispersion = list(0.15,0.3,0.45,0.6,0.73)
	fire_sound = 'code/modules/halo/sounds/plasrifle3burst.ogg'
	mag_used = /obj/item/ammo_magazine/banshee_plas

/obj/item/ammo_magazine/banshee_plas
	name = "Internal Plasma Storage"
	caliber = "bansheePlas"
	max_ammo = 200
	ammo_type = /obj/item/ammo_casing/banshee_plas

/obj/item/ammo_casing/banshee_plas
	name = "plasma capsule"
	projectile_type = /obj/item/projectile/bullet/covenant/plasmarifle/banshee_mounted

/obj/item/projectile/bullet/covenant/plasmarifle/banshee_mounted
	armor_penetration = 20
	shield_damage = 10

/obj/item/ammo_magazine/banshee_fuel
	name = "Internal Fuel Rod Storage"
	caliber = "bansheeFuel"
	max_ammo = 10
	ammo_type = /obj/item/ammo_casing/banshee_fuel

/obj/item/ammo_casing/banshee_fuel
	name = "banshee fuel rod capsule"
	caliber = "bansheeFuel"
	projectile_type = /obj/item/projectile/bullet/covenant/banshee_fuel

/obj/item/projectile/bullet/covenant/banshee_fuel
	name = "fuel rod capsule"
	icon = 'code/modules/halo/weapons/icons/Covenant_Projectiles.dmi'
	icon_state = "Overcharged_Plasmapistol shot"
	check_armour = "bomb"
	step_delay = 1.2
	shield_damage = 150
	dispersion = list(3)
	muzzle_type = /obj/effect/projectile/muzzle/cov_green

/obj/item/projectile/bullet/covenant/banshee_fuel/on_impact(var/atom/impacted)
	explosion(get_turf(impacted), 0, 1, 3, 4,guaranteed_damage = 50,guaranteed_damage_range = 2)
	. = ..()
