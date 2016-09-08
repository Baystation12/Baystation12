/hook/construct_ship/proc/build_ship(var/size_x, var/size_y, var/name, var/team, var/obj/effect/overmap/ship/parent)
	//Make the new Z level
	testing("Creating Z-level...")
	var/new_z = 0
	world.maxz++
	new_z = world.maxz
	//Fill it with blank turfs
	testing("Creating turfs...")
	var/list/built_turfs = list()
	for (var/i in block(locate(1,1,new_z), locate(size_x,size_y,new_z)))
		var/turf/T = i
		built_turfs += T
	//Make an area with all those turfs in it.
	testing("Creating area...")
	var/area/ship_battle/new_area = new
	new_area.team = team
	new_area.name = name
	new_area.contents.Add(built_turfs)
	//Make a basic platform with a core on it.
	testing("Constructing ship base...")
	var/turf/center = locate(max(abs((size_x+1)/2),1), max(abs((size_y+1)/2),1), new_z)
	for(var/turf/surrounding in orange(1, center))
		surrounding.ChangeTurf(/turf/simulated/floor/airless)
	var/obj/machinery/space_battle/ship_core/new_core = new()
	new_core.forceMove(center)
	new_core.timer = 1200
	//Add the ship to the overmap.
	testing("Adding to overmap...")
	var/obj/effect/overmap/ship/new_ship = new()
//	new_ship.map_z = new_ship.GetConnectedZLevels(new_z)
	new_ship.forceMove(get_turf(parent))
	map_sectors["[new_z]"] = new_ship
	if(parent && parent.current_sector)
		new_ship.current_sector = parent.current_sector
	new_ship.vessel_mass = (2000+(size_x*size_y)) // Arbitrary

	testing("New ship \"[name]\" successfully created! (z:[new_z])")
	return 1
