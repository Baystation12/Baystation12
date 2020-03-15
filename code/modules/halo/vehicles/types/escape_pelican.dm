
/obj/vehicles/drop_pod/escape_pod/escape_pelican
	name = "D77-TC Pelican, Modified"
	desc = "A D77-TC pelican stripped of weapons and provided with a slipspace drive. The flight systems have also been mainly removed, instead used for slipspace stabilisation. Small craft traversing slipspace causes incredible damage, thus this can be used only once."

	icon = 'code/modules/halo/shuttles/pelican.dmi'
	icon_state = "base"

	occupants = list(2,0)

	bound_height = 128
	bound_width = 128

	pixel_x = -32
	pixel_y = -32

/obj/vehicles/drop_pod/escape_pod/escape_pelican/get_drop_point()
	var/list/valid_points = list()
	var/obj/effect/overmap/om_obj = map_sectors["[z]"]
	var/list/z_donot_land = list()
	if(om_obj)
		z_donot_land += om_obj.map_z
	for(var/obj/effect/landmark/drop_pod_landing/l in world)
		if(l.z in z_donot_land)
			continue
		valid_points += l
	if(isnull(valid_points) || valid_points.len == 0)
		log_error("ERROR: Drop pods placed on map but no /obj/effect/drop_pod_landing markers present!")
		return
	return pick(valid_points)