#define MONGOOSE_BASE_PASSENGER_OFFSETS list("1" = list(0,13),"2" = list(0,13),"4" = list(-10,13),"8" = list(10,13))

/obj/vehicles/mongoose
	name = "M274 Ultra-Light All-Terrain Vehicle"
	desc = "Also known as the \"Mongoose\""

	icon = 'code/modules/halo/vehicles/types/mongoose.dmi'
	icon_state = "base"

	bound_height = 32
	bound_width = 32

	comp_prof = /datum/component_profile/mongoose

	occupants = list(1,0)
	exposed_positions = list("driver" = 5,"passenger" = 15)

	sprite_offsets = list("1" = list(0,3),"2" = list(0,3),"4" = list(0,3),"8" = list(0,3))

	vehicle_size = ITEM_SIZE_VEHICLE_SMALL

	light_color = "#E1FDFF"

	min_speed = 6
	max_speed = 2

/obj/vehicles/mongoose/update_object_sprites()
	underlays.Cut()
	overlays.Cut()
	var/list/offsets_to_use = sprite_offsets["[dir]"]
	var/list/drivers = get_occupants_in_position("driver")
	if(!(isnull(offsets_to_use) || isnull(drivers) || drivers.len == 0))
		var/image/driver_image = image(pick(drivers))
		driver_image.pixel_x = offsets_to_use[1]
		driver_image.pixel_y = offsets_to_use[2]
		if(dir == SOUTH || NORTH)
			underlays += driver_image
		else
			overlays += driver_image
	var/list/passengers = get_occupants_in_position("passenger")
	var/list/passenger_offset = MONGOOSE_BASE_PASSENGER_OFFSETS["[dir]"]

	if(isnull(passengers) || passengers.len == 0 || isnull(offsets_to_use))
		return
	for(var/mob/passenger in passengers)
		var/image/pass_img = image(passenger)
		pass_img.pixel_x = offsets_to_use[1] + passenger_offset[1]
		pass_img.pixel_y = offsets_to_use[2] + passenger_offset[2]
		if(dir == SOUTH)
			underlays += pass_img
		else
			overlays += pass_img

#undef MONGOOSE_BASE_PASSENGER_OFFSETS
//Mongoose component profile define//
/obj/item/vehicle_component/health_manager/mongoose
	integrity = 300
	resistances = list("brute"=85,"burn"=85,"emp"=15,"bomb" = 0)

/datum/component_profile/mongoose
	vital_components = newlist(/obj/item/vehicle_component/health_manager/mongoose)
