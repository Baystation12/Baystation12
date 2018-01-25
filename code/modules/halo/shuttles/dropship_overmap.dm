
/obj/structure/dropship/overmap

	var/overmap_range = 0 //The range of this dropship, in overmap tiles. 0 = on same sector.

/obj/structure/dropship/overmap/update_reachable_landing()
	generate_current_landpoint()
	reachable_landing_locations = dropship_landing_controller.get_potential_landing_points_overmap(1,1,faction,z)

/obj/structure/dropship/overmap/perform_move_sequence(var/obj/move_to_obj = target_location)
	if(isnull(move_to_obj))
		return
	if(!dropship_landing_controller.overmap_range_check(src,move_to_obj))
		to_chat(pilot,"<span class = 'warning'>Your targeted location has moved out of range!</span>")
		target_location = null
		return
	. = ..()