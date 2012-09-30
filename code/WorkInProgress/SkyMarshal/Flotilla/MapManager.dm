var/map_handler/map_handler = new
var/list/types_of_vessels = list("Engineering", "Security", "Medical", "Science", "Civilian", "Command")


map_handler
	var/list/max_x = list()
	var/list/max_y = list()
	var/list/map_cache = list()
	var/list/empty_z_levels = list()
	var/list/maps_per_level = list()

	New()
		var/list/maps = typesof(/map_file) - /map_file
		for(var/type in maps)
			map_cache += new type()

	proc/LoadMap(var/map_file/map)
		var/z
		if(empty_z_levels.len && map.z == 1)
			z = pick(empty_z_levels)
			empty_z_levels -= z
			maploader.load_map(file(map.file), z)
		else
			maploader.load_map(file(map.file))
			z = world.maxz - map.z + 1
		max_x.Add(map.x)
		max_y.Add(map.y)
		if(maps_per_level.len < world.maxz)
			maps_per_level.len = world.maxz
		for(var/i = z to z + map.z - 1)
			maps_per_level[i] = map
		if(physics_sim)
			physics_sim.AddLevel(z)

	proc/RemoveMap(var/z)
		if(physics_sim)
			physics_sim.RemoveLevel(z)
		var/map_file/map = maps_per_level[z]
		for(var/i = maps_per_level.len to 1)
			if(maps_per_level[i] == map && z <= i && z >= i - map.z)
				for(var/j = i to i - map.z - 1)
					if(j == world.maxz)
						world.maxz--
						maps_per_level.Cut(j, j+1)
					else
						empty_z_levels |= j
						maps_per_level[j] = null
			break

		var/location = max_x.Find(map.x)
		if(location)
			max_x.Cut(location, location + 1)
		location = max_y.Find(map.y)
		if(location)
			max_y.Cut(location, location + 1)
		var/new_x = max(max_x)
		var/new_y = max(max_y)
		if(new_x < world.maxx)
			//Sanity so we do not delete players.
			for(var/mob/M in world)
				var/turf/T = get_turf(M)
				if(T.x > new_x-7)
					for(var/obj/I in T.contents)
						I.Move(locate(new_x-8, I.y, I.z))
			world.maxx = new_x
		if(new_y < world.maxy)
			//Sanity so we do not delete players.
			for(var/mob/M in world)
				var/turf/T = get_turf(M)
				if(T.y > new_y-7)
					for(var/obj/I in T.contents)
						I.Move(locate(I.x, new_y-8, I.z))
			world.maxy = new_y



#define ENGINEERING 1
#define SECURITY 2
#define MEDICAL 4
#define SCIENCE 8
#define CIVILIAN 16
#define COMMAND 32

/map_file
	var
		name = "default"
		desc = "default"
		file = "default.dmm"
		minimum_crew = 0
		maximum_crew = 0
		ship_types = 0 //List All
		ship_specialization = 0 //List the main
		list/occupations = list()
		x = 0 //Please calculate these and set them, so that the system can easier manage the world.
		y = 0
		z = 0
		density = 0.25 //g/cm^3
		mass = 1

		is_voteable = 0
		is_flotilla = 0

	example
		name = "NanoTrasen \"Sparrow\" Medical Cutter"
		desc = "A fast transport ship, well equipped to recover wounded.  Fast but short ranged."
		file = "maps/RandomZLevels/assistantChamber.dmm"
		minimum_crew = 2
		maximum_crew = 5
		ship_types = MEDICAL|CIVILIAN
		ship_specialization = MEDICAL
		is_flotilla = 1