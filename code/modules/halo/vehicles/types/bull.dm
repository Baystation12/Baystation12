
/obj/vehicles/bull
	name = "Bull APC"
	desc = "An old APC chassis with modern modifications and a mounted machine gun."

	icon = 'code/modules/halo/vehicles/types/Bull.dmi'
	icon_state = "bull"
	anchored = 1

	bound_height = 64
	bound_width = 96

	comp_prof = /datum/component_profile/bull

	ammo_containers = newlist(/obj/item/ammo_magazine/warthog_mag)


	occupants = list(4,1)
	exposed_positions = list("driver" = 0,"gunner" = 0)

	vehicle_carry_size = ITEM_SIZE_VEHICLE_SMALL
	capacity_flag = ITEM_SIZE_VEHICLE

	move_sound = 'code/modules/halo/sounds/warthog_move.ogg'

	light_color = "#FEFFE1"

	min_speed = 8.75
	max_speed = 2.75

/obj/vehicles/bull/update_object_sprites()
	. = ..()
	pixel_x = 0
	if(dir == WEST)
		pixel_x = -32

/obj/vehicles/bull/on_death()
	. = ..()
	guns_disabled = 0

/obj/item/vehicle_component/health_manager/bull
	integrity = 500
	resistances = list("bullet"=80,"energy"=80,"emp"=30,"bomb"=50)

/datum/component_profile/bull
	pos_to_check = "gunner"
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/warthog_turret)
	vital_components = newlist(/obj/item/vehicle_component/health_manager/bull)