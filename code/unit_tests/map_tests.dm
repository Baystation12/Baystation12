/*
 *
 *  Map Unit Tests.
 *  Zone checks / APC / Scrubber / Vent / Cryopod Computers.
 *
 *
 */

#define FAILURE 0
#define SUCCESS 1


/datum/unit_test/apc_area_test
	name = "MAP: Area Test APC / Scrubbers / Vents"


/datum/unit_test/apc_area_test/start_test()
	var/list/bad_areas = list()
	var/area_test_count = 0

	for(var/area/A in world)
		if(!A.z)
			continue
		if(!isPlayerLevel(A.z))
			continue
		area_test_count++
		var/area_good = 1
		var/bad_msg = "--------------- [A.name]([A.type])"

		var/exemptions = get_exemptions(A)
		if(!A.apc && !(exemptions & GLOB.using_map.NO_APC))
			log_bad("[bad_msg] lacks an APC.")
			area_good = 0
		else if(A.apc && (exemptions & GLOB.using_map.NO_APC))
			log_bad("[bad_msg] is not supposed to have an APC.")
			area_good = 0

		if(!A.air_scrub_names.len && !(exemptions & GLOB.using_map.NO_SCRUBBER))
			log_bad("[bad_msg] lacks an air scrubber.")
			area_good = 0
		else if(A.air_scrub_names.len && (exemptions & GLOB.using_map.NO_SCRUBBER))
			log_bad("[bad_msg] is not supposed to have an air scrubber.")
			area_good = 0

		if(!A.air_vent_names.len && !(exemptions & GLOB.using_map.NO_VENT))
			log_bad("[bad_msg] lacks an air vent.[ascii_reset]")
			area_good = 0
		else if(A.air_vent_names.len && (exemptions & GLOB.using_map.NO_VENT))
			log_bad("[bad_msg] is not supposed to have an air vent.")
			area_good = 0

		if(!area_good)
			bad_areas.Add(A)

	if(bad_areas.len)
		fail("\[[bad_areas.len]/[area_test_count]\]Some areas did not have the expected APC/vent/scrubber setup.")
	else
		pass("All \[[area_test_count]\] areas contained APCs, air scrubbers, and air vents.")

	return 1

/datum/unit_test/apc_area_test/proc/get_exemptions(var/area)
	// We assume deeper types come last
	for(var/i = GLOB.using_map.apc_test_exempt_areas.len; i>0; i--)
		var/exempt_type = GLOB.using_map.apc_test_exempt_areas[i]
		if(istype(area, exempt_type))
			return GLOB.using_map.apc_test_exempt_areas[exempt_type]

/datum/unit_test/air_alarm_connectivity
	name = "MAP: Air alarms shall receive updates."
	async = TRUE // Waits for SStimers to finish one full run before testing

/datum/unit_test/air_alarm_connectivity/start_test()
	return 1

/datum/unit_test/air_alarm_connectivity/subsystems_to_await()
	return list(SStimer)

/datum/unit_test/air_alarm_connectivity/check_result()
	var/failed = FALSE
	for(var/area/A in world)
		if(!A.z)
			continue
		if(!isPlayerLevel(A.z))
			continue
		var/obj/machinery/alarm/alarm = locate() in A // Only test areas with functional alarms
		if(!alarm)
			continue
		if(alarm.stat & (NOPOWER | BROKEN))
			continue

		for(var/tag in A.air_vent_names) // The point of this test is that while the names list is registered at init, the info is transmitted by radio.
			if(!A.air_vent_info[tag])
				log_bad("Vent [A.air_vent_names[tag]] with id_tag [tag] did not update the air alarm in area [A].")
				failed = TRUE
		for(var/tag in A.air_scrub_names)
			if(!A.air_scrub_info[tag])
				log_bad("Scrubber [A.air_scrub_names[tag]] with id_tag [tag] did not update the air alarm in area [A].")
				failed = TRUE

	if(failed)
		fail("Some areas did not receive updates from all of their atmos devices.")
	else
		pass("All atmos devices updated their area's air alarms successfully.")

	return 1
