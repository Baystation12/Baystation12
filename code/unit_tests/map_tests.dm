/*
 *
 *  Map Unit Tests.
 *  Zone checks / APC / Scrubber / Vent.
 *
 *
 */

#define FAILURE 0
#define SUCCESS 1


datum/unit_test/apc_area_test
	name = "MAP: Area Test APC / Scrubbers / Vents"


datum/unit_test/apc_area_test/start_test()
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
		if(!A.apc && !(exemptions & using_map.NO_APC))
			log_bad("[bad_msg] lacks an APC.")
			area_good = 0
		else if(A.apc && (exemptions & using_map.NO_APC))
			log_bad("[bad_msg] is not supposed to have an APC.")
			area_good = 0

		if(!A.air_scrub_info.len && !(exemptions & using_map.NO_SCRUBBER))
			log_bad("[bad_msg] lacks an air scrubber.")
			area_good = 0
		else if(A.air_scrub_info.len && (exemptions & using_map.NO_SCRUBBER))
			log_bad("[bad_msg] is not supposed to have an air scrubber.")
			area_good = 0

		if(!A.air_vent_info.len && !(exemptions & using_map.NO_VENT))
			log_bad("[bad_msg] lacks an air vent.[ascii_reset]")
			area_good = 0
		else if(A.air_vent_info.len && (exemptions & using_map.NO_VENT))
			log_bad("[bad_msg] is not supposed to have an air vent.")
			area_good = 0

		if(!area_good)
			bad_areas.Add(A)

	if(bad_areas.len)
		fail("\[[bad_areas.len]/[area_test_count]\]Some areas did not have the expected APC/vent/scrubber setup.")
	else
		pass("All \[[area_test_count]\] areas contained APCs, air scrubbers, and air vents.")

	return 1

datum/unit_test/apc_area_test/proc/get_exemptions(var/area)
	// We assume deeper types come last
	for(var/i = using_map.apc_test_exempt_areas.len; i>0; i--)
		var/exempt_type = using_map.apc_test_exempt_areas[i]
		if(istype(area, exempt_type))
			return using_map.apc_test_exempt_areas[exempt_type]

//=======================================================================================

datum/unit_test/wire_test
	name = "MAP: Cable Overlap Test"

datum/unit_test/wire_test/start_test()
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

datum/unit_test/wire_dir_and_icon_stat
	name = "MAP: Cable Dir And Icon State Test"

datum/unit_test/wire_dir_and_icon_stat/start_test()
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

datum/unit_test/closet_test
	name = "MAP: Closet Capacity Test Player Z levels"

datum/unit_test/closet_test/start_test()
	var/bad_tests = 0

	for(var/obj/structure/closet/C in world)
		if(!C.opened && isPlayerLevel(C.z))
			var/total_content_size = 0
			for(var/atom/movable/AM in C.contents)
				total_content_size += C.content_size(AM)
			if(total_content_size > C.storage_capacity)
				var/bad_msg = "[ascii_red]--------------- [C.name] \[[C.x] / [C.y] / [C.z]\]"
				log_unit_test("[bad_msg] Contains more objects than able to hold ([total_content_size] / [C.storage_capacity]). [ascii_reset]")
				bad_tests++

	if(bad_tests)
		fail("\[[bad_tests]\] Some closets contained more objects than they were able to hold.")
	else
		pass("No overflowing closets found.")

	return 1

//=======================================================================================

datum/unit_test/storage_map_test
	name = "MAP: On Map Storage Item Capacity Test Player Z levels"

datum/unit_test/storage_map_test/start_test()
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

datum/unit_test/map_image_map_test
	name = "MAP: All map levels shall have a corresponding map image."

datum/unit_test/map_image_map_test/start_test()
	var/failed = FALSE

	for(var/z in using_map.map_levels)
		var/file_name = map_image_file_name(z)
		var/file_path = MAP_IMAGE_PATH + file_name
		if(!fexists(file_path))
			failed = TRUE
			log_unit_test("[using_map.path]-[z] is missing its map image [file_name].")

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

	for(var/spawn_name in using_map.allowed_spawns)
		var/datum/spawnpoint/spawnpoint = spawntypes[spawn_name]
		if(!spawnpoint.turfs.len)
			log_unit_test("Map allows spawning in [spawn_name], but [spawn_name] has no associated spawn turfs.")
			failed = TRUE

	if(failed)
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
	if(succeeded)
		pass("All ladders are correctly setup.")
	else
		fail("One or more ladders are incorrectly setup.")

	return 1

datum/unit_test/ladder_check/proc/check_direction(var/obj/structure/ladder/L, var/turf/destination_turf, var/check_direction, var/other_ladder_direction)
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

#undef SUCCESS
#undef FAILURE
