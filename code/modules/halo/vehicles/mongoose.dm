#define MONGOOSE_BASE_PASSENGER_OFFSETS list("1" = list(0,0),"2" = list(0,0),"4" = list(0,0),"8" = list(0,0))

/obj/vehicles/mongoose
	name = " M274 Ultra-Light All-Terrain Vehicle"
	desc = "Also know as the \"Mongoose\""

	passengers = list(1)
	gunners = list(0)

	bound_height = 32
	bound_width = 32

	sprite_offsets = list("1" = list(0,0),"2" = list(0,0),"4" = list(0,0),"8" = list(0,0))

	controller = /datum/vehicle_control/base

	vehicle_move_delay = 1

	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/covenant/ghost)
	icon = 'code/modules/halo/vehicles/ghost.dmi'
	icon_state = "base"

/obj/vehicles/mongoose/render_mob_sprites()
	underlays.Cut()
	if(!driver)
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

	underlays += driver_image
	if(passenger_image)
		underlays += passenger_image

#undef MONGOOSE_BASE_PASSENGER_OFFSETS