//=======================================================================================

/datum/unit_test/wire_test
	name = "MAP: Cable Overlap Test"

/datum/unit_test/wire_test/start_test()
	var/wire_test_count = 0
	var/bad_tests = 0
	var/turf/T = null
	var/obj/structure/cable/C = null
	var/list/cable_turfs = list()
	var/list/dirs_checked = list()

	for(C in world)
		T = get_turf(C)
		cable_turfs |= get_turf(C)

	for(T in cable_turfs)
		var/bad_msg = "[ascii_red]--------------- [T.name] \[[T.x] / [T.y] / [T.z]\]"
		dirs_checked.Cut()
		for(C in T)
			wire_test_count++
			var/combined_dir = "[C.d1]-[C.d2]"
			if(combined_dir in dirs_checked)
				bad_tests++
				log_unit_test("[bad_msg] Contains multiple wires with same direction on top of each other.")
			dirs_checked.Add(combined_dir)

	if(bad_tests)
		fail("\[[bad_tests] / [wire_test_count]\] Some turfs had overlapping wires going the same direction.")
	else
		pass("All \[[wire_test_count]\] wires had no overlapping cables going the same direction.")

	return 1

//=======================================================================================

/datum/unit_test/wire_dir_and_icon_stat
	name = "MAP: Cable Dir And Icon State Test"

/datum/unit_test/wire_dir_and_icon_stat/start_test()
	var/list/bad_cables = list()

	for(var/obj/structure/cable/C in world)
		var/expected_icon_state = "[C.d1]-[C.d2]"
		if(C.icon_state != expected_icon_state)
			bad_cables |= C
			log_bad("[log_info_line(C)] has an invalid icon state. Expected [expected_icon_state], was [C.icon_state]")
		if(!(C.icon_state in icon_states(C.icon)))
			bad_cables |= C
			log_bad("[log_info_line(C)] has an non-existing icon state.")

	if(bad_cables.len)
		fail("Found [bad_cables.len] cable\s with an unexpected icon state.")
	else
		pass("All wires had their expected icon state.")

	return 1

//=======================================================================================

/datum/unit_test/closet_test
	name = "MAP: Closet Capacity Test Player Z levels"

/datum/unit_test/closet_test/start_test()
	var/bad_tests = 0

	for(var/obj/structure/closet/C in world)
		if(!C.opened && isPlayerLevel(C.z))
			var/total_content_size = 0
			for(var/atom/movable/AM in C.contents)
				total_content_size += C.content_size(AM)
			if(total_content_size > C.storage_capacity)
				log_bad("[log_info_line(C)] contains more objects than able to hold ([total_content_size] / [C.storage_capacity]).")
				bad_tests++

	if(bad_tests)
		fail("\[[bad_tests]\] Some closets contained more objects than they were able to hold.")
	else
		pass("No overflowing closets found.")

	return 1

//=======================================================================================

/datum/unit_test/closet_containment_test
	name = "MAP: Closet Containment Test Player Z levels"

/datum/unit_test/closet_containment_test/start_test()
	var/bad_tests = 0

	for(var/obj/structure/closet/C in world)
		if(!C.opened && isPlayerLevel(C.z))
			var/contents_pre_open = C.contents.Copy()
			C.dump_contents()
			C.store_contents()
			var/list/no_longer_contained_atoms = contents_pre_open - C.contents
			var/list/previously_not_contained_atoms = C.contents - contents_pre_open

			if(no_longer_contained_atoms.len)
				bad_tests++
				log_bad("[log_info_line(C)] no longer contains the following atoms: [log_info_line(no_longer_contained_atoms)]")
			if(previously_not_contained_atoms.len)
				log_debug("[log_info_line(C)] now contains the following atoms: [log_info_line(previously_not_contained_atoms)]")

	if(bad_tests)
		fail("[bad_tests] closet\s with inconsistent pre/post-open contents found.")
	else
		pass("No closets with inconsistent pre/post-open contents found.")

	return 1

