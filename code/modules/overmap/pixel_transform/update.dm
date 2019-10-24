
/datum/pixel_transform/proc/update(var/delta_time)

	if(!control_object || !control_object.loc)
		return 0

	if(is_still())
		return 0

	//apply translation as speed * dt
	pixel_progress_x += pixel_speed_x * delta_time
	pixel_progress_y += pixel_speed_y * delta_time

	//here's something you dont see often
	//update movement along the x and y axes using do/whiles
	var/x_iters = 0
	var/result = 0
	do
		result = update_x()
		x_iters++
	while(result)
	//
	var/y_iters = 0
	do
		result = update_y()
		y_iters++
	while(result)

	//just in case
	if(y_iters > 1 || x_iters > 1)
		testing("[control_object] controlled by [usr](?) just ran nonstandard update loop with x_iters:[x_iters] and y_iters:[y_iters]")

	//move observers smoothly with each pixel
	for(var/mob/M in my_observers)
		if(M.client)
			if(M.client.eye == control_object)
				M.client.pixel_x = control_object.pixel_x
				M.client.pixel_y = control_object.pixel_y
			else
				my_observers -= M

	/*
	if(my_overmap_object)
		for(var/mob/M in my_overmap_object.my_observers)
			if(M.client)
				if(M.client.eye == my_overmap_object)
					M.client.pixel_x = my_overmap_object.pixel_x
					M.client.pixel_y = my_overmap_object.pixel_y
			else
				my_overmap_object.my_observers -= M
	*/

	if(thrust_left > 0)
		thrust_left -= delta_time
		if(thrust_left <= 0)
			thrust_left = 0
			control_object.overlays -= icon_state_thrust

	return 1

/datum/pixel_transform/proc/update_loop(var/my_update_start_time = -1)

	if(main_update_start_time < 0)
		my_update_start_time = world.time
		main_update_start_time = my_update_start_time
	else if(my_update_start_time != main_update_start_time)
		return

	if(update(update_interval))
		spawn(update_interval)
			update_loop(my_update_start_time)
	else
		main_update_start_time = -1

/datum/pixel_transform/proc/try_update()
	//if our control_object has a custom update loop, use that
	/*
	if(istype(control_object, /obj/machinery/overmap_vehicle))
		var/obj/machinery/overmap_vehicle/overmap_vehicle = control_object
		overmap_vehicle.update()
	else
		//otherwise just use our internal one
		update_loop()
		*/
	update_loop()
