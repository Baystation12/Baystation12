//The physics datum, that controls movement of the "local space" around ships and their contents as they move through space.
//Distances are in 10^9th meters
//Acceleration is in km/s^2
//Velocity is in Mm/s
//Mass is in Yottagrams, 10^24th grams
//Force in Yottanewtons.  10^21 kgm/s^2
//Bearings are in degrees.

#define GRAVITATIONAL_CONSTANT (6.67384e-11) //(m^3)/kg(s^2)
//Function to add two velocities in accordance with relativity.  Sanity is goood.  .6c +.5c = ~.85c
#define vel_add(x,y) ((x + y)/(1 + ((x*y*1e18)/SPEED_OF_LIGHT_SQ)))
#define gravity(attractor, distance)  ((GRAVITATIONAL_CONSTANT*attractor.mass)/(((distance)**2)*1e6)) //Source is a frame, distance is... self-explanatory
#define dist(x,y) sqrt((x)**2 + (y)**2)
#define orbital_velocity(orbited_mass, distance) sqrt((orbited_mass * GRAVITATIONAL_CONSTANT)/(distance*1e6))
#define lorentz_factor(dx, dy) (1/sqrt(1 - (dist(dx,dy)**2)/SPEED_OF_LIGHT_SQ))
#define momentum(mass,dx,dy) ((1e9)*mass*dist(dx,dy)*lorentz_factor(dx, dy))

#define MINUMUM_ATTRACTION_TO_CONSIDER 1e-21
#define inverse_gravity(mass) sqrt((GRAVITATIONAL_CONSTANT*mass)/(MINUMUM_ATTRACTION_TO_CONSIDER*1e6))

#define STAR_MASS (1.631062e9)
#define STAR_DEVIATION (1.59128e8)
#define NUMBER_OF_PLANETS_MIN 1
#define NUMBER_OF_PLANETS_MAX 4
#define PLANET_MASS_MIN 330
#define PLANET_MASS_MAX (1.898e6)
#define PLANET_CLOSEST_ORBIT 69
#define PLANET_FARTHEST_ORBIT 4553

#define MOON_CHANCE 100
#define MOON_MAX_SIZE 73.477
#define MOON_MIN_SIZE (1.072e-5)
#define MOON_CLOSEST_ORBIT (9.518e-3)
#define MOON_FARTHEST_ORBIT (4.0541e-1)

#define MINIMUM_MASS_TO_CONSIDER_ATTRACTION 1
#define ORBITAL_VECTOR_DEVATION 0.005 //Percent from "circular"
#define SOLAR_SYSTEM_NAME "Epsilon Erandi"

#define PROJECTILE_DELETE_DISTANCE 3

var/physics/physics_sim = new
var/halt_physics = 0
var/list/solar_descriptions = ("A small orange-yellow star, cooler than Sol.  It looks... wrong.")
var/list/planetary_descriptions = ("A rocky body, totally uninteresting.")

mob/verb/get_physics_reference()
	set src = usr
	for(var/frame/frame in physics_sim.all_frames)
		world << "[frame.name] Velocity: [sqrt(frame.delta_x**2 + frame.delta_y**2)*1e6]km/s"

mob/verb/debug_variables_reference()
	set src = usr
	var/tag = input("GIMME DAT TAG","View Variables","\ref[physics_sim]") as text
	var/datum/D = locate(tag)
	if(D)
		usr.client.debug_variables(D)

proc/get_rand(LB=0,UB=0)
	if(UB > LB)
		return LB + (UB-LB)*rand()
	else if (LB > UB)
		return UB + (LB-UB)*rand()
	return LB //They are equal.

