/* 
plot_vector is a helper datum for plotting a path in a straight line towards a target turf.
This datum converts from world space (turf.x and turf.y) to pixel space, which the datum keeps track of itself. This
should work with any size turfs (i.e. 32x32, 64x64) as it references world.icon_size (note: not actually tested with
anything other than 32x32 turfs).

setup()
	This should be called after creating a new instance of a plot_vector datum.
	This does the initial setup and calculations. Since we are travelling in a straight line we only need to calculate 
	the	vector and x/y steps once. x/y steps are capped to 1 full turf, whichever is further. If we are travelling along
	the y axis each step will be +/- 1 y, and the x movement reduced based on the angle (tangent calculation). After
	this every subsequent step will be incremented based on these calculations.
	Inputs:
		source - the turf the object is starting from
		target - the target turf the object is travelling towards
		xo - starting pixel_x offset, typically won't be needed, but included in case someone has a need for it later
		yo - same as xo, but for the y_pixel offset

increment()
	Adds the offset to the current location - incrementing it by one step along the vector.

return_angle()
	Returns the direction (angle in degrees) the object is travelling in.
	* North = 90°
	* East  = 0°
	* South = -90°
	* West  = 180°

return_hypotenuse()
	Returns the distance of travel for each step of the vector, relative to each full step of movement. 1 is a full turf 
	length. Currently used as a multiplier for scaling effects that should be contiguous, like laser beams.

return_location()
	Returns a vector_loc datum containing the current location data of the object (see /datum/vector_loc). This includes 
	the turf it currently should be at, as well as the pixel offset from the centre of that turf. Typically increment() 
	would be called before this if you are going to move an object based on it's vector data.
*/

/datum/plot_vector
	var/turf/source
	var/turf/target
	var/angle = 0	// direction of travel in degrees
	var/loc_x = 0	// in pixels from the left edge of the map
	var/loc_y = 0	// in pixels from the bottom edge of the map
	var/loc_z = 0	// loc z is in world space coordinates (i.e. z level) - we don't care about measuring pixels for this
	var/offset_x = 0	// distance to increment each step
	var/offset_y = 0

/datum/plot_vector/proc/setup(var/turf/S, var/turf/T, var/xo = 0, var/yo = 0, var/angle_offset=0)
	source = S
	target = T
	
	if(!istype(source))
		source = get_turf(source)
	if(!istype(target))
		target = get_turf(target)	

	if(!istype(source) || !istype(target))
		return

	// convert coordinates to pixel space (default is 32px/turf, 8160px across for a size 255 map)
	loc_x = source.x * world.icon_size + xo
	loc_y = source.y * world.icon_size + yo
	loc_z = source.z
	
	// calculate initial x and y difference
	var/dx = target.x - source.x
	var/dy = target.y - source.y

	// if we aren't moving anywhere; quit now
	if(dx == 0 && dy == 0)
		return

	// calculate the angle
	angle = Atan2(dx, dy) + angle_offset

	// and some rounding to stop the increments jumping whole turfs - because byond favours certain angles
	if(angle > -135 && angle < 45)
		angle = Ceiling(angle)
	else
		angle = Floor(angle)

	// calculate the offset per increment step
	if(abs(angle) in list(0, 45, 90, 135, 180))		// check if the angle is a cardinal
		if(abs(angle) in list(0, 45, 135, 180))		// if so we can skip the trigonometry and set these to absolutes as
			offset_x = sign(dx)						// they will always be a full step in one or more directions
		if(abs(angle) in list(45, 90, 135))
			offset_y = sign(dy)
	else if(abs(dy) > abs(dx))
		offset_x = Cot(abs(angle))					// otherwise set the offsets
		offset_y = sign(dy)
	else
		offset_x = sign(dx)
		offset_y = Tan(angle)
		if(dx < 0)
			offset_y = -offset_y

	// multiply the offset by the turf pixel size
	offset_x *= world.icon_size
	offset_y *= world.icon_size

/datum/plot_vector/proc/increment()
	loc_x += offset_x
	loc_y += offset_y

/datum/plot_vector/proc/return_angle()
	return angle

/datum/plot_vector/proc/return_hypotenuse()
	return sqrt(((offset_x / 32) ** 2) + ((offset_y / 32) ** 2))

/datum/plot_vector/proc/return_location(var/datum/vector_loc/data)
	if(!data)
		data = new()
	data.loc = locate(round(loc_x / world.icon_size, 1), round(loc_y / world.icon_size, 1), loc_z)
	if(!data.loc)
		return
	data.pixel_x = loc_x - (data.loc.x * world.icon_size)
	data.pixel_y = loc_y - (data.loc.y * world.icon_size)
	return data

/* 
vector_loc is a helper datum for returning precise location data from plot_vector. It includes the turf the object is in
as well as the pixel offsets.

return_turf()
	Returns the turf the object should be currently located in.
*/
/datum/vector_loc
	var/turf/loc
	var/pixel_x
	var/pixel_y

/datum/vector_loc/proc/return_turf()
	return loc
