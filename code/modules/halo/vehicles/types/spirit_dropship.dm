/obj/vehicles/air/overmap/spirit_dropship
	name = "Type-25 \"Spirit\" Troop Carrier"
	desc = "A large, tuning fork shaped ship with a underslung heavy plasma cannon."

	icon = 'code/modules/halo/vehicles/types/spirit.dmi'
	icon_state = "base"
	faction = "covenant"
	can_space_move = 1
	density = 1

	bound_height = 128
	bound_width = 128

	pixel_x = 0
	pixel_y = 0

	takeoff_overlay_icon_state = "thrust"
	takeoff_sound = null
	overmap_range = 10

	comp_prof = /datum/component_profile/spirit

	occupants = list(14,0)

	exposed_positions = list()

	vehicle_size = ITEM_SIZE_VEHICLE_LARGE
	vehicle_carry_size = ITEM_SIZE_VEHICLE
	capacity_flag = ITEM_SIZE_VEHICLE_LARGE

	light_color = "#C1CEFF"

	can_smoke = 1
	smoke_ammo = 10
	smoke_ammo_max = 10
	smoke_step_dist = 0

	spawn_datum = /datum/mobile_spawn/covenant
	ammo_containers = newlist(/obj/item/ammo_magazine/spirit_cannon)

	min_speed = 9.75
	max_speed = 2.25
	acceleration = 6
	drag = 6

	internal_air = new

/obj/vehicles/air/overmap/spirit_dropship/update_object_sprites()
	. = ..()
	if(dir == NORTH || dir == SOUTH)
		bounds = "128,256"
	else
		bounds = "256,128"

//Pelican component profile define//
/obj/item/vehicle_component/health_manager/spirit
	integrity = 600
	resistances = list("bullet"=70,"energy"=70,"emp"=50,"bomb"=60)
	repair_materials = list("nanolaminate")

/datum/component_profile/spirit
	pos_to_check = "driver"
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/spirit_main)
	vital_components = newlist(/obj/item/vehicle_component/health_manager/spirit)

/obj/item/weapon/gun/vehicle_turret/spirit_main
	name = "Heavy Plasma Cannon"
	desc = "A cannon that fires large bolts of plasma"

	fire_sound = 'code/modules/halo/sounds/spirit_firesound.ogg'

	fire_delay = 8

	burst = 10

	dispersion = list(0.15,0.3,0.45,0.5,0.55)

	irradiate_non_cov = 12

	magazine_type = /obj/item/ammo_magazine/spirit_cannon

/obj/item/ammo_magazine/spirit_cannon
	max_ammo = 100
	caliber = "spiritPlas"
	ammo_type = /obj/item/ammo_casing/spirit_cannon

/obj/item/ammo_casing/spirit_cannon
	name = "Internal Plasma Storage"
	caliber = "spiritPlas"
	projectile_type = /obj/item/projectile/bullet/covenant/spirit_cannon

/obj/item/projectile/bullet/covenant/spirit_cannon
	damage = 40
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "heavy_plas_cannon"
