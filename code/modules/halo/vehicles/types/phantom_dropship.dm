/obj/vehicles/air/overmap/phantom_dropship
	name = "Type-52 \"Phantom\" Troop Carrier"
	desc = "An agile dropship, ideal for quick deployment of troops has an underslung heavy plasma cannon."

	icon = 'code/modules/halo/vehicles/types/phantom.dmi'
	icon_state = "base"
	faction = "Covenant"

	can_space_move = 1
	density = 1

	bound_height = 128
	bound_width = 128

	pixel_x = -32
	pixel_y = -32

	takeoff_overlay_icon_state = "thrust"
	takeoff_sound = null
	overmap_range = 10

	move_sound = 'code/modules/halo/sounds/vehicle_sfx/phantom_move.ogg'

	comp_prof = /datum/component_profile/phantom

	spawn_datum = /datum/mobile_spawn/covenant
	ammo_containers = newlist(/obj/item/ammo_magazine/phantom_cannon)

	vehicle_size = ITEM_SIZE_VEHICLE_LARGE
	vehicle_carry_size = ITEM_SIZE_VEHICLE
	capacity_flag = ITEM_SIZE_VEHICLE_LARGE

	occupants = list(13,0)

	exposed_positions = list()

	light_color = "#C1CEFF"

	passive_tohit_boost = VEHICLE_ACCBOOST_LARGE

	can_smoke = 1
	smoke_ammo = 10
	smoke_ammo_max = 10
	smoke_step_dist = 0

	min_speed = 9.75
	max_speed = 2.25
	acceleration = 6
	drag = 5

	internal_air = new


/obj/vehicles/air/phantom_dropship/update_object_sprites()


/obj/item/vehicle_component/health_manager/phantom
	integrity = 600
	resistances = list("bullet"=80,"energy"=80,"emp"=50,"bomb"=60)
	repair_materials = list("nanolaminate")


/datum/component_profile/phantom
	pos_to_check = "driver"
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/phantom_main)
	vital_components = newlist(/obj/item/vehicle_component/health_manager/phantom)

/obj/item/weapon/gun/vehicle_turret/phantom_main
	name = "Heavy Plasma Cannon"
	desc = "A cannon that fires large bolts of plasma"

	fire_sound = 'code/modules/halo/sounds/spirit_firesound.ogg'

	fire_delay = 8

	burst = 10

	dispersion = list(0.15,0.3,0.45,0.5,0.55)

	magazine_type = /obj/item/ammo_magazine/phantom_cannon

/obj/item/ammo_magazine/phantom_cannon
	max_ammo = 100
	caliber = "phantomPlas"
	ammo_type = /obj/item/ammo_casing/phantom_cannon

/obj/item/ammo_casing/phantom_cannon
	name = "Internal Plasma Storage"
	caliber = "phantomPlas"
	projectile_type = /obj/item/projectile/bullet/covenant/phantom_cannon

/obj/item/projectile/bullet/covenant/phantom_cannon
	damage = 40
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "heavy_plas_cannon"

