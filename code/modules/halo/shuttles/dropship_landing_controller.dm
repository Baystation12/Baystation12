var/global/datum/dropship_landing_controller/dropship_landing_controller = new /datum/dropship_landing_controller

/datum/dropship_landing_controller
	var/list/land_points = list()

/datum/dropship_landing_controller/proc/get_faction_land_points(var/wanted_faction,var/check_active = 1,var/check_occupied = 1)
	var/list/faction_land_points = list()
	for(var/obj/effect/landmark/dropship_land_point/O in land_points)
		var/add_to = 0
		if(O.faction == wanted_faction)
			add_to = 1
		if((check_active) && !O.active)
			add_to = 0
		if((check_occupied) && O.occupied)
			add_to = 0
		if(add_to)
			faction_land_points += O
	return faction_land_points

/datum/dropship_landing_controller/proc/get_active_land_points()
	var/list/active_land_points = list()
	for(var/obj/effect/landmark/dropship_land_point/O in land_points)
		if(O.active)
			active_land_points += O
	return active_land_points

/datum/dropship_landing_controller/proc/get_unoccupied_land_points()
	var/list/active_land_points = list()
	for(var/obj/effect/landmark/dropship_land_point/O in land_points)
		if(!O.occupied)
			active_land_points += O
	return active_land_points

/datum/dropship_landing_controller/proc/get_potential_landing_points(var/check_active = 1,var/check_occupied = 1,var/faction_check)
	var/list/potential_landing_points = land_points.Copy()
	if(faction_check)
		potential_landing_points &= (get_faction_land_points(faction_check,check_active,check_occupied) + get_faction_land_points("Civilian",check_active,check_occupied))
	else
		if(check_active)
			potential_landing_points &= get_active_land_points()
		if(check_occupied)
			potential_landing_points &= get_unoccupied_land_points()
	return potential_landing_points

/datum/dropship_landing_controller/proc/overmap_range_check(var/dropship_z,var/overmap_range,var/obj/l)
	if(get_dist(map_sectors["[dropship_z]"],map_sectors["[l.z]"]) > overmap_range)
		return 0
	return 1

/datum/dropship_landing_controller/proc/get_potential_landing_points_overmap(var/check_active = 1,var/check_occupied = 1,var/faction_check,var/dropship_z,var/overmap_range = 0)
	var/list/potential_landing_points = get_potential_landing_points(check_active,check_occupied,faction_check)
	for(var/obj/l in potential_landing_points)
		if(!overmap_range_check(dropship_z,overmap_range,l))
			potential_landing_points -= l
	return potential_landing_points

/datum/dropship_landing_controller/proc/add_land_point(var/obj/land_point)
	land_points += land_point

/datum/dropship_landing_controller/proc/remove_land_point(var/obj/land_point)
	land_points -= land_point