//=======================================================================================

/datum/unit_test/storage_map_test
	name = "MAP: On Map Storage Item Capacity Test Player Z levels"

/datum/unit_test/storage_map_test/start_test()
	var/bad_tests = 0

	for(var/obj/item/weapon/storage/S in world)
		if(isPlayerLevel(S.z))
			var/bad_msg = "[ascii_red]--------------- [S.name] \[[S.type]\] \[[S.x] / [S.y] / [S.z]\]"
			bad_tests += test_storage_capacity(S, bad_msg)

	if(bad_tests)
		fail("\[[bad_tests]\] Some on-map storage items were not able to hold their initial contents.")
	else
		pass("All on-map storage items were able to hold their initial contents.")

	return 1

/datum/unit_test/map_image_map_test
	name = "MAP: All map levels shall have a corresponding map image."

/datum/unit_test/map_image_map_test/start_test()
	var/failed = FALSE

	for(var/z in GLOB.using_map.map_levels)
		var/file_name = map_image_file_name(z)
		var/file_path = MAP_IMAGE_PATH + file_name
		if(!fexists(file_path))
			failed = TRUE
			log_unit_test("[GLOB.using_map.path]-[z] is missing its map image [file_name].")

	if(failed)
		fail("One or more map levels were missing a corresponding map image.")
	else
		pass("All map levels had a corresponding image.")

	return 1

//=======================================================================================

datum/unit_test/correct_allowed_spawn_test
	name = "MAP: All allowed_spawns entries should have spawnpoints on map."

datum/unit_test/correct_allowed_spawn_test/start_test()
	var/failed = FALSE

	for(var/spawn_name in GLOB.using_map.allowed_spawns)
		var/datum/spawnpoint/spawnpoint = spawntypes()[spawn_name]
		if(!spawnpoint)
			log_unit_test("Map allows spawning in [spawn_name], but [spawn_name] is null!")
			failed = TRUE
		else if(!spawnpoint.turfs.len)
			log_unit_test("Map allows spawning in [spawn_name], but [spawn_name] has no associated spawn turfs.")
			failed = TRUE

	if(failed)
		log_unit_test("Following spawn points exist:")
		for(var/spawnpoint in spawntypes())
			log_unit_test("\t[spawnpoint] ([any2ref(spawnpoint)])")
		log_unit_test("Following spawn points are allowed:")
		for(var/spawnpoint in GLOB.using_map.allowed_spawns)
			log_unit_test("\t[spawnpoint] ([any2ref(spawnpoint)])")
		fail("Some of the entries in allowed_spawns have no spawnpoint turfs.")
	else
		pass("All entries in allowed_spawns have spawnpoints.")

	return 1

//=======================================================================================

datum/unit_test/map_check
	name = "MAP: Map Check"

datum/unit_test/map_check/start_test()
	if(world.maxx < 1 || world.maxy < 1 || world.maxz < 1)
		fail("Unexpected map size. Was a map properly included?")
	else
		pass("Map size met minimum requirements.")
	return 1
//=======================================================================================

datum/unit_test/ladder_check
	name = "MAP: Ladder Check"

datum/unit_test/ladder_check/start_test()
	var/succeeded = TRUE
	for(var/obj/structure/ladder/L)
		if(L.allowed_directions & UP)
			succeeded = check_direction(L, GetAbove(L), UP, DOWN) && succeeded
		if(L.allowed_directions & DOWN)
			succeeded = check_direction(L, GetBelow(L), DOWN, UP) && succeeded
			succeeded = check_open_space(L) && succeeded
	if(succeeded)
		pass("All ladders are correctly setup.")
	else
		fail("One or more ladders are incorrectly setup.")

	return 1

