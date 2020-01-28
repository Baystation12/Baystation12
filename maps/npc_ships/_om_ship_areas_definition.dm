
/area/om_ships
	name = "Overmap Ship"
	icon_state = "red"
	requires_power = 0
	has_gravity = 1

//I wanted to make this area dynamically create another instance of itself so APCs didn't overlap.//
//Can't seem to get it working and it's acting as a big blocker, so I'll revert back to not using power.//
/*
/area/om_ships/Initialize()
	for(var/atom/t in contents)
		var/area/newarea = null
		for(var/a in shipmap_handler.area_instances)
			if(shipmap_handler.area_instances[a] == t.z)
				newarea = a
		if(!newarea)
			newarea = new /area/om_ship_replace (null)
			//INHERIT A BUNCH OF OUR BASE TURF'S STUFF//
			shipmap_handler.area_instances[newarea] = t.z
			newarea.name = name
			newarea.requires_power = requires_power
			newarea.has_gravity = has_gravity
			newarea.dynamic_lighting = dynamic_lighting
			newarea.luminosity = luminosity
			newarea.base_turf = base_turf

		newarea.contents.Add(t)
	. = ..()	*/
/*
/area/om_ship_replace
	name = "Ship"
	icon_state = "red"
	requires_power = 1
	has_gravity = 1
*/