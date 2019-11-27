/obj/vehicles/air/overmap/spirit_dropship
	name = "Type-25 \"Spirit\" Troop Carrier"
	desc = "A large, tuning fork shaped ship with a underslung heavy plasma cannon."

	icon = 'code/modules/halo/vehicles/spirit.dmi'
	icon_state = "base"
	vehicle_move_delay = 1.2
	faction = "covenant"
	density = 1

	bound_height = 128
	bound_width = 128

	pixel_x = 0
	pixel_y = 0

	takeoff_overlay_icon_state = "thrust"
	takeoff_sound = null

	comp_prof = /datum/component_profile/spirit

	occupants = list(14,1)

	exposed_positions = list()//No-one can get hit when inside this.

	vehicle_size = 128

	light_color = "#C1CEFF"

/obj/vehicles/air/overmap/spirit_dropship/update_object_sprites()
	. = ..()
	if(dir == NORTH || dir == SOUTH)
		bounds = "128,256"
	else
		bounds = "256,128"

//Pelican component profile define//
/obj/item/vehicle_component/health_manager/spirit
	integrity = 750
	resistances = list("brute"=50,"burn"=40,"emp"=40,"bomb"=50)
	repair_materials = list("nanolaminate")

/datum/component_profile/spirit
	pos_to_check = "gunner"
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/spirit_main)
	vital_components = newlist(/obj/item/vehicle_component/health_manager/spirit)
	cargo_capacity = 48 //Can hold, at max, 9 normals
	max_vehicle_size = 64
	vehicle_capacity = 64
	cargo_allow_massive = 1

/obj/item/weapon/gun/vehicle_turret/spirit_main
	name = "Heavy Plasma Cannon"
	desc = "A cannon that fires large bolts of plasma"

	fire_sound = 'code/modules/halo/sounds/spirit_firesound.ogg'
	projectile_fired = /obj/item/projectile/covenant/spirit_cannon

	fire_delay = 1.75 SECONDS

	burst = 3

	irradiate_non_cov = 12

/obj/item/projectile/covenant/spirit_cannon
	damage = 50
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "heavy_plas_cannon"

/obj/item/projectile/covenant/spirit_cannon/on_impact(var/atom/impacted)
	explosion(impacted,-1,-1,1,3,guaranteed_damage = 30,guaranteed_damage_range = 1)
