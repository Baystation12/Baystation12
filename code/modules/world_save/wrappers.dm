/datum/wrapper/area
	var/area_type
	var/name
	var/turfs
	var/shuttle

/datum/wrapper/area/New(var/area/A)
	area_type = A.type
	name = A.name
	turfs = A.get_turf_coords()
	shuttle = A.shuttle