physics
	var
		real_time = 0 //Time according to the simulation. (I know, Absolute time is baaad)
		list
			all_frames = list() //All simulated reference frames
			projectiles = list() //Holds projectile datums to be simulated
			frames_with_considerable_mass = list() //We only compute the gravitational attraction of these frames.
			z_levels = list() //Frames associated with Z-levels.
		frame/spawn_point //Will be the space station
		failed_ticks = 0

	#define CLOCKWISE 1
	#define ANTICLOCKWISE -1

	proc/Setup()
		world << "\red <B>Initializing physics simulation... </B>"

		//Make the sun
		var/frame/sun = new(SOLAR_SYSTEM_NAME, pick(solar_descriptions), 0, 0, 0, 0, 0, 1, STAR_MASS + get_rand(-STAR_DEVIATION, STAR_DEVIATION), 0)

		for(var/i = 1 to rand(NUMBER_OF_PLANETS_MIN, NUMBER_OF_PLANETS_MAX))
			var/name = "[SOLAR_SYSTEM_NAME] [i]"
			var/mass = get_rand(PLANET_MASS_MIN, PLANET_MASS_MAX)
			var/stealth = max(0.8, mass/PLANET_MASS_MAX)
			var/distance = get_rand(PLANET_CLOSEST_ORBIT, PLANET_FARTHEST_ORBIT)
			var/bearing = rand(0, 360)
			var/x = distance*cos(bearing)
			var/y = distance*sin(bearing)
			var/list/orbit = GetVectorToOrbit(sun, x, y, mass, pick(CLOCKWISE, ANTICLOCKWISE) )
			world.log << "[name] Velocity = [sqrt(orbit["x"]**2 + orbit["y"]**2)]"
			var/frame/planet = new(name, pick(planetary_descriptions), x, y, orbit["x"], orbit["y"], 0, get_rand(-1,1), mass, stealth)
			if(prob(MOON_CHANCE))
				name += "A"
				mass = get_rand(MOON_MIN_SIZE, MOON_MAX_SIZE)
				stealth = 0.6
				distance = get_rand(MOON_CLOSEST_ORBIT, MOON_FARTHEST_ORBIT)
				bearing = rand(0, 360)
				x += distance*cos(bearing)
				y += distance*sin(bearing)
				var/list/new_orbit = GetVectorToOrbit(planet, x, y, mass, pick(CLOCKWISE, ANTICLOCKWISE) )
				new /frame(name, pick(planetary_descriptions), x, y, orbit["x"]+new_orbit["x"], orbit["y"]+new_orbit["y"], 0, get_rand(-1,1), mass, stealth)

		world << "\blue <B>Solar System Created.  Physics simulation ready.</B>"

		//TODO: MAKE SPAWN STATION HERE
		//spawn_point= new(
		spawn Start()

	proc/GetVectorToOrbit(var/frame/orbited_mass, x, y, mass, orbital_direction = CLOCKWISE)
		var/dx = orbited_mass.x - x
		var/dy = orbited_mass.y - y
		var/distance = dist(dx, dy)
		var/attraction = orbital_velocity(orbited_mass.mass, distance) //* (1 + get_rand(-ORBITAL_VECTOR_DEVATION,ORBITAL_VECTOR_DEVATION))
		world.log << "Attraction = [orbital_velocity(orbited_mass.mass, distance)*1e6] km/s.  Mass = [orbited_mass.mass] Yg, distance = [dist(dx,dy)*1e9] m"

		if(orbital_direction == ANTICLOCKWISE)
			attraction *= -1

		var/list/vector = list()
		vector["y"] = (attraction/distance)*dx
		vector["x"] = -(attraction/distance)*dy

		return vector

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
					halt_physics = 1
		//	var/time_difference = world.realtime - start_time
		//	sleep( min( 10, max( 0, 10 - time_difference ) ) )
			sleep(prob(prob(20)))

	proc/Tick()
		. = 0
		//Process new gravitational attraction
		for(var/frame/frame in all_frames)
			//Acceleration for the frame
			var/delta_x = 0
			var/delta_y = 0
			if(!frame.mass)
				continue
			for(var/frame/massive_body in frames_with_considerable_mass)  //I KNOW THIS IS HORRIBLE, BUT I AM TIRED AND CAN OPTIMMIZE LATER.
				if(frame == massive_body)
					continue
				var/dx = massive_body.x - frame.x
				var/dy = massive_body.y - frame.y
				var/distance = dist(dx, dy)
				var/attraction = gravity(massive_body, distance)
				delta_x += dx*attraction/distance
				delta_y += dy*attraction/distance

			var/total_additive = dist(delta_x, delta_y) + dist(frame.delta_x, frame.delta_y)
			var/total_relativistic = vel_add(dist(delta_x, delta_y), dist(frame.delta_x, frame.delta_y))

			frame.delta_x = (frame.delta_x + delta_x)*total_additive/total_relativistic
			frame.delta_y = (frame.delta_y + delta_y)*total_additive/total_relativistic

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
					projectile.defer_next_consideration = 5
*/
		//On to the movement phase!
		for(var/frame/frame in all_frames)
			frame.x += frame.delta_x
			frame.y += frame.delta_y
			frame.bearing += frame.angular_velocity
			frame.bearing %= 360
		for(var/projectile/projectile in projectiles)
			projectile.Tick()
		real_time++
		. = 1

	proc/AddLevel(z, spawn_point = 1)


	proc/RemoveLevel(z)

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
		angular_velocity	//Degrees/second
		mass = 1e-18			//No runtimes, kthx.  In Yottagrams, mass of the frame.  (Approximated, mobs and crap do not affect mass.)
		stealth = 0.01		//Feh.  0-1 on how difficult to detect.  Higher numbers are stealthier.
		time_delta = 0		//Relativity~  Difference of time on the ship from "realtime" by the server's standards.
		lorentz_factor = 1	//The closer to lightspeed you get, the higher this number.  It represents the time dilation experienced by the crew.  Will likely go unused.

		list/z_levels		//If null, this is just a point mass simulation.  Otherwise, it has real-game world stuff.
		list/propulsive_units
		min_x = 0	//Handles how small the world can be shrunk.
		min_y = 0
		min_z = 0
		list/contents = list()
		list/crewmembers


	New(new_name, new_desc, position_x, position_y, velocity_x, velocity_y, new_bearing, new_angular_velocity, new_mass, new_stealth, list/associated_levels)
		. = ..()
		if(!physics_sim)  //OHGOD
			world.log <<"Deleting as no physics_sim"
			del src

		name = new_name
		desc = new_desc
		x = position_x
		y = position_y
		delta_x = velocity_x
		delta_y = velocity_y
		bearing = new_bearing
		angular_velocity = new_angular_velocity
		mass = new_mass
		stealth = new_stealth
		lorentz_factor = lorentz_factor(delta_x, delta_y)
		if(islist(associated_levels) && associated_levels.len)
			z_levels = associated_levels

		physics_sim.all_frames += src
		if(mass >= MINIMUM_MASS_TO_CONSIDER_ATTRACTION)
			physics_sim.frames_with_considerable_mass += src

		return


	Del()
		if(physics_sim)  //OHGOD
			physics_sim.all_frames -= src
			physics_sim.frames_with_considerable_mass -= src
		. = ..()

//	proc/GetNearbyFrames()
//		if(!physics_sim)
//			del src


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
		delta_x = vel_add(firer.delta_x, launch_x)
		delta_y = vel_add(firer.delta_y, launch_y)
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


