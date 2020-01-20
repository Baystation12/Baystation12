
/obj/vehicles/air/overmap
	var/overmap_range = 2 //The amount of overmap "tiles" this vehicle can move with move_to_waypoint

	vehicle_view_modifier = 1.5


/obj/vehicles/air/overmap/get_reachable_waypoints()
	return dropship_landing_controller.get_potential_landing_points_overmap(1,1,faction,z,overmap_range)