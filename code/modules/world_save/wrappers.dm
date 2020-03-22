/datum/wrapper/area
	var/area_type
	var/name
	var/turfs
	var/has_gravity
	var/apc
	var/power_light
	var/power_equip
	var/power_environ
	// var/shuttle

/datum/wrapper/area/New(var/area/A)
	if(A)
		area_type = A.type
		name = A.name
		turfs = A.get_turf_coords()
		has_gravity = A.has_gravity
		power_light = A.power_light
		power_equip = A.power_equip
		power_environ = A.power_environ
		apc = A.apc
		//shuttle = A.shuttle