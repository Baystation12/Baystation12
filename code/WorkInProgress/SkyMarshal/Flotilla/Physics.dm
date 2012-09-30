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
//			var/start_time = world.realtime
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
		//	var/time_difference = world.realtime - start_time
		//	sleep( min( 10, max( 0, 10 - time_difference ) ) )
			sleep(prob(1))

	proc/Tick()
		. = 0
		var/list/delta_v
		for(var/frame/frame in all_frames)
			//Acceleration for the frame
			var/delta_y = 0
			var/delta_x = 0
			if(frame.acceleration_x || frame.acceleration_y)
				delta_x = frame.acceleration_x*cos(frame.bearing) + frame.acceleration_y*sin(frame.bearing)
				delta_y = -frame.acceleration_x*sin(frame.bearing) + frame.acceleration_y*cos(frame.bearing)

			if(frame.solar_system) //traverse the tree the frame is in, and calculate the gravitation.
				delta_v = frame.solar_system.quadtree.TraverseGravity(frame)
			else
				delta_v = quadtree.TraverseGravity(frame)
			delta_y += delta_v[2]
			delta_x += delta_v[1]
			#ifdef PHYSICS_DEBUG
			if(prob(prob(1)))
				debugging_file << "[frame.name] is being adjusted by [Dist(delta_x, delta_y)*1e9] m/s"
			#endif
			var/magnitude = Dist(frame.delta_x + delta_x, frame.delta_y + delta_y)
			var/new_velocity = VelocityAdd(Dist(frame.delta_x, frame.delta_y), Dist(delta_x, delta_y))
			delta_x += frame.delta_x
			delta_y += frame.delta_y

			frame.delta_x = new_velocity*delta_x/magnitude
			frame.delta_y = new_velocity*delta_y/magnitude


/*		for(var/projectile/projectile in projectiles)
			var/closest_frame = SPEED_OF_LIGHT //Stupid hack, finding closest frame
			//Acceleration for the frame
			var/delta_x = projectile.acceleration_x
			var/delta_y = projectile.acceleration_y
			if(!projectile.mass && (projectile.ticks_to_consider_deletion > projectile.processing_ticks || projectile.defer_next_consideration))
				continue
			for(var/frame/massive_body in frames_with_considerable_mass)  //I KNOW THIS IS HORRIBLE, BUT I AM TIRED AND CAN OPTIMMIZE LATER.
				var/dx = massive_body.x - projectile.x
				var/dy = massive_body.y - projectile.y
				var/distance = dist(dx, dy)
				closest_frame = min(closest_frame, distance)
				var/attraction = gravity(massive_body, distance)
				delta_x += dx*attraction/distance
				delta_y += dy*attraction/distance
			if(!projectile.mass)
				continue
			projectile.delta_x = vel_add(delta_x, projectile.delta_x)
			projectile.delta_y = vel_add(delta_y, projectile.delta_y)
			if(projectile.ticks_to_consider_deletion <= projectile.processing_ticks && !projectile.defer_next_consideration)
				if(closest_frame > PROJECTILE_DELETE_DISTANCE)
					del projectile
				else
					projectile.defer_next_consideration = 5*/
		//On to the movement phase!
		for(var/frame/frame in all_frames)
			frame.x += frame.delta_x
			frame.y += frame.delta_y
			frame.bearing += frame.angular_velocity
			if(frame.bearing >= 360)
				frame.bearing -= 360
			else if(frame.bearing < 0)
				frame.bearing += 360
			for(var/physics_node/node in frame.nodes)
				if( frame.x >= node.x + node.side_length - frame.radius || frame.x < node.x + frame.radius \
				||  frame.y >= node.y + node.side_length - frame.radius || frame.y < node.y + frame.radius)
					frame.ReInsert()
					break

		for(var/projectile/projectile in projectiles)
			projectile.Tick()
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
