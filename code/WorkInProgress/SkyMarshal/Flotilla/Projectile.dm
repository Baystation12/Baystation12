
proc/lines_intersect(var/x1, var/y1, var/x2, var/y2, var/x3, var/y3, var/x4, var/y4)
	var/x12 = x1 - x2
	var/x34 = x3 - x4
	var/y12 = y1 - y2
	var/y34 = y3 - y4
	var/c = x12 * y34 - y12 * x34
	if(abs(c) <= 0.000001)
		return 0
	var/a = x1*y2 - y1*x2
	var/b = x3*y4 - y3*x4
	var/x = (a*x34 - b*x12)/c
	var/y = (a*y34 - b*y12)/c
	if(x >= x1 && x >= x3 && x <= x2 && x <= x4)
		if(y >= y1 && y >= y3 && y <= y2 && y <= y4)
			return 1
	return 0


//A projectile fired, put into it's own datum to improve calculation
projectile
	var
		acceleration_x = 0	//In kilometers per second per second, used by engines to accelerate the vessel.
		acceleration_y = 0	//Ditto
		delta_x = 0			//In kilometers per second, relative to the central station.  Used for constant velocity.
		delta_y = 0			//ditto
		x = 0				//In gigameters from the star it is orbiting.  IDK.  Will be determined when implemented.
		y = 0				//Ditto
		mass = 0	//In case it should be affected by gravity, in this case we assume it is a light beam.  Yottagrams.
		homing = 0 //In case the projectile is homing, and should self adjust itself.

		processing_ticks = 0	//How long it has been processing
		ticks_to_consider_deletion = 20	//~20 seconds of not hitting things before the game sees if it can be reliably deleted.
		defer_next_consideration = 0	//How long should we wait before reconsidering deletion?  In seconds.
		frame/target	//Self-explanatory

	New(frame/target_frame, var/frame/firer, launch_x, launch_y, initial_mass)
		. = ..()
		if(!physics_sim)  //OHGOD
			del src

		target = target_frame
		delta_x = VelocityAdd(firer.delta_x, launch_x)
		delta_y = VelocityAdd(firer.delta_y, launch_y)
		x = firer.x + delta_x
		y = firer.y + delta_y
		mass = initial_mass
		physics_sim.projectiles += src

	Del()
		if(physics_sim)
			physics_sim.projectiles -= src
		return ..()

	//Prototype procedures
	proc/Impact(var/turf/T)
		//Handles the projectile impacting T.
		del src //By default, deletes the projectile.

	proc/Tick()
		//Handles the projectile's updates as needed.  (Beam diffusion, homing missiles)
		processing_ticks++
		if(defer_next_consideration)
			defer_next_consideration--
		var/new_x = x + delta_x
		var/new_y = y + delta_y
//		lines_intersect(
		x = new_x
		y = new_y
		return
