
/obj/structure/dropship/overmap

	var/overmap_range = 2 //The range of this dropship, in overmap tiles.

/obj/structure/dropship/overmap/update_reachable_landing()
	reachable_landing_locations = dropship_landing_controller.get_potential_landing_points_overmap(dropship = src)