/datum/unit_test/ladder_check/proc/check_direction(var/obj/structure/ladder/L, var/turf/destination_turf, var/check_direction, var/other_ladder_direction)
	if(!destination_turf)
		log_bad("Unable to acquire turf in the [dir2text(check_direction)] for [log_info_line(L)]")
		return FALSE
	var/obj/structure/ladder/other_ladder = (locate(/obj/structure/ladder) in destination_turf)
	if(!other_ladder)
		log_bad("Unable to acquire ladder in the direction [dir2text(check_direction)] for [log_info_line(L)]")
		return FALSE
	if(!(other_ladder.allowed_directions & other_ladder_direction))
		log_bad("The ladder in the direction [dir2text(check_direction)] is not allowed to connect to [log_info_line(L)]")
		return FALSE
	return TRUE

/datum/unit_test/ladder_check/proc/check_open_space(var/obj/structure/ladder/L)
	if(!istype(get_turf(L), /turf/simulated/open))
		log_bad("There is a non-open turf blocking the way for [log_info_line(L)]")
		return FALSE
	return TRUE


//=======================================================================================

/datum/unit_test/landmark_check
	name = "MAP: Landmark Check"

/datum/unit_test/landmark_check/start_test()
	var/safe_landmarks = 0
	var/space_landmarks = 0

	for(var/lm in landmarks_list)
		var/obj/effect/landmark/landmark = lm
		if(istype(landmark, /obj/effect/landmark/test/safe_turf))
			log_debug("Safe landmark found: [log_info_line(landmark)]")
			safe_landmarks++
		else if(istype(landmark, /obj/effect/landmark/test/space_turf))
			log_debug("Space landmark found: [log_info_line(landmark)]")
			space_landmarks++
		else if(istype(landmark, /obj/effect/landmark/test))
			log_debug("Test landmark with unknown tag found: [log_info_line(landmark)]")

	if(safe_landmarks != 1 || space_landmarks != 1)
		if(safe_landmarks != 1)
			log_bad("Found [safe_landmarks] safe landmarks. Expected 1.")
		if(space_landmarks != 1)
			log_bad("Found [space_landmarks] space landmarks. Expected 1.")
		fail("Expected exactly one safe landmark, and one space landmark.")
	else
		pass("Exactly one safe landmark, and exactly one space landmark found.")

	return 1

//=======================================================================================

/datum/unit_test/cryopod_comp_check
	name = "MAP: Cryopod Validity Check"

/datum/unit_test/cryopod_comp_check/start_test()
	var/pass = TRUE

	for(var/obj/machinery/cryopod/C in SSmachines.machinery)
		if(!C.control_computer)
			log_bad("[get_area(C)] lacks a cryopod control computer while holding a cryopod.")
			pass = FALSE

	for(var/obj/machinery/computer/cryopod/C in SSmachines.machinery)
		if(!(locate(/obj/machinery/cryopod) in get_area(C)))
			log_bad("[get_area(C)] lacks a cryopod while holding a control computer.")
			pass = FALSE

	if(pass)
		pass("All cryopods have their respective control computers.")
	else
		fail("Cryopods were not set up correctly.")

	return 1

//=======================================================================================

/datum/unit_test/camera_nil_c_tag_check
	name = "MAP: Camera nil c_tag check"

/datum/unit_test/camera_nil_c_tag_check/start_test()
	var/pass = TRUE

	for(var/obj/machinery/camera/C in world)
		if(!C.c_tag)
			log_bad("Following camera does not have a c_tag set: [log_info_line(C)]")
			pass = FALSE

	if(pass)
		pass("Have cameras have the c_tag set.")
	else
		fail("One or more cameras do not have the c_tag set.")

	return 1

//=======================================================================================

/datum/unit_test/camera_unique_c_tag_check
	name = "MAP: Camera unique c_tag check"

/datum/unit_test/camera_unique_c_tag_check/start_test()
	var/cameras_by_ctag = list()
	var/checked_cameras = 0

	for(var/obj/machinery/camera/C in world)
		if(!C.c_tag)
			continue
		checked_cameras++
		group_by(cameras_by_ctag, C.c_tag, C)

	var/number_of_issues = number_of_issues(cameras_by_ctag, "Camera c_tags", /decl/noi_feedback/detailed)
	if(number_of_issues)
		fail("[number_of_issues] issue\s with camera c_tags found.")
	else
		pass("[checked_cameras] camera\s have a unique c_tag.")

	return 1

