#define TRACKING_POSSIBLE 0
#define TRACKING_NO_COVERAGE 1
#define TRACKING_TERMINATE 2

/mob/living/silicon/ai/var/max_locations = 10
/mob/living/silicon/ai/var/stored_locations[0]

/proc/InvalidPlayerTurf(turf/T as turf)
	return !(T && T.z in config.player_levels)

/mob/living/silicon/ai/proc/get_camera_list()
	if(src.stat == 2)
		return

	cameranet.process_sort()

	var/list/T = list()
	T["Cancel"] = "Cancel"
	for (var/obj/machinery/camera/C in cameranet.cameras)
		var/list/tempnetwork = C.network&src.network
		if (tempnetwork.len)
			T[text("[][]", C.c_tag, (C.can_use() ? null : " (Deactivated)"))] = C

	track = new()
	track.cameras = T
	return T


/mob/living/silicon/ai/proc/ai_camera_list(var/camera in get_camera_list())
	set category = "AI Commands"
	set name = "Show Camera List"

	if(src.stat == 2)
		src << "You can't list the cameras because you are dead!"
		return

	if (!camera || camera == "Cancel")
		return 0

	var/obj/machinery/camera/C = track.cameras[camera]
	src.eyeobj.setLoc(C)

	return

/mob/living/silicon/ai/proc/ai_store_location(loc as text)
	set category = "AI Commands"
	set name = "Store Camera Location"
	set desc = "Stores your current camera location by the given name"

	loc = sanitize(copytext(loc, 1, MAX_MESSAGE_LEN))
	if(!loc)
		src << "\red Must supply a location name"
		return

	if(stored_locations.len >= max_locations)
		src << "\red Cannot store additional locations. Remove one first"
		return

	if(loc in stored_locations)
		src << "\red There is already a stored location by this name"
		return

	var/L = src.eyeobj.getLoc()
	if (InvalidPlayerTurf(get_turf(L)))
		src << "\red Unable to store this location"
		return

	stored_locations[loc] = L
	src << "Location '[loc]' stored"

/mob/living/silicon/ai/proc/sorted_stored_locations()
	return sortList(stored_locations)

/mob/living/silicon/ai/proc/ai_goto_location(loc in sorted_stored_locations())
	set category = "AI Commands"
	set name = "Goto Camera Location"
	set desc = "Returns to the selected camera location"

	if (!(loc in stored_locations))
		src << "\red Location [loc] not found"
		return

	var/L = stored_locations[loc]
	src.eyeobj.setLoc(L)

/mob/living/silicon/ai/proc/ai_remove_location(loc in sorted_stored_locations())
	set category = "AI Commands"
	set name = "Delete Camera Location"
	set desc = "Deletes the selected camera location"

	if (!(loc in stored_locations))
		src << "\red Location [loc] not found"
		return

	stored_locations.Remove(loc)
	src << "Location [loc] removed"

// Used to allow the AI is write in mob names/camera name from the CMD line.
/datum/trackable
	var/list/names = list()
	var/list/namecounts = list()
	var/list/humans = list()
	var/list/others = list()
	var/list/cameras = list()

/mob/living/silicon/ai/proc/trackable_mobs()
	if(usr.stat == 2)
		return list()

	var/datum/trackable/TB = new()
	for(var/mob/living/M in mob_list)
		if(M == usr)
			continue
		if(M.tracking_status() != TRACKING_POSSIBLE)
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

/mob/living/silicon/ai/proc/ai_camera_track(var/target_name in trackable_mobs())
	set category = "AI Commands"
	set name = "Track With Camera"
	set desc = "Select who you would like to track."

	if(src.stat == 2)
		src << "You can't track with camera because you are dead!"
		return
	if(!target_name)
		src.cameraFollow = null

	var/mob/target = (isnull(track.humans[target_name]) ? track.others[target_name] : track.humans[target_name])
	src.track = null
	ai_actual_track(target)

