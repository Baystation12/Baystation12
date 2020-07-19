#define TRACKING_POSSIBLE 0
#define TRACKING_TERMINATE 1
#define TRACKING_NO_SENSORS 2
#define TRACKING_NO_CAMERA 3
#define TRACKING_OUT_OF_RANGE 4


/mob/living/silicon/ai/var/max_locations = 10
/mob/living/silicon/ai/var/stored_locations[0]


/proc/InvalidPlayerTurf(turf/T as turf)
	return !(T && (T.z in GLOB.using_map.player_levels))


/mob/living/silicon/ai/proc/get_camera_list()
	if(stat != CONSCIOUS)
		return

	track = new()
	for (var/obj/machinery/camera/C in cameranet.cameras)
		if (!AreConnectedZLevels(src.z, C.z))
			continue

		var/list/tempnetwork = C.network & network
		if (tempnetwork.len)
			track.cameras[text("[][]", C.c_tag, (C.can_use() ? null : " (Deactivated)"))] = C

	return track.cameras


/mob/living/silicon/ai/proc/ai_camera_list(var/camera in get_camera_list())
	set category = "Silicon Commands"
	set name = "Show Camera List"

	if(check_unable(0, TRUE))
		return

	if (!camera)
		return 0

	var/obj/machinery/camera/C = track.cameras[camera]
	eyeobj.setLoc(C)

	return


/mob/living/silicon/ai/proc/ai_store_location(loc as text)
	set category = "Silicon Commands"
	set name = "Store Camera Location"
	set desc = "Stores your current camera location by the given name"

	loc = sanitize(loc)
	if(!loc)
		to_chat(src, SPAN_WARNING("Must supply a location name"))
		return

	if(stored_locations.len >= max_locations)
		to_chat(src, SPAN_WARNING("Cannot store additional locations. Remove one first"))
		return

	if(loc in stored_locations)
		to_chat(src, SPAN_WARNING("There is already a stored location by this name"))
		return

	var/L = eyeobj.getLoc()
	if (InvalidPlayerTurf(get_turf(L)))
		to_chat(src, SPAN_WARNING("Unable to store this location"))
		return

	stored_locations[loc] = L
	to_chat(src, "Location '[loc]' stored")


/mob/living/silicon/ai/proc/sorted_stored_locations()
	return sortList(stored_locations)


/mob/living/silicon/ai/proc/ai_goto_location(loc in sorted_stored_locations())
	set category = "Silicon Commands"
	set name = "Goto Camera Location"
	set desc = "Returns to the selected camera location"

	if (!(loc in stored_locations))
		to_chat(src, SPAN_WARNING("Location [loc] not found"))
		return

	var/L = stored_locations[loc]
	eyeobj.setLoc(L)


/mob/living/silicon/ai/proc/ai_remove_location(loc in sorted_stored_locations())
	set category = "Silicon Commands"
	set name = "Delete Camera Location"
	set desc = "Deletes the selected camera location"

	if (!(loc in stored_locations))
		to_chat(src, SPAN_WARNING("Location [loc] not found"))
		return

	stored_locations.Remove(loc)
	to_chat(src, "Location [loc] removed")


// Used to allow the AI is write in mob names/camera name from the CMD line.
/datum/trackable
	var/list/names = list()
	var/list/namecounts = list()
	var/list/humans = list()
	var/list/others = list()
	var/list/cameras = list()


/mob/living/silicon/ai/proc/trackable_mobs()
	if(usr.stat != CONSCIOUS)
		return list()

	var/datum/trackable/TB = new()
	for(var/mob/living/M in SSmobs.mob_list)
		if(M == usr)
			continue
		if(M.tracking_status(src) != TRACKING_POSSIBLE)
			continue

		var/name = M.name
		if (name in TB.names)
			TB.namecounts[name]++
			name = text("[] ([])", name, TB.namecounts[name])
		else
			TB.names.Add(name)
			TB.namecounts[name] = 1

		if(istype(M, /mob/living/carbon/human))
			TB.humans[name] = M
		else
			TB.others[name] = M

	var/list/targets = sortList(TB.humans) + sortList(TB.others)
	src.track = TB
	return targets


/mob/living/silicon/ai/proc/ai_camera_track(target_name in trackable_mobs())
	set category = "Silicon Commands"
	set name = "Follow With Camera"
	set desc = "Select who you would like to track."

	if(stat != CONSCIOUS)
		to_chat(src, SPAN_WARNING("You can't follow [target_name] with cameras because you're not conscious!"))
		return
	if(!target_name)
		cameraFollow = null

	var/mob/target = (isnull(track.humans[target_name]) ? track.others[target_name] : track.humans[target_name])
	track = null
	ai_actual_track(target)


