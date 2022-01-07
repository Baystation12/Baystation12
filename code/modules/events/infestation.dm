/datum/event/infestation
	announceWhen = 10
	endWhen = 11
	var/static/const/MICE = "mice"
	var/static/const/LIZARDS = "lizards"
	var/static/const/SPIDERS = "spiders"
	var/area/area
	var/vermin


/datum/event/infestation/announce()
	command_announcement.Announce(
		{"Bioscans indicate that [vermin] have been breeding in \the [area]. \
			Further infestation is likely if left unchecked."},
		"[location_name()] Sensor Network",
		zlevels = affecting_z
	)


/datum/event/infestation/start()
	var/list/turfs
	for (var/attempts = 1 to 3)
		area = pick_area(list(/proc/is_not_space_area, /proc/is_station_area))
		if (!area)
			log_debug("Vermin infestation failed to find a viable area. Aborting.")
			kill(TRUE)
			return
		turfs = get_area_turfs(area, list(/proc/not_turf_contains_dense_objects, /proc/IsTurfAtmosSafe))
		if (length(turfs))
			break
		log_debug("Vermin infestation failed to find viable turfs in \the [area].")
	if (!length(turfs))
		log_debug("Vermin infestation failed to find a viable spawn after 3 attempts. Aborting.")
		kill(TRUE)
		return
	var/count
	vermin = pick(MICE, LIZARDS, SPIDERS)
	var/turf/turf
	switch (vermin)
		if (MICE)
			count = rand(1, 6)
			for (var/i = 1 to count)
				turf = pick(turfs)
				new /mob/living/simple_animal/passive/mouse (turf)
		if (LIZARDS)
			count = rand(1, 6)
			for (var/i = 1 to count)
				turf = pick(turfs)
				new /mob/living/simple_animal/passive/lizard (turf)
		if (SPIDERS)
			count = rand(1, 6)
			for (var/i = 1 to count)
				turf = pick(turfs)
				new /obj/item/spider (turf)
	log_and_message_admins("Vermin infestation spawned ([vermin] x[count]) in \the [area]", location = turf)
