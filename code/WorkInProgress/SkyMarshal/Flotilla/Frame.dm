//The frame representing an object for the physics simulation
frame
	var
		name = "default"
		desc = "default"

		acceleration_x = 0	//In kilometers per second per second, used by engines to accelerate the vessel.
		acceleration_y = 0	//Ditto
		delta_x = 0			//In kilometers per second, relative to the central station.  Used for constant velocity.
		delta_y = 0			//ditto
		x = 0				//In gigameters from the star it is orbiting.  IDK.  Will be determined when implemented.
		y = 0				//Ditto

		bearing = 0			//In degrees.  The Y+ axis is 0, increasing clockwise.
		angular_velocity = 0//Degrees/second

		gravitational_range = 0
		mass = 1e-18			//No runtimes, kthx.  In Yottagrams, mass of the frame.  (Approximated, mobs and crap do not affect mass.)
		density = 0
		radius = 0			//in Gigameters

		albedo = 0
		opacity = 0
		luminosity = 0

		incorporeal = 0

		ship/ship
		frame/orbited_body
		list/frame/orbiting_bodies
		list/nodes
		solar_system/solar_system


	New(new_name, new_desc, position_x, position_y, velocity_x, velocity_y, new_angular_velocity, new_mass, new_density, frame/new_orbited_body, list/associated_levels)
		. = ..()
		if(!physics_sim)  //OHGOD
			#ifdef PHYSICS_DEBUG
			world.log <<"Deleting [new_name] as no physics_sim."
			#endif
			del src

		name = new_name
		desc = new_desc
		x = position_x
		y = position_y
		delta_x = velocity_x
		delta_y = velocity_y

		angular_velocity = new_angular_velocity

		mass = new_mass
		density = new_density
		radius = Radius(mass, density)

		if(istype(new_orbited_body))
			orbited_body = new_orbited_body
			solar_system = orbited_body.solar_system
			var/orbital_direction = pick(CLOCKWISE, ANTICLOCKWISE)
			var/list/orbit = GetVectorToOrbit(orbited_body, x, y, orbital_direction )
			delta_x += orbit["x"]
			delta_y += orbit["y"]
			orbit = GetVectorToOrbit(src, orbited_body.x, orbited_body.y, orbital_direction )
			orbited_body.delta_x += orbit["x"]
			orbited_body.delta_y += orbit["y"]
			if(!orbited_body.orbiting_bodies)
				orbited_body.orbiting_bodies = list(src)
			else
				orbited_body.orbiting_bodies += src

//		if(islist(associated_levels) && associated_levels.len)
//			z_levels = associated_levels

		if(mass >= MINIMUM_MASS_TO_CONSIDER_ATTRACTION)
			gravitational_range = InverseGravity(mass)


		#ifdef PHYSICS_DEBUG
		physics_sim.debugging_file << "[name]: Gravitational range: [gravitational_range]; Mass: [mass]; Position: ([x],[y])"
		#endif

		return


	Del()
		if(physics_sim)  //OHGOD
			physics_sim.RemoveFrame(src)
		if(solar_system)
			solar_system.Remove(src)
		if(nodes)
			for(var/physics_node/node in nodes)
				node.Remove(src)
		if(orbited_body)
			orbited_body.orbiting_bodies -= src
			if(!orbited_body.orbiting_bodies.len)
				orbited_body.orbiting_bodies = null
		if(orbiting_bodies && orbiting_bodies.len)
			for(var/frame/frame in orbiting_bodies)
				frame.orbited_body = null
		. = ..()


	proc/ReInsert()
		for(var/physics_node/node in nodes)
			node.Remove(src)
		if(solar_system)
			if( x < solar_system.x + solar_system.size_of_quadtree/2 - radius && x >= solar_system.x - solar_system.size_of_quadtree/2 + radius\
			&&  y < solar_system.y + solar_system.size_of_quadtree/2 - radius && y >= solar_system.y - solar_system.size_of_quadtree/2 + radius )
				solar_system.quadtree.Insert(src)
				return
			else
				solar_system = null
		physics_sim.quadtree.Insert(src)
