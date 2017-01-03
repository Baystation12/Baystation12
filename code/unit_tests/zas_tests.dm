/*
 *
 *  Zas Unit Tests.
 *  Shuttle Pressurized.
 *
 *
 */

#define UT_NORMAL 1                   // Standard one atmosphere 20celsius
#define UT_VACUUM 2                   // Vacume on simulated turfs
#define UT_NORMAL_COLD 3              // Cold but standard atmosphere.

#define FAILURE 0
#define SUCCESS 1
#define SKIP 2

//
// Generic check for an area.
//

datum/unit_test/zas_area_test
	name = "ZAS: Area Test Template"
	var/area_path = null                    // Put the area you are testing here.
	var/expectation = UT_NORMAL             // See defines above.

datum/unit_test/zas_area_test/start_test()
	var/list/test = test_air_in_area(area_path, expectation)

	if(isnull(test))
		fail("Check Runtimed")

	switch(test["result"])
		if(SUCCESS) pass(test["msg"])
		if(SKIP)    skip(test["msg"])
		else        fail(test["msg"])
	return 1

// ==================================================================================================

//
//	The primary helper proc.
//
proc/test_air_in_area(var/test_area, var/expectation = UT_NORMAL)
	var/test_result = list("result" = FAILURE, "msg"    = "")

	var/area/A = locate(test_area)

	// BYOND creates an instance of every area, so this can't be !A or !istype(A, test_area)
	if(!(A.x || A.y || A.z))
		test_result["msg"] = "Unable to get [test_area]"
		test_result["result"] = FAILURE
		return test_result

	var/list/GM_checked = list()

	for(var/turf/simulated/T in A)

		if(!istype(T) || isnull(T.zone) || istype(T, /turf/simulated/floor/airless))
			continue
		if(T.zone.air in GM_checked)
			continue

		var/t_msg = "Turf: [T] |  Location: [T.x] // [T.y] // [T.z]"

		var/datum/gas_mixture/GM = T.return_air()
		var/pressure = GM.return_pressure()
		var/temp = GM.temperature

		switch(expectation)

			if(UT_VACUUM)
				if(pressure > 10)
					test_result["msg"] = "Pressure out of bounds: [pressure] | [t_msg]"
					return test_result


			if(UT_NORMAL || UT_NORMAL_COLD)
				if(abs(pressure - ONE_ATMOSPHERE) > 10)
					test_result["msg"] = "Pressure out of bounds: [pressure] | [t_msg]"
					return test_result

				if(expectation == UT_NORMAL)

					if(abs(temp - T20C) > 10)
						test_result["msg"] = "Temperature out of bounds: [temp] | [t_msg]"
						return test_result

				if(expectation == UT_NORMAL_COLD)

					if(temp > 120)
						test_result["msg"] = "Temperature out of bounds: [temp] | [t_msg]"
						return test_result

		GM_checked.Add(GM)

	if(GM_checked.len)
		test_result["result"] = SUCCESS
		test_result["msg"] = "Checked [GM_checked.len] zones"
	else
		test_result["msg"] = "No zones checked."

	return test_result


// ==================================================================================================


// Here we move a shuttle then test it's area once the shuttle has arrived.

datum/unit_test/zas_supply_shuttle_moved
	name = "ZAS: Supply Shuttle (When Moved)"
	async=1				// We're moving the shuttle using built in procs.

	var/datum/shuttle/ferry/supply/shuttle = null

	var/testtime = 0	//Used as a timer.

datum/unit_test/zas_supply_shuttle_moved/start_test()

	if(!shuttle_controller)
		fail("Shuttle Controller not setup at time of test.")
		return 1
	if(!shuttle_controller.shuttles.len)
		skip("No shuttles have been setup for this map.")
		return 1

	shuttle = supply_controller.shuttle
	if(isnull(shuttle))
		return 1

	// Initiate the Move.
	supply_controller.movetime = 5 // Speed up the shuttle movement.
	shuttle.short_jump(shuttle.landmark_offsite, shuttle.landmark_station)

	return 1

datum/unit_test/zas_supply_shuttle_moved/check_result()
	if(!shuttle)
		skip("This map has no supply shuttle.")
		return 1

	if(shuttle.moving_status == SHUTTLE_IDLE && !shuttle.at_station())
		fail("Shuttle Did not Move")
		return 1

	if(!shuttle.at_station())
		return 0

	if(!testtime)
		testtime = world.time+40                // Wait another 2 ticks then proceed.

	if(world.time < testtime)
		return 0

	var/list/test = test_air_in_area(/area/supply/station)
	if(isnull(test))
		fail("Check Runtimed")
		return 1

	switch(test["result"])
		if(SUCCESS) pass(test["msg"])
		if(SKIP)    skip(test["msg"])
		else        fail(test["msg"])
	return 1

#undef UT_NORMAL
#undef UT_VACUUM
#undef UT_NORMAL_COLD
#undef SUCCESS
#undef FAILURE