//=======================================================================================

/datum/unit_test/disposal_segments_shall_connect_with_other_disposal_pipes
	name = "MAP: Disposal segments shall connect with other disposal pipes"

/datum/unit_test/disposal_segments_shall_connect_with_other_disposal_pipes/start_test()
	var/list/faulty_pipes = list()

	// Desired directions for straight pipes, when encountering curved pipes in the main and reversed dir respectively
	var/list/straight_desired_directions = list(
		num2text(SOUTH) = list(list(NORTH, WEST), list(SOUTH, EAST)),
		num2text(EAST) = list(list(SOUTH, WEST), list(NORTH, EAST)))

	// Desired directions for curved pipes:
	// list(desired_straight, list(desired_curved_one, desired_curved_two) in the main and curved direction
	var/list/curved_desired_directions = list(
		num2text(NORTH) = list(list(SOUTH, list(SOUTH, EAST)), list(EAST,  list(SOUTH, WEST))),
		num2text(EAST)  = list(list(EAST,  list(SOUTH, WEST)), list(SOUTH, list(NORTH, WEST))),
		num2text(SOUTH) = list(list(SOUTH, list(NORTH, WEST)), list(EAST,  list(NORTH, EAST))),
		num2text(WEST)  = list(list(EAST,  list(NORTH, EAST)), list(SOUTH, list(SOUTH, EAST))))

	for(var/obj/structure/disposalpipe/segment/D in world)
		if(D.icon_state == "pipe-s")
			if(!(D.dir == SOUTH || D.dir == EAST))
				log_bad("Following disposal pipe has an invalid direction set: [log_info_line(D)]")
				continue
			var/turf/turf_one = get_step(D.loc, D.dir)
			var/turf/turf_two = get_step(D.loc, turn(D.dir, 180))

			var/list/desired_dirs = straight_desired_directions[num2text(D.dir)]
			if(!turf_contains_matching_disposal_pipe(turf_one, D.dir, desired_dirs[1]) || !turf_contains_matching_disposal_pipe(turf_two, D.dir, desired_dirs[2]))
				log_bad("Following disposal pipe does not connect correctly: [log_info_line(D)]")
				faulty_pipes += D
		else
			var/turf/turf_one = get_step(D.loc, D.dir)
			var/turf/turf_two = get_step(D.loc, turn(D.dir, -90))

			var/list/desired_dirs = curved_desired_directions[num2text(D.dir)]
			var/main_dirs = desired_dirs[1]
			var/rev_dirs = desired_dirs[2]

			if(!turf_contains_matching_disposal_pipe(turf_one, main_dirs[1], main_dirs[2]) || !turf_contains_matching_disposal_pipe(turf_two, rev_dirs[1], rev_dirs[2]))
				log_bad("Following disposal pipe does not connect correctly: [log_info_line(D)]")
				faulty_pipes += D

	if(faulty_pipes.len)
		fail("[faulty_pipes.len] disposal segment\s did not connect with other disposal pipes.")
	else
		pass("All disposal segments connect with other disposal pipes.")

	return 1

/datum/unit_test/disposal_segments_shall_connect_with_other_disposal_pipes/proc/turf_contains_matching_disposal_pipe(var/turf/T, var/straight_dir, var/list/curved_dirs)
	if(!T)
		return FALSE

	// We need to loop over all potential pipes in a turf as long as there isn't a dir match, as they may be overlapping (i.e. 2 straight pipes in a cross)
	for(var/obj/structure/disposalpipe/D in T)
		if(D.type == /obj/structure/disposalpipe/segment)
			if(D.icon_state == "pipe-s")
				if(D.dir == straight_dir)
					return TRUE
			else
				if(D.dir in curved_dirs)
					return TRUE
		else
			return TRUE
	return FALSE

