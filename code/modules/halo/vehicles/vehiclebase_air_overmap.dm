
/obj/vehicles/air/overmap
	var/overmap_range = 10 //The amount of overmap "tiles" this vehicle can move with move_to_waypoint

	vehicle_view_modifier = 1.5


/obj/vehicles/air/overmap/get_reachable_waypoints()
	var/driver_faction = get_driver_faction()
	var/faction_use = driver_faction
	if(isnull(driver_faction) || driver_faction == "neutral")
		faction_use = faction
	return dropship_landing_controller.get_potential_landing_points_overmap(1,1,faction_use,z,overmap_range)