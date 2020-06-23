
/obj/vehicles/ghost
	name = "Type-32 \"Ghost\" Rapid Assault Vehicle"
	desc = "A lightly armoured but fast vehicle capable of chasing fleeing targets and acting as a force multiplier."

	bound_height = 32
	bound_width = 32

	comp_prof = /datum/component_profile/ghost

	ammo_containers = newlist(/obj/item/ammo_magazine/ghost_internal)

	sprite_offsets = list("1" = list(16,2),"2" = list(16,2),"4" = list(10,2),"8" = list(22,2))

	occupants = list(0,0)
	exposed_positions = list("driver" = 0)

	pixel_x = -16

	icon = 'code/modules/halo/vehicles/types/ghost.dmi'
	icon_state = "base"

	vehicle_size = ITEM_SIZE_VEHICLE_SMALL

	move_sound = 'code/modules/halo/sounds/ghost_move.ogg'

	light_color = "#C1CEFF"

	min_speed = 6.25
	max_speed = 2.25
	drag = 1.25

/obj/vehicles/ghost/update_object_sprites()
	. = ..()
	var/list/offsets_to_use = sprite_offsets["[dir]"]
	var/list/drivers = get_occupants_in_position("driver")
	if(isnull(offsets_to_use) || isnull(drivers) || drivers.len == 0)
		return 0
	var/image/driver_image = image(pick(drivers))
	driver_image.pixel_x = offsets_to_use[1]
	driver_image.pixel_y = offsets_to_use[2]
	if(dir == SOUTH || NORTH)
		underlays += driver_image
	else
		overlays += driver_image

/obj/item/vehicle_component/health_manager/ghost
	integrity = 350
	resistances = list("brute"=85,"burn"=85,"emp"=15,"bomb" = 0)
	repair_materials = list("nanolaminate")

/datum/component_profile/ghost
	pos_to_check = "driver"
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/covenant/ghost)
	vital_components = newlist(/obj/item/vehicle_component/health_manager/ghost)

/obj/item/weapon/gun/vehicle_turret/covenant/ghost
	name = "Type-32 RAV Plasma Weapon"

	icon = 'code/modules/halo/weapons/turrets/turret_items.dmi'
	icon_state = "plasmaturret_obj"
	item_state = ""

	fire_sound = 'code/modules/halo/sounds/plasrifle3burst.ogg'
	burst_delay = 2
	fire_delay = 15

	burst = 4

	irradiate_non_cov = 10

	magazine_type = /obj/item/ammo_magazine/ghost_internal

/obj/item/ammo_magazine/ghost_internal
	name = "Internal Plasma Storage"

	max_ammo = 200
	caliber = "ghostPlas"
	ammo_type = /obj/item/ammo_casing/ghost_round

/obj/item/ammo_casing/ghost_round
	name = "ghost casing"
	caliber = "ghostPlas"
	projectile_type = /obj/item/projectile/bullet/covenant/plasmarifle