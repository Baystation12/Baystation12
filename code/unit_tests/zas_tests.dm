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

	if(test["result"] == SUCCESS)
		pass(test["msg"])
	else
		fail(test["msg"])
	return 1

// ==================================================================================================

//
//	The primary helper proc.
//
proc/test_air_in_area(var/test_area, var/expectation = UT_NORMAL)
	var/test_result = list("result" = FAILURE, "msg"    = "")

	var/area/A = locate(test_area)

	if(!istype(A, test_area))
		test_result["msg"] = "Unable to get [test_area]"
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

datum/unit_test/zas_area_test/supply_centcomm
	name = "ZAS: Supply Shuttle (CentComm)"
	area_path = /area/supply/dock

datum/unit_test/zas_area_test/emergency_shuttle
	name = "ZAS: Emergency Shuttle"
	area_path = /area/shuttle/escape/centcom

datum/unit_test/zas_area_test/ai_chamber
	name = "ZAS: AI Chamber"
	area_path = /area/turret_protected/ai

datum/unit_test/zas_area_test/arrival_maint
	name = "ZAS: Arrival Maintenance"
	area_path = /area/maintenance/arrivals

datum/unit_test/zas_area_test/mining_shuttle_at_station
	name = "ZAS: Mining Shuttle (Station)"
	area_path = /area/shuttle/mining/station

datum/unit_test/zas_area_test/
	name = "ZAS: Cargo Maintenance"
	area_path = /area/maintenance/cargo 

datum/unit_test/zas_area_test/eng_shuttle
	name = "ZAS: Construction Site Shuttle (Station)"
	area_path = /area/shuttle/constructionsite/station

datum/unit_test/zas_area_test/incinerator
	name = "ZAS: Incinerator"
	area_path = /area/maintenance/incinerator 
	disabled = 1		
	why_disabled = "Scrubber pulls air, this area cannot be tested."

datum/unit_test/zas_area_test/virology
	name = "ZAS: Virology"
	area_path = /area/medical/virology

datum/unit_test/zas_area_test/xenobio
	name = "ZAS: Xenobiology"
	area_path = /area/rnd/xenobiology 

datum/unit_test/zas_area_test/research_maint_starboard
	name = "ZAS: Research Starboard Maintenance"
	area_path = /area/maintenance/research_starboard

datum/unit_test/zas_area_test/west_hall_mining_outpost
	name = "ZAS: Mining outpost West Hallway"
	area_path = /area/outpost/mining_main/west_hall

/*
datum/unit_test/zas_area_test/mining_area
	name = "ZAS: Mining Area (Vacuum)"
	area_path = /area/mine/explored
	expectation = UT_VACUUM
	disabled = 1
	why_disabled = "Asteroid Generation disabled"
 */
datum/unit_test/zas_area_test/
	name = "ZAS: Cargo Bay"
	area_path = /area/quartermaster/storage


// ==================================================================================================


// Here we move a shuttle then test it's area once the shuttle has arrived.

datum/unit_test/zas_supply_shuttle_moved
	name = "ZAS: Supply Shuttle (When Moved)"
	async=1				// We're moving the shuttle using built in procs.

	var/datum/shuttle/ferry/supply/Shuttle = null

	var/testtime = 0	//Used as a timer.

datum/unit_test/zas_supply_shuttle_moved/start_test()

	if(!shuttle_controller || !shuttle_controller.shuttles.len)
		fail("Shuttle Controller not setup at time of test.")
	
	Shuttle = shuttle_controller.shuttles["Supply"]
	supply_controller.movetime = 5 // Speed up the shuttle movement.

	if(isnull(Shuttle))
		fail("Unable to locate the supply shuttle")

	// Initiate the Move.
	Shuttle.short_jump(Shuttle.area_offsite, Shuttle.area_station)

	return 1

datum/unit_test/zas_supply_shuttle_moved/check_result()
	if(Shuttle.moving_status == SHUTTLE_IDLE && !Shuttle.at_station())
		fail("Shuttle Did not Move")
		return 1

	if(!Shuttle.at_station())
		return 0

	if(!testtime)
		testtime = world.time+40                // Wait another 2 ticks then proceed.

	if(world.time < testtime)
		return 0
		

	var/list/test = test_air_in_area(/area/supply/station)
	if(isnull(test))
		fail("Check Runtimed")
		return 1

	if(test["result"] == SUCCESS)
		pass(test["msg"])
	else
		fail(test["msg"])
	return 1

#undef UT_NORMAL
#undef UT_VACUUM
#undef UT_NORMAL_COLD
#undef SUCCESS
#undef FAILURE
