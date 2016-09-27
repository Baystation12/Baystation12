/area/ship_battle/new_ship
	name = "New Ship"

/datum/ship_prefab
	var/name
	var/path
	var/file
	var/team

/datum/space_construction/ship/proc/build_ship(var/size_x, var/size_y, var/name, var/team, var/warp_id, var/obj/effect/overmap/ship/parent, var/z_only = 0)
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
		T.lighting_clear_overlays()
		built_turfs += T
	//Make an area with all those turfs in it.
	if(!z_only)
		testing("Creating area...")
		var/area/ship_battle/new_ship/new_area = new()
		new_area.contents.Add(built_turfs)
		new_area.team = team
		new_area.name = name
		//Make a basic platform for building on.
		testing("Constructing ship base...")
		var/list/floors = list()
		var/turf/center = locate(25,25,new_z)
		for(var/turf/surrounding in range(6, center))
			if(surrounding in range(1, center))
				surrounding.ChangeTurf(/turf/simulated/floor/tiled)
				if(surrounding != center && (get_dir(surrounding, center) in cardinal))
					floors.Add(surrounding)
			else if(surrounding in range(2, center))
				surrounding.ChangeTurf(/turf/simulated/wall)
			else
				new /obj/structure/lattice(surrounding)
		//Add a core, a warp pad, etc.
		testing("Populating ship base...")
		var/obj/machinery/space_battle/ship_core/new_core = new()
		new_core.forceMove(center)
		//Surround the core in glass.
		for(var/D in cardinal)
			var/obj/structure/window/phoronreinforced/W = new(center)
			W.set_dir(D)
		//Spawn us a light.
		var/obj/machinery/light/small/battle/new_light = new(pick(floors))
		new_light.dir = get_dir(new_light, center)
		//Spawn us a warp pad
		var/obj/machinery/space_battle/warp_pad/teleporter = new()
		var/turf/teleporter_turf = pick(floors)
		floors.Cut(floors.Find(teleporter_turf), (floors.Find(teleporter_turf)+1))
		teleporter.forceMove(teleporter_turf)
		teleporter.id_tag = warp_id
		teleporter.reconnect()
		//Give it a cell.
		var/obj/item/weapon/cell/high/teleporter_cell = new()
		teleporter_cell.forceMove(teleporter)
		teleporter.backup_power = teleporter_cell
		teleporter_cell.maxcharge = 10000
		teleporter_cell.charge = teleporter_cell.maxcharge
		//Make us an airlock
		var/turf/airlock_turf = pick(floors)
		floors.Cut(floors.Find(airlock_turf), (floors.Find(airlock_turf)+1))
		airlock_turf = get_step(airlock_turf, get_dir(new_core, airlock_turf)) // Find the wall.
		var/obj/machinery/door/airlock/external/new_airlock = new(airlock_turf)
		new_airlock.req_access = list(team*10 - 9)
		airlock_turf.ChangeTurf(/turf/simulated/floor/tiled)
		//Make a missile start area.
		var/turf/new_start_turf = locate(25, 49)
		var/obj/missile_start/new_start = new(new_start_turf)
		new_start.initialised = 1
		new_start.refresh_alive()
		new_start.team = team
		new_start.name = name

		//Add the ship to the overmap.
		testing("Adding to overmap...")
		var/obj/effect/overmap/ship/new_ship = new()
		new_ship.map_z += new_z
		new_ship.forceMove(get_turf(parent))
		new_ship.map_z = GetConnectedZlevels(new_ship.z)
		map_sectors["[new_z]"] = new_ship
		new_ship.name = name
		if(parent && parent.current_sector)
			new_ship.current_sector = parent.current_sector
		new_ship.vessel_mass = (2000+(size_x*size_y)) // Arbitrary
		spawn(50)
			//	Make da APC
			testing("Adding power...")
			var/turf/apc_turf = pick(floors)
			var/obj/machinery/power/apc/battle/new_apc = new (apc_turf, get_dir(new_core, apc_turf), 2)
			new_apc.has_electronics = 2 //installed and secured
			if(new_apc.cell_type)
				new_apc.cell = new new_apc.cell_type(new_apc)
			new_apc.name = "\improper [new_area.name] APC"
			new_area.apc = new_apc
			new_apc.area = new_area
			new_apc.update_icon()

			new_apc.make_terminal()
	testing("New ship \"[name]\" successfully created! (z:[new_z])")
//	for(var/atom/A in new_area.contents)
//		world.contents.Add(A)

	return 1