/mob/living/silicon/ai/proc/ai_cancel_tracking(forced = FALSE)
	if(!cameraFollow)
		return

	to_chat(src, "Follow camera mode [forced ? "terminated" : "ended"].")
	cameraFollow.tracking_cancelled()
	cameraFollow = null


/mob/living/silicon/ai/proc/ai_actual_track(mob/living/target as mob)
	if(!istype(target))
		return

	if(target == cameraFollow)
		return

	if(cameraFollow)
		ai_cancel_tracking()
	cameraFollow = target
	to_chat(src, "Tracking target...")
	target.tracking_initiated()

	spawn (0)
		while (cameraFollow == target)
			if (cameraFollow == null)
				return

			switch(target.tracking_status(src))
				if (TRACKING_NO_SENSORS)
					to_chat(src, "Target does not have suit sensors set to tracking.")
					ai_cancel_tracking(TRUE)
					return

				if (TRACKING_NO_CAMERA)
					to_chat(src, "Target does not have their remote camera enabled.")
					ai_cancel_tracking(TRUE)
					return

				if (TRACKING_OUT_OF_RANGE)
					to_chat(src, "Target is not in network range.")
					ai_cancel_tracking(TRUE)
					return

				if (TRACKING_TERMINATE)
					to_chat(src, "Tracking failed for an unknown reason.")
					ai_cancel_tracking(TRUE)
					return

			if(eyeobj)
				eyeobj.setLoc(get_turf(target), 0)
			else
				view_core()
				return
			sleep(10)


/obj/machinery/camera/attack_ai(mob/living/silicon/ai/user as mob)
	if (!istype(user) || !can_use())
		return
	user.eyeobj.setLoc(get_turf(src))


/mob/living/silicon/ai/attack_ai(mob/user as mob)
	ai_camera_list()


/proc/camera_sort(list/L)
	var/obj/machinery/camera/a
	var/obj/machinery/camera/b

	for (var/i = L.len, i > 0, i--)
		for (var/j = 1 to i - 1)
			a = L[j]
			b = L[j + 1]
			if (a.c_tag_order != b.c_tag_order)
				if (a.c_tag_order > b.c_tag_order)
					L.Swap(j, j + 1)
			else
				if (sorttext(a.c_tag, b.c_tag) < 0)
					L.Swap(j, j + 1)
	return L


/mob/living/proc/near_camera()
	if (!isturf(loc) || !cameranet.is_visible(src))
		return FALSE
	return TRUE


/mob/living/proc/tracking_status(atom/tracker)
	return TRACKING_TERMINATE


/mob/living/silicon/robot/tracking_status(atom/tracker)
	var/turf/tracker_turf = get_turf(tracker)
	var/turf/target_turf = get_turf(src)
	if (!tracker || !AreConnectedZLevels(tracker_turf.z, target_turf.z))
		return TRACKING_OUT_OF_RANGE

	if (!camera || !camera.can_use())
		return TRACKING_NO_CAMERA

	return TRACKING_POSSIBLE


/mob/living/carbon/human/tracking_status(atom/tracker)
	var/turf/tracker_turf = get_turf(tracker)
	var/turf/target_turf = get_turf(src)
	if (!tracker || !AreConnectedZLevels(tracker_turf.z, target_turf.z))
		return TRACKING_OUT_OF_RANGE

	if (!hassensorlevel(src, SUIT_SENSOR_TRACKING))
		return TRACKING_NO_SENSORS

	return TRACKING_POSSIBLE


/mob/living/proc/tracking_initiated()


/mob/living/silicon/robot/tracking_initiated()
	tracking_entities++
	if(tracking_entities == 1)
		to_chat(src, "<span class='warning'>Internal camera is currently being accessed.</span>")


/mob/living/proc/tracking_cancelled()


/mob/living/silicon/robot/tracking_cancelled()
	tracking_entities--
	if(!tracking_entities)
		to_chat(src, "<span class='notice'>Internal camera is no longer being accessed.</span>")


#undef TRACKING_POSSIBLE
#undef TRACKING_TERMINATE
#undef TRACKING_NO_SENSORS
#undef TRACKING_NO_CAMERA
#undef TRACKING_OUT_OF_RANGE
