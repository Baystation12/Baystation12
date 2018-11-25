/obj/vehicles/air/overmap/spirit_dropship
	name = "Type-25 \"Spirit\" Troop Carrier"
	desc = "A large, tuning fork shaped ship with a underslung heavy plasma cannon."

	icon = 'code/modules/halo/vehicles/spirit.dmi'
	icon_state = "base"
	vehicle_move_delay = 1.45
	faction = "covenant"
	density = 1

	bound_height = 128
	bound_width = 128

	pixel_x = 0
	pixel_y = 0

	takeoff_overlay_icon_state = "thrust"
	takeoff_sound = null

	comp_prof = /datum/component_profile/spirit

	occupants = list(15,0)

	exposed_positions = list()//No-one can get hit when inside this.

	vehicle_size = 128

	overmap_range = 2

	vehicle_view_modifier = 1.3

/obj/vehicles/air/overmap/spirit_dropship/proc/update_pixel_xy()
	pixel_x = 0
	pixel_y = 0
	bounds = "32,32"
	switch (dir)
		if(SOUTH)
			pixel_x = -19
			bounds = "128,160"
		if(NORTH)
			pixel_x = -19
			bounds = "128,160"
		if(EAST)
			pixel_y = -19
			bounds = "160,128"
		if(WEST)
			pixel_y = -19
			bounds = "160,128"

/obj/vehicles/air/overmap/spirit_dropship/update_object_sprites()
	update_pixel_xy()

//Pelican component profile define//
/obj/item/vehicle_component/health_manager/spirit
	integrity = 300
	resistances = list("brute"=30,"burn"=30,"emp"=40)

/datum/component_profile/spirit
	pos_to_check = "driver"
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/spirit_main)
	vital_components = newlist(/obj/item/vehicle_component/health_manager/spirit)
	cargo_capacity = 24
	max_vehicle_size = 64
	vehicle_capacity = 32

/obj/item/weapon/gun/vehicle_turret/spirit_main
	name = "Heavy Plasma Cannon"
	desc = "A cannon that fires large bolts of plasma"

	fire_sound = 'code/modules/halo/sounds/spirit_firesound.ogg'
	projectile_fired = /obj/item/projectile/covenant/spirit_cannon

	fire_delay = 1.75 SECONDS

	burst = 3

/obj/item/projectile/covenant/spirit_cannon
	damage = 70
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "heavy_plas_cannon"

/obj/item/projectile/covenant/spirit_cannon/on_impact(var/atom/impacted)
	explosion(impacted,-1,-1,1,3)