//=======================================================================================

/datum/unit_test/simple_pipes_shall_not_face_north_or_west // The init code is worthless and cannot handle it
	name = "MAP: Simple pipes shall not face north or west"

/datum/unit_test/simple_pipes_shall_not_face_north_or_west/start_test()
	var/failures = 0
	for(var/obj/machinery/atmospherics/pipe/simple/pipe in world) // Pipes are removed from the SSmachines list during init.
		if(!istype(pipe, /obj/machinery/atmospherics/pipe/simple/hidden) && !istype(pipe, /obj/machinery/atmospherics/pipe/simple/visible))
			continue
		if(pipe.dir == NORTH || pipe.dir == WEST)
			log_bad("Following pipe had an invalid direction: [log_info_line(pipe)]")
			failures++

	if(failures)
		fail("[failures] simple pipe\s faced the wrong direction.")
	else
		pass("All simple pipes faced an appropriate direction.")
	return 1

//=======================================================================================

/datum/unit_test/shutoff_valves_shall_connect_to_two_different_pipe_networks
	name = "MAP: Shutoff valves shall connect to two different pipe networks"

/datum/unit_test/shutoff_valves_shall_connect_to_two_different_pipe_networks/start_test()
	var/failures = 0
	for(var/obj/machinery/atmospherics/valve/shutoff/SV in SSmachines.machinery)
		SV.close()
	for(var/obj/machinery/atmospherics/valve/shutoff/SV in SSmachines.machinery)
		if(SV.network_node1 == SV.network_node2)
			log_bad("Following shutoff valve does not connect to two different pipe networks: [log_info_line(SV)]")
			failures++

	if(failures)
		fail("[failures] shutoff valves did not connect to two different pipe networks.")
	else
		pass("All shutoff valves connect to two different pipe networks.")
	return 1

//=======================================================================================

/datum/unit_test/station_pipes_shall_not_leak
	name = "MAP: Station pipes shall not leak"

/datum/unit_test/station_pipes_shall_not_leak/start_test()
	var/failures = 0
	for(var/obj/machinery/atmospherics/pipe/P in world)
		if(P.leaking && isStationLevel(P.z))
			failures++
			log_bad("Following pipe is leaking: [log_info_line(P)]")

	if(failures)
		fail("[failures] station pipe\s leak.")
	else
		pass("No station pipes are leaking")
	return 1

//=======================================================================================

/datum/unit_test/station_power_terminals_shall_be_wired
	name = "MAP: Station power terminals shall be wired"

/datum/unit_test/station_power_terminals_shall_be_wired/start_test()
	var/failures = 0
	for(var/obj/machinery/power/terminal/term in SSmachines.machinery)
		var/turf/T = get_turf(term)
		if(!T)
			failures++
			log_bad("Nullspace terminal : [log_info_line(term)]")
			continue

		if(!isStationLevel(T.z))
			continue

		var/found_cable = FALSE
		for(var/obj/structure/cable/C in T)
			if(C.d2 > 0 && C.d1 == 0)
				found_cable = TRUE
				break
		if(!found_cable)
			failures++
			log_bad("Unwired terminal : [log_info_line(term)]")

	if(failures)
		fail("[failures] unwired power terminal\s.")
	else
		pass("All station power terminals are wired.")
	return 1

//=======================================================================================

/datum/unit_test/station_wires_shall_be_connected
	name = "MAP: Station wires shall be connected"
	var/list/exceptions