/mob/living/silicon/ai/proc/ai_cancel_tracking(var/forced = 0)
	if(!cameraFollow)
		return

	src << "Follow camera mode [forced ? "terminated" : "ended"]."
	cameraFollow.tracking_cancelled()
	cameraFollow = null

/mob/living/silicon/ai/proc/ai_actual_track(mob/living/target as mob)
	if(!istype(target))	return
	var/mob/living/silicon/ai/U = usr

	U.cameraFollow = target
	U << "Now tracking [target.name] on camera."
	target.tracking_initiated()

	spawn (0)
		while (U.cameraFollow == target)
			if (U.cameraFollow == null)
				return

			switch(target.tracking_status())
				if(TRACKING_NO_COVERAGE)
					U << "Target is not near any active cameras."
					sleep(100)
					continue
				if(TRACKING_TERMINATE)
					U.ai_cancel_tracking(1)
					return

			if(U.eyeobj)
				U.eyeobj.setLoc(get_turf(target), 0)
			else
				view_core()
				return
			sleep(10)

/obj/machinery/camera/attack_ai(var/mob/living/silicon/ai/user as mob)
	if (!istype(user))
		return
	if (!src.can_use())
		return
	user.eyeobj.setLoc(get_turf(src))


/mob/living/silicon/ai/attack_ai(var/mob/user as mob)
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


mob/living/proc/near_camera()
	if (!isturf(loc))
		return 0
	else if(!cameranet.checkCameraVis(src))
		return 0
	return 1

/mob/living/proc/tracking_status()
	// Easy checks first.
	// Don't detect mobs on Centcom. Since the wizard den is on Centcomm, we only need this.
	if(InvalidPlayerTurf(get_turf(src)))
		return TRACKING_TERMINATE
	if(invisibility >= INVISIBILITY_LEVEL_ONE) //cloaked
		return TRACKING_TERMINATE
	if(digitalcamo)
		return TRACKING_TERMINATE
	if(istype(loc,/obj/effect/dummy))
		return TRACKING_TERMINATE

	 // Now, are they viewable by a camera? (This is last because it's the most intensive check)
	return near_camera() ? TRACKING_POSSIBLE : TRACKING_NO_COVERAGE

/mob/living/silicon/robot/tracking_status()
	. = ..()
	if(. == TRACKING_NO_COVERAGE)
		return camera && camera.can_use() ? TRACKING_POSSIBLE : TRACKING_NO_COVERAGE

/mob/living/silicon/robot/syndicate/tracking_status()
	return TRACKING_TERMINATE

/mob/living/carbon/human/tracking_status()
	//Cameras can't track people wearing an agent card or a ninja hood.
	if(wear_id && istype(wear_id.GetID(), /obj/item/weapon/card/id/syndicate))
		return TRACKING_TERMINATE
	if(istype(head, /obj/item/clothing/head/helmet/space/rig))
		var/obj/item/clothing/head/helmet/space/rig/helmet = head
		if(helmet.prevent_track())
			return TRACKING_TERMINATE

	. = ..()
	if(. == TRACKING_TERMINATE)
		return

	if(. == TRACKING_NO_COVERAGE)
		var/turf/T = get_turf(src)
		if(T && (T.z in config.station_levels) && hassensorlevel(src, SUIT_SENSOR_TRACKING))
			return TRACKING_POSSIBLE

mob/living/proc/tracking_initiated()

mob/living/silicon/robot/tracking_initiated()
	tracking_entities++
	if(tracking_entities == 1 && has_zeroth_law())
		src << "<span class='warning'>Internal camera is currently being accessed.</span>"

mob/living/proc/tracking_cancelled()

mob/living/silicon/robot/tracking_initiated()
	tracking_entities--
	if(!tracking_entities && has_zeroth_law())
		src << "<span class='notice'>Internal camera is no longer being accessed.</span>"


#undef TRACKING_POSSIBLE
#undef TRACKING_NO_COVERAGE
#undef TRACKING_TERMINATE
