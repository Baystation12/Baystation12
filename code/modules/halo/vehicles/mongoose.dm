#define MONGOOSE_BASE_PASSENGER_OFFSETS list("1" = list(0,13),"2" = list(0,13),"4" = list(-10,13),"8" = list(10,13))

/obj/vehicles/mongoose
	name = "M274 Ultra-Light All-Terrain Vehicle"
	desc = "Also known as the \"Mongoose\""

	icon = 'code/modules/halo/vehicles/mongoose.dmi'
	icon_state = "base"

	passengers = list(1)
	gunners = list(0)

	bound_height = 32
	bound_width = 32

	sprite_offsets = list("1" = list(0,3),"2" = list(0,3),"4" = list(0,3),"8" = list(0,3))
	damage_resistances = list("brute" = 30.0, "burn" = 25.0,"emp" = 15.0)

	controller = /datum/vehicle_control/base

	vehicle_move_delay = 1

	gunner_weapons = list()

/obj/vehicles/mongoose/render_mob_sprites()
	underlays.Cut()
	overlays.Cut()
	if(!driver && passengers.len <= 1)
		return
	var/image/passenger_image
	for(var/mob/M in passengers)
		passenger_image = image(M)
	var/image/driver_image = image(driver)
	var/list/offsets = list()
	if(num2text(dir) in sprite_offsets)
		offsets = sprite_offsets[num2text(dir)]
	if(offsets.len)
		driver_image.pixel_x = offsets[1]
		driver_image.pixel_y = offsets[2]
		if(passenger_image)
			var/list/passenger_offsets = MONGOOSE_BASE_PASSENGER_OFFSETS[num2text(dir)]
			passenger_image.pixel_x = offsets[1] + passenger_offsets[1]
			passenger_image.pixel_y = offsets[2] + passenger_offsets[2]
	if(dir == SOUTH)
		underlays += driver_image
		if(passenger_image)
			underlays += passenger_image
	else
		overlays += driver_image
		if(passenger_image)
			overlays += passenger_image

#undef MONGOOSE_BASE_PASSENGER_OFFSETS