/datum/unit_test/station_wires_shall_be_connected/start_test()
	var/failures = 0

	var/exceptions_by_turf = list()
	for(var/exception in exceptions)
		var/turf/T = locate(exception[1], exception[2], exception[3])
		if(!T)
			CRASH("Invalid exception: [exception[1]] - [exception[2]] - [exception[3]]")
		if(!(T in exceptions_by_turf))
			exceptions_by_turf[T] = list()
		exceptions_by_turf[T] += exception[4]
	exceptions = exceptions_by_turf

	for(var/obj/structure/cable/C in world)
		if(!all_ends_connected(C))
			failures++

	if(failures)
		fail("Found [failures] cable\s without connections.")
	else if(exceptions.len)
		for(var/entry in exceptions)
			log_bad("[log_info_line(entry)] - [english_list(exceptions[entry])] ")
		fail("Unnecessary exceptions need to be cleaned up.")
	else
		pass("All station wires are properly connected.")

	return 1

// We work on the assumption that another test ensures we only have valid directions
/datum/unit_test/station_wires_shall_be_connected/proc/all_ends_connected(var/obj/structure/cable/C)
	. = TRUE

	var/turf/source_turf = get_turf(C)
	if(!source_turf)
		log_bad("Nullspace wire: [log_info_line(C)]")
		return FALSE

	// We don't care about non-station wires
	if(!isStationLevel(source_turf.z))
		return TRUE

	for(var/dir in list(C.d1, C.d2))
		if(!dir) // Don't care about knots
			continue
		var/rev_dir = GLOB.reverse_dir[dir]

		var/list/exception = exceptions[source_turf]
		if(exception && (dir in exception))
			exception -= dir
			if(!exception.len)
				exceptions -= source_turf
			continue

		var/turf/target_turf
		if(dir == UP)
			target_turf = GetAbove(C)
		if(dir == DOWN)
			target_turf = GetBelow(C)
		else
			target_turf = get_step(C, dir)

		var/connected = FALSE
		for(var/obj/structure/cable/revC in target_turf)
			if(revC.d1 == rev_dir || revC.d2 == rev_dir)
				connected = TRUE
				break

		if(!connected)
			log_bad("Disconnected wire: [dir2text(dir)] - [log_info_line(C)]")
			. = FALSE

/datum/unit_test/networked_disposals_shall_deliver_tagged_packages
	name = "MAP: Networked disposals shall deliver tagged packages"
	async = 1

	var/extra_spawns = 1

	var/list/packages_awaiting_delivery = list()
	var/list/all_tagged_bins = list()
	var/list/all_tagged_destinations = list()

	var/failed = FALSE
	var/list/exempt_junctions = list(
		/obj/structure/disposalpipe/sortjunction/untagged
	)

/datum/unit_test/networked_disposals_shall_deliver_tagged_packages/start_test()
	. = 1
	var/fail = FALSE
	for(var/obj/structure/disposalpipe/sortjunction/sort in world)
		if(is_type_in_list(sort, exempt_junctions))
			continue
		var/obj/machinery/disposal/bin = get_bin_from_junction(sort)
		if(!bin)
			log_bad("Junction with tag [sort.sort_type] at ([sort.x], [sort.y], [sort.z]) could not find disposal.")
			fail = TRUE
			continue
		all_tagged_destinations[sort.sort_type] = bin
		if(!istype(bin)) // Can also be an outlet.
			continue
		all_tagged_bins[sort.sort_type] = bin
	if(fail)
		fail("Improperly connected junction detected.")
		return
	for(var/target_tag in all_tagged_destinations)
		var/start_tag = all_tagged_bins[target_tag] ? target_tag : pick(all_tagged_bins)
		spawn_package(start_tag, target_tag)
		for(var/i in 1 to extra_spawns)
			spawn_package(pick(all_tagged_bins), target_tag) // This potentially helps catch errors in junction logic.

/datum/unit_test/networked_disposals_shall_deliver_tagged_packages/proc/spawn_package(start_tag, target_tag)
	var/obj/structure/disposalholder/unit_test/package = new()
	package.tomail = 1
	package.destinationTag = target_tag
	package.start(all_tagged_bins[start_tag])
	package.test = src
	packages_awaiting_delivery[package] = start_tag

/obj/structure/disposalholder/unit_test
	var/datum/unit_test/networked_disposals_shall_deliver_tagged_packages/test
	speed = 100

