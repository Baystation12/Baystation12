/datum/event/camera_loss/start()
	var/obj/machinery/camera/C = acquire_random_camera()
	if(!C)
		return

	var/severity_range = 0
	switch(severity)
		if(EVENT_LEVEL_MUNDANE)
			severity_range = 0
		if(EVENT_LEVEL_MODERATE)
			severity_range = 7
		if(EVENT_LEVEL_MAJOR)
			severity_range = 15

	for(var/obj/machinery/camera/cam in range(severity_range,C))
		if(is_valid_camera(cam))
			cam.wires.UpdateCut(CAMERA_WIRE_POWER, 0)
			if(prob(5))
				cam.wires.UpdateCut(CAMERA_WIRE_ALARM, 0)

/datum/event/camera_loss/proc/acquire_random_camera(var/remaining_attempts = 5)
	if(!world_cameras.len)
		return
	if(!remaining_attempts)
		return

	var/obj/machinery/camera/C = pick(world_cameras)
	// Only return a functional camera, not installed in a silicon, and that exists somewhere players have access

	if(is_valid_camera(C))
		return C
	return acquire_random_camera(remaining_attempts--)

/datum/event/camera_loss/proc/is_valid_camera(var/obj/machinery/camera/C)
	var/turf/T = get_turf(C)
	return T && C.can_use() && !istype(C.loc, /mob/living/silicon) && (T.z in config.player_levels)
