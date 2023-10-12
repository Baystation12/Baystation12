/datum/event/deepmaint
	announceWhen = 10
	endWhen = 2400
	var/list/free_ladders
	var/list/spawned_ladders

/datum/event/deepmaint/start()
	var/attempts = 5
	spawned_ladders = list()
	free_ladders = GLOB.free_deepmaint_ladders.Copy()
	do
		if (!length(free_ladders))
			break

		create_deepmaint_ladder_connection()

	while(--attempts > 0)

	if(length(spawned_ladders) == 0)
		log_debug("Failed to spawn any ladders for deepmaint event. Aborting.")
		kill(TRUE)

/datum/event/deepmaint/end()
	for (var/obj/structure/ladder/L in spawned_ladders)
		L.target_down = null
		L.target_up = null
		L.visible_message(SPAN_WARNING("\The [src] suddenly vanishes into nothingness!"))
		qdel(L)
	LAZYCLEARLIST(spawned_ladders)
	LAZYCLEARLIST(free_ladders)
	command_announcement.Announce("All subspace distortions have ceased. All personnel and/or assets not present onboard should be considered lost.")


/datum/event/deepmaint/announce()
	command_announcement.Announce("Extreme subspace anomalies detected. Ensure all persons and assets are accounted for.", "[location_name()] Spooky Sensor Network", zlevels = affecting_z)

/datum/event/deepmaint/proc/create_deepmaint_ladder_connection()
	var/area/location = pick_area(list(/proc/is_not_space_area, /proc/is_station_area, /proc/is_maint_area))
	if(!location)
		log_debug("Could not find suitable location(s) to spawn ladders to deepmaint. Aborting.")
		kill()
		return FALSE

	var/list/ladder_turfs = get_area_turfs(location, list(/proc/not_turf_contains_dense_objects, /proc/IsTurfAtmosSafe))
	if(!length(ladder_turfs))
		log_debug("Failed to find viable turfs to spawn ladders in \the [location].")
		return FALSE

	var/turf/station_turf = pick(ladder_turfs)

	var/turf/deepmaint_turf = pick(free_ladders)
	free_ladders -= deepmaint_turf
	var/obj/structure/ladder/station_ladder = new (station_turf)
	var/turf/T = station_ladder.loc
	T.ChangeTurf(/turf/simulated/open)
	new/obj/structure/lattice(station_ladder.loc)
	var/obj/structure/ladder/up/deepmaint_ladder = new (deepmaint_turf)
	station_ladder.desc = "[station_ladder.desc] Was this always here...?"
	station_ladder.target_down = deepmaint_ladder
	deepmaint_ladder.target_up = station_ladder
	spawned_ladders += station_ladder
	spawned_ladders += deepmaint_ladder

	return TRUE