/obj/structure/disposalholder/unit_test/Destroy()
	test.package_delivered(src)
	. = ..()

/obj/structure/disposalholder/unit_test/Process()
	for(var/i in 1 to speed) // Go faster, as it takes a while and we don't want to wait forever.
		. = ..()
		if(. == PROCESS_KILL)
			if(QDELETED(src) || !test.packages_awaiting_delivery[src])
				return
			log_and_fail()
			return

/obj/structure/disposalholder/unit_test/proc/log_and_fail()
	var/location = log_info_line(get_turf(src))
	var/expected_loc = log_info_line(get_turf(test.all_tagged_destinations[destinationTag]))
	test.log_bad("A package routed from [test.packages_awaiting_delivery[src]] to [destinationTag] was misrouted to [location]; expected location was [expected_loc].")
	test.failed = TRUE
	test.packages_awaiting_delivery -= src

/datum/unit_test/networked_disposals_shall_deliver_tagged_packages/check_result()
	. = 1
	if(failed)
		fail("A package has been delivered to an incorrect location.")
		return
	if(!packages_awaiting_delivery.len)
		pass("All packages delivered.")
		return
	return 0

/datum/unit_test/networked_disposals_shall_deliver_tagged_packages/proc/package_delivered(var/obj/structure/disposalholder/unit_test/package)
	if(!packages_awaiting_delivery[package])
		return
	var/obj/structure/disposalpipe/trunk/trunk = package.loc

	if(!istype(trunk))
		package.log_and_fail()
		return
	var/obj/linked = trunk.linked
	if(all_tagged_destinations[package.destinationTag] != linked)
		package.log_and_fail()
		return
	packages_awaiting_delivery -= package

/datum/unit_test/networked_disposals_shall_deliver_tagged_packages/proc/get_bin_from_junction(var/obj/structure/disposalpipe/sortjunction/sort)
	var/list/traversed = list(sort) // Avoid self-looping, infinite loops.
	var/obj/structure/disposalpipe/our_pipe = sort
	var/current_dir = sort.sortdir
	while(1)
		if(istype(our_pipe, /obj/structure/disposalpipe/trunk))
			var/obj/structure/disposalpipe/trunk/trunk = our_pipe
			return trunk.linked
		var/obj/structure/disposalpipe/next_pipe
		for(var/obj/structure/disposalpipe/P in get_step(our_pipe, current_dir))
			if(turn(current_dir, 180) & P.dpdir)
				next_pipe = P
				break
		if(!istype(next_pipe))
			return
		if(next_pipe in traversed)
			return
		traversed += next_pipe
		current_dir = next_pipe.nextdir(current_dir, sort.sort_type)
		our_pipe = next_pipe

/datum/unit_test/req_access_shall_have_valid_strings
	name = "MAP: every obj shall have valid access strings in req_access"
	var/list/accesses

/datum/unit_test/req_access_shall_have_valid_strings/start_test()
	if(!accesses)
		accesses = get_all_access_datums()

	var/list/obj_access_pairs = list()
	for(var/obj/O in world)
		if(O.req_access)
			for(var/req in O.req_access)
				if(islist(req))
					for(var/req_one in req)
						if(is_invalid(req_one))
							obj_access_pairs += list(list(O, req_one))
				else if(is_invalid(req))
					obj_access_pairs += list(list(O, req))

	if(obj_access_pairs.len)
		for(var/entry in obj_access_pairs)
			log_bad("[log_info_line(entry[1])] has an invalid value ([entry[2]]) in req_access.")
		fail("Mapped objs with req_access must be set up to use existing access strings.")
	else
		pass("All mapped objs have correctly set req_access.")

	return 1

/datum/unit_test/req_access_shall_have_valid_strings/proc/is_invalid(var/value)
	if(!istext(value))
		return TRUE //Someone tried to use a non-string as an access. There is no case where this is allowed.

	for(var/datum/access/A in accesses)
		if(value == A.id)
			return FALSE

	return TRUE

#undef SUCCESS
#undef FAILURE
