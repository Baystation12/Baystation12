solar_system
	var/name = "A star, possible with planets or asteroids orbiting it."
	var/desc = "It's a star, nimrod."
	var/physics_tree/quadtree
	var/list/planets
	var/list/ships
	var/x = 0
	var/y = 0
	var/solar_mass = 1
	var/is_spawn = 0
	var/time_updated = 0
	var/size_of_quadtree = 0 //In gigameters.  Directions on a side.
	var/active = 0
	var/list/nodes

	New(_x, _y, max_mass, _is_spawn = 0) //Position, maximum mass to not have them overlap, and if it has the spawn point.
		if(_is_spawn == 1)
			solar_mass = STARTING_STAR_MASS
			name = STARTING_SYSTEM_NAME
			x = _x
			y = _y
			is_spawn = 1
			size_of_quadtree = InverseGravity(solar_mass)
			return
		name = GenerateStarName()
		solar_mass = GetRand(MINIMUM_SOLAR_MASS, max_mass)
		x = _x
		y = _y
		size_of_quadtree = InverseGravity(solar_mass)



	proc/InitializeSim()
		time_updated = physics_sim.real_time
		planets = list()

		//Make the sun
		var/frame/sun = new(name, pick(solar_descriptions), 0, 0, 0, 0, 0.05, solar_mass, STAR_DENSITY * (1+GetRand(-DENSITY_DEVIATION, DENSITY_DEVIATION)))
		planets.Add(sun)
		sun.solar_system = src

		for(var/i = 1 to rand(NUMBER_OF_PLANETS_MIN, NUMBER_OF_PLANETS_MAX))
			var/new_name = GeneratePlanetName(name, i)
			var/mass = GetRand(PLANET_MASS_MIN, PLANET_MASS_MAX)
			var/distance = GetRand(PLANET_CLOSEST_ORBIT(solar_mass), PLANET_FARTHEST_ORBIT(solar_mass))
			var/bearing = rand(0, 360)
			var/new_x = distance*cos(bearing)
			var/new_y = distance*sin(bearing)
			var/frame/planet
			if(mass > GAS_GIANT_MASS_CUTOFF)
				if(distance < CLOSEST_GAS_GIANT_ORBIT(solar_mass))
					distance = GetRand(PLANET_CLOSEST_ORBIT(solar_mass), PLANET_FARTHEST_ORBIT(solar_mass))
					if(distance < CLOSEST_GAS_GIANT_ORBIT(solar_mass))
						distance = CLOSEST_GAS_GIANT_ORBIT(solar_mass)*2
					new_x = distance*cos(bearing)
					new_y = distance*sin(bearing)
				planet = new(new_name, pick(gas_giant_descriptions), new_x, new_y, 0, 0, GetRand(-1,1), mass, GAS_GIANT_DENSITY, sun)
			else
				planet = new(new_name, pick(planetary_descriptions), new_x, new_y, 0, 0, GetRand(-1,1), mass, SOLID_PLANET_DENSITY, sun)
			planets.Add(planet)


			var/moon_number = 1
			while(prob(MOON_CHANCE))
				new_name = GeneratePlanetName(name, i, moon_number)
				mass = GetRand(MOON_MIN_SIZE, MOON_MAX_SIZE)
				distance = GetRand(MOON_CLOSEST_ORBIT, MOON_FARTHEST_ORBIT)
				bearing = rand(0, 360)
				new_x += distance*cos(bearing)
				new_y += distance*sin(bearing)
				var/frame/moon = new(new_name, pick(planetary_descriptions), new_x, new_y, 0, 0, GetRand(-1,1), mass, MOON_DENSITY, planet)
				planets.Add(moon)
				moon_number++

		world << "\blue <B>Solar System Created.  Physics simulation ready.</B>"

		if(is_spawn)
			//TODO: MAKE SPAWN STATION HERE
			//spawn_point= new(
			world << "\blue WHOOPS!  No spawn station yet!"


	proc/StartSimulation()
		var/active = 1
		quadtree = new(x, y, size_of_quadtree)
		physics_sim.AddSolarSystem(src)
		for(var/frame/frame in planets)
			quadtree.Insert(frame)
		physics_sim.all_frames.Add(planets)

	proc/Remove(frame)