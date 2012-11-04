  ////////////////////
 //ACTUAL CODE TIME//
////////////////////

//The simulator, and a global variable to halt the simulation.
var/physics/physics_sim = new
var/halt_physics = 0
var/list/star_names = list()

  ////////////////////////////////////////////
 //The heavy lifter itself, the simulation!//
////////////////////////////////////////////

physics
	var/real_time = 0 //Time according to the simulation. (I know, Absolute time is baaad)
	var/list/all_frames = list() //All simulated reference frames
	var/list/projectiles = list() //Holds projectile datums to be simulated
	var/list/solar_systems = list()
	var/list/simulated_solar_systems = list()
//	var/list/z_levels = list() //Frames associated with Z-levels. (Unused, currently.  Likely for spacewalks and planet landings)
	var/list/ships = list()

	var/physics_tree/quadtree = new(0,0,GIGAMETERS_PER_SIDE,1)
	var/frame/spawn_point //Will be the space station
	var/failed_ticks = 0
	var/debugging_file
	var/theta = 0.5 //Value that determines accuracy of the Barnes-Hut simulation.

	proc/Setup()
		world << "\red <B>Initializing physics simulation... </B>"
		debugging_file = file("[time2text(world.timeofday, "data/physics/DD-MM-YYYY.txt")]")
		debugging_file << "\nInstantiating a new round."

		var/solar_system/star = new(0,0,0,1)
		star.InitializeSim()
		star.StartSimulation()

		spawn Start()

	proc/Start() //The physics ticker.
		set background = 1
		while(1)
			var/start_time = world.realtime
			if(!halt_physics)
				var/result = Tick()
				if(!result)
					failed_ticks++
				if(failed_ticks >= 10) //10 seconds of failure!
					world << "<font color='red'><b>RUNTIME(S) in PHYSICS SIMULATION.  Killing <I>ISAAC NEWTON!</I></font></b>"
					#ifdef PHYSICS_DEBUG
					debugging_file << "Simulation halted, due to runtimes."
					#endif
					halt_physics = 1
			var/time_difference = world.realtime - start_time
			sleep( min( 10, max( 0, 10 - time_difference ) ) )

	proc/Tick()
		. = 0
		for(var/frame/frame in all_frames)
			//Acceleration for the frame
			var/delta_y = 0
			var/delta_x = 0
			if(frame.acceleration_x || frame.acceleration_y)
				delta_x = frame.acceleration_x*cos(frame.bearing) + frame.acceleration_y*sin(frame.bearing)
				delta_y = -frame.acceleration_x*sin(frame.bearing) + frame.acceleration_y*cos(frame.bearing)

			if(frame.mass)
				var/physics_tree/tree
				var/physics_node/current_node
				if(frame.solar_system) //traverse the tree the frame is in, and calculate the gravitation.
					tree = frame.solar_system.quadtree
				else
					tree = quadtree

				for(var/physics_node/node in tree.nodes)
					current_node = node
					do
						current_node.ReturnCenterOfMass()

						var/recurse_further = 0
						if(current_node.center_of_mass[1])
							var/dx = frame.x - current_node.center_of_mass[2]
							var/dy = frame.y - current_node.center_of_mass[3]
							var/distance = Dist(dx, dy)
							if(distance)

								if(current_node.side_length/distance < theta)
									var/attraction = Gravity(current_node.center_of_mass[1], distance)
									delta_x += dx*attraction/distance
									delta_y += dy*attraction/distance

								else if (current_node.contents)
									if(current_node.frames_with_considerable_mass && current_node.frames_with_considerable_mass.len)
										for(var/frame/massive_body in current_node.frames_with_considerable_mass)
											if(massive_body == frame)
												continue
											dx = frame.x - massive_body.x
											dy = frame.y - massive_body.y
											distance = Dist(dx, dy)
											var/attraction = Gravity(massive_body.mass, distance)
											delta_x += dx*attraction/distance
											delta_y += dy*attraction/distance

								else if(current_node.nodes)
									recurse_further = 1

								else
									current_node.SoftDelete() //No contents, no nothing!  REMOVE IT!

						if(recurse_further)
							for(var/i = 1 to 4)
								if(istype(current_node.nodes[i], /physics_node))
									current_node = current_node.nodes[i]
									break
						else
							while(istype(current_node.root))
								var/current_position = current_node.root.nodes.Find(current_node)
								var/new_node_found = 0
								if(current_position < 4)
									for(var/i = (current_position + 1) to 4)
										if(istype(current_node.root.nodes[i], /physics_node))
											current_node = current_node.root.nodes[i]
											new_node_found = 1
											break
								if(new_node_found)
									break
								else
									current_node = current_node.root
					while(istype(current_node.root))

			//Compute the velocity change per axis
			var/magnitude = Dist(frame.delta_x + delta_x, frame.delta_y + delta_y)
			var/new_velocity = VelocityAdd(Dist(frame.delta_x, frame.delta_y), Dist(delta_x, delta_y))
			delta_x += frame.delta_x
			delta_y += frame.delta_y

			frame.delta_x = new_velocity*delta_x/magnitude
			frame.delta_y = new_velocity*delta_y/magnitude

			//Compute the nodes the frame will be in for collision detection
			frame.last_collision_check = real_time
			frame.x += frame.delta_x
			frame.y += frame.delta_y
			var/list/nodes_backup

			//See if we are outside any node.  If so, we must compute the new nodes it will be in.
			for(var/physics_node/node in frame.nodes)
				if( frame.x + frame.delta_x >= node.x + node.side_length - frame.radius || frame.x + frame.delta_x < node.x + frame.radius \
				||  frame.y + frame.delta_y >= node.y + node.side_length - frame.radius || frame.y + frame.delta_y < node.y + frame.radius)
					nodes_backup = frame.nodes.Copy()

					//Determine if you are outside the current solar system (if any) for re-insertion into a quadtree.
					if(solar_system)
						if( frame.x < frame.solar_system.x + frame.solar_system.size_of_quadtree/2 - radius && x >= solar_system.x - solar_system.size_of_quadtree/2 + radius\
						&&  y < solar_system.y + solar_system.size_of_quadtree/2 - radius && y >= solar_system.y - solar_system.size_of_quadtree/2 + radius )
							frame.solar_system.quadtree.Insert(frame)
						else
							frame.solar_system = null
					if(!solar_system)
						physics_sim.quadtree.Insert(frame)

					frame.nodes_to_remove = backup_nodes - frame.nodes
					frame.nodes |= backup_nodes

			//We've computed all the new nodes, so reset positions.
			frame.x -= frame.delta_x
			frame.y -= frame.delta_y

		//Now, lets begin checking for collision.
		for(var/frame/frame in all_nodes)
			for(var/physics_node/node in frame.nodes)
				if(!node.contents || node.contents.len <= 1) //Only one frame, that's gotta be us!
					continue
				for(var/frame/collider in node.contents)
					//If the other one has already been checked, continue.
					if(collider.last_collision_check == real_time || collider == frame)
						continue

					//compute the edges of a rectangle containing the space the frame has traversed.
					var/frame_x1 = (frame.delta_x >= 0 ? frame.x - frame.radius : frame.x + frame.delta_x - frame.radius)
					var/frame_x2 = (frame.delta_x >= 0 ? frame.x + frame.delta_x + frame.radius : frame.x + frame.radius)
					var/frame_y1 = (frame.delta_y >= 0 ? frame.y - frame.radius : frame.y + frame.delta_y - frame.radius)
					var/frame_y2 = (frame.delta_y >= 0 ? frame.y + frame.delta_y + frame.radius : frame.y + frame.radius)

					var/collider_x1 = (collider.delta_x >= 0 ? collider.x - collider.radius : collider.x + collider.delta_x - collider.radius)
					var/collider_x2 = (collider.delta_x >= 0 ? collider.x + collider.delta_x + collider.radius : collider.x + collider.radius)
					var/collider_y1 = (collider.delta_y >= 0 ? collider.y - collider.radius : collider.y + collider.delta_y - collider.radius)
					var/collider_y2 = (collider.delta_y >= 0 ? collider.y + collider.delta_y + collider.radius : collider.y + collider.radius)

					if( frame_x1 > collider_x2 || collider_x1 > frame_x2 || frame_y1 > collider_y2 || collider_y1 > frame_y2 ) //If there is no overlap, move on to the next frame!
						continue

					//Now, Near phase!



		//Finally, preform the actual movement.
		for(var/frame/frame in all_frames)
			frame.x += frame.delta_x
			frame.y += frame.delta_y
			frame.bearing += frame.angular_velocity
			if(frame.bearing >= 360)
				frame.bearing -= 360
			else if(frame.bearing < 0)
				frame.bearing += 360
			if(frame.nodes_to_remove)
				for(var/physics_node/node in frame.nodes_to_remove)
					node.Remove(frame)
				frame.nodes -= frame.nodes_to_remove
				frame.nodes_to_remove = null

		real_time++
		. = 1

	proc/AddLevel(z, spawn_point = 1)


	proc/RemoveLevel(z)

	proc/AddFrame(frame/frame)
		if(frame.orbited_body)
			frame.orbited_body.solar_system.quadtree.Insert(frame) //Ohgod.  Essentially puts the frame in the correct quadtree.  The quadtree handles it from there.
		else
			quadtree.Insert(frame)
		all_frames.Add(frame)

	proc/RemoveFrame(frame/frame)
		for(var/physics_node/node in frame.nodes)
			node.Remove(frame)
		all_frames.Remove(frame)

	proc/AddSolarSystem(solar_system/solar_system)
		solar_systems.Add(solar_system)
		if(solar_system.active)
			simulated_solar_systems.Add(solar_system)
		quadtree.Insert(solar_system)

	proc/RemoveSolarSystem(solar_system/solar_system)
