
/proc/init_pixel_transform(var/atom/movable/new_mover)
	var/datum/pixel_transform/pixel_transform = new()
	pixel_transform.control_object = new_mover
	pixel_transform.heading = dir2angle(new_mover.dir)
	new_mover.animate_movement = 0

	//pixel_transform.icon_base = new(new_mover.icon)
	//pixel_transform.icon_state = new_mover.icon_state
	//pixel_transform.icon_state_original = pixel_transform.icon_state

	return pixel_transform

/datum/pixel_transform
	var/atom/movable/control_object

	//var/icon/icon_base

	//var/icon_state
	//var/icon_state_original
	var/icon_state_thrust
	var/icon_state_brake
	var/thrust_left = 0

	//var/obj/effect/overmapobj/vehicle/my_overmap_object
	var/obj/effect/my_overmap_object
	var/icon/overmap_icon_base
	var/overmap_icon_state

	//var/obj/effect/loctracker

	var/pixel_speed_x = 0
	var/pixel_speed_y = 0
	var/pixel_progress_x = 0
	var/pixel_progress_y = 0

	/*var/omap_pixel_x = 0
	var/omap_pixel_y = 0*/

	var/heading = 180

	var/pixel_speed = 0
	var/max_pixel_speed = 10

	var/list/my_observers = list()

	var/update_interval = 1
	var/main_update_start_time = -1

/datum/pixel_transform/New()
	//quirky byond trig "fix" ... i should probably report this bug to dantom at some point
	pixel_speed_y = 0

/*/datum/pixel_transform/New()
	loctracker = new /obj/effect(src)
	loctracker.name = "loctracker"
	loctracker.layer = MOB_LAYER
	loctracker.icon = 'icons/obj/inflatable.dmi'
	loctracker.icon_state = "door_opening"*/

//unused for now
/*
/datum/pixel_transform/proc/set_pixel_speed(var/new_speed_x, var/new_speed_y)
	pixel_speed_x = new_speed_x
	pixel_speed_y = new_speed_y

	if(!is_still())
		update()
		*/

/datum/pixel_transform/proc/add_pixel_speed_forward(var/acceleration)
	add_pixel_speed_angle(acceleration, heading)

/datum/pixel_transform/proc/brake(var/acceleration)

	//can we take a shortcut here?
	if(pixel_speed <= acceleration)
		pixel_speed_x = 0
		pixel_speed_y = 0
		pixel_speed = 0
	else
		//calculate the exact speed loss
		var/target_speed = pixel_speed - acceleration
		var/speed_multiplier = target_speed / pixel_speed

		var/accel_x = pixel_speed_x * speed_multiplier - pixel_speed_x
		var/accel_y = pixel_speed_y * speed_multiplier - pixel_speed_y

		add_pixel_speed(accel_x, accel_y)

	return !is_still()

/datum/pixel_transform/proc/add_pixel_speed_direction(var/acceleration, var/direction)
	add_pixel_speed_angle(acceleration, dir2angle(direction))

/datum/pixel_transform/proc/add_pixel_speed_direction_relative(var/acceleration, var/relative_direction)
	add_pixel_speed_angle(acceleration, dir2angle(relative_direction) + heading)

/datum/pixel_transform/proc/add_pixel_speed_angle(var/acceleration, var/angle)
	//work out the x and y components according to our heading
	var/x_accel = sin(angle) * acceleration
	var/y_accel = cos(angle) * acceleration

	add_pixel_speed(x_accel, y_accel)

	//just spawn thrust regardless of heading, its easier than mucking about with multidirectional exhaust sprites for now
	//if(angle == heading)
	spawn_thrust()

/datum/pixel_transform/proc/add_pixel_speed(var/accel_x, var/accel_y)
	pixel_speed_x += accel_x
	pixel_speed_y += accel_y

	recalc_speed()
	limit_speed()

	if(!is_still())
		try_update()

/datum/pixel_transform/proc/limit_speed()
	//work out if we're getting close to max speed
	if(max_pixel_speed > 0)
		var/total_speed = get_speed()

		//we're over max speed, so normalise then cap the speed
		if(total_speed > max_pixel_speed)
			pixel_speed_x /= total_speed
			pixel_speed_x *= max_pixel_speed
			pixel_speed_y /= total_speed
			pixel_speed_y *= max_pixel_speed

			recalc_speed()

/datum/pixel_transform/proc/set_new_maxspeed(var/new_max_speed)
	var/total_speed = get_speed()
	max_pixel_speed = new_max_speed

	if(total_speed)
		pixel_speed_x /= total_speed
		pixel_speed_x *= max_pixel_speed
		pixel_speed_y /= total_speed
		pixel_speed_y *= max_pixel_speed
		recalc_speed()

/datum/pixel_transform/proc/is_still()
	return !(pixel_speed_x || pixel_speed_y)

/datum/pixel_transform/proc/get_speed()
	return pixel_speed

/datum/pixel_transform/proc/recalc_speed()
	pixel_speed = sqrt(pixel_speed_x * pixel_speed_x + pixel_speed_y * pixel_speed_y)

/datum/pixel_transform/proc/spawn_thrust()
	if(thrust_left)
		thrust_left = 8
	else
		thrust_left = 4
		control_object.overlays += icon_state_thrust

/*
/datum/pixel_transform/proc/enter_new_zlevel(var/obj/effect/overmapobj/target_obj)
	//if we have a separate overmap object, update its turf on the overmap
	if(my_overmap_object)

		//update the pixel_x offset
		my_overmap_object.pixel_x = 32 * (control_object.x / 255) - 16
		my_overmap_object.pixel_y = 32 * (control_object.y / 255) - 16
		/*if(my_overmap_object.x < target_obj.x)
			my_overmap_object.pixel_x = 0
		else if(my_overmap_object.x > target_obj.x)
			my_overmap_object.pixel_x = 32
		//update the pixel_y offset
		if(my_overmap_object.y < target_obj.y)
			my_overmap_object.pixel_y = 0
		else if(my_overmap_object.y > target_obj.y)
			my_overmap_object.pixel_y = 32*/

		//update the turf loc
		my_overmap_object.Move(target_obj.loc)
		//loctracker.loc = my_overmap_object.loc
*/
