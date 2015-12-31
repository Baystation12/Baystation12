/*
 *
 *  Zas Unit Tests.
 *  Shuttle Pressurized.
 *  
 *
 */

#define UT_NORMAL 1                   // Standard one atmosphere 20celsius
#define UT_VACUME 2                   // Vacume on simulated turfs
#define UT_NORMAL_COLD 3              // Cold but standard atmosphere.

//
// Generic check for an area.
//

datum/unit_test/zas_area_test
	name = "ZAS: Area Test Template"
	disabled = 1                            // For all child objects we have to put 0 so the test runs
	var/area_path = null                    // Put the area you are testing here.
	var/expectation = UT_NORMAL             // If the area is supposed to be a vacume set to 1

datum/unit_test/zas_area_test/start_test()
	var/list/result = test_air_in_area(area_path, expectation)
	if(isnull(result))
		fail("Check Runtimed")

	if(result["success"])
		pass(result["msg"])
	else
		fail(result["msg"])
	return 1

// ==================================================================================================

//
//	The primary helper proc.
//
proc/test_air_in_area(var/test_area, var/expectation = UT_NORMAL)
	var/area/A = locate(test_area)

	if(!istype(A, test_area))
		return(list("success" = 0,  "msg" = "Unable to get [test_area]"))

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

			if(UT_VACUME)
				if(pressure > 10)
					return(list("success" = 0, "msg" = "Pressure out of bounds: [pressure] | [t_msg]"))


			if(UT_NORMAL || UT_NORMAL_COLD)
				if(abs(pressure - ONE_ATMOSPHERE) > 10)
					return(list("success" = 0, "msg" = "Pressure out of bounds: [pressure] | [t_msg]"))

				if(expectation == UT_NORMAL)
	
					if(abs(temp - T20C) > 10)
						return(list("success" = 0, "msg" = "Temperature out of bounds: [temp] | [t_msg]"))

				if(expectation == UT_NORMAL_COLD)

					if(temp > 120)
						return(list("success" = 0, "msg" = "Temperature out of bounds: [temp] | [t_msg]"))

		GM_checked.Add(GM)

	if(GM_checked.len)
		return(list("success"=1, "msg" = "Checked [GM_checked.len] zones"))
	else
		return(list("success"=0, "msg" = "No zones checked."))


// ==================================================================================================

datum/unit_test/zas_area_test/supply_centcomm
	name = "ZAS: Supply Shuttle (CentComm)"
	area_path = /area/supply/dock
	disabled = 0

datum/unit_test/zas_area_test/emergency_shuttle
	name = "ZAS: Emergency Shuttle"
	area_path = /area/shuttle/escape/centcom
	disabled = 0

datum/unit_test/zas_area_test/ai_chamber
	name = "ZAS: AI Chamber"
	area_path = /area/turret_protected/ai
	disabled = 0

datum/unit_test/zas_area_test/arrival_maint
	name = "ZAS: Arrival Maintenance"
	area_path = /area/maintenance/arrivals
	disabled = 0

datum/unit_test/zas_area_test/mining_shuttle_at_station
	name = "ZAS: Mining Shuttle (Station)"
	area_path = /area/shuttle/mining/station
	disabled = 0

datum/unit_test/zas_area_test/
	name = "ZAS: Cargo Maintenance"
	area_path = /area/maintenance/cargo 
	disabled = 0

datum/unit_test/zas_area_test/eng_shuttle
	name = "ZAS: Construction Site Shuttle (Station)"
	area_path = /area/shuttle/constructionsite/station
	disabled = 0

datum/unit_test/zas_area_test/incinerator
	name = "ZAS: Incinerator"
	area_path = /area/maintenance/incinerator 
	disabled = 1		//Failing currently for existing bug: #11846

datum/unit_test/zas_area_test/virology
	name = "ZAS: Virology"
	area_path = /area/medical/virology
	disabled = 0

datum/unit_test/zas_area_test/xenobio
	name = "ZAS: Xenobiology"
	area_path = /area/rnd/xenobiology 
	disabled = 0

datum/unit_test/zas_area_test/research_maint_starboard
	name = "ZAS: Research Starboard Maintenance"
	area_path = /area/maintenance/research_starboard
	disabled = 0

datum/unit_test/zas_area_test/west_hall_mining_outpost
	name = "ZAS: Mining outpost West Hallway"
	area_path = /area/outpost/mining_main/west_hall
	disabled = 0

datum/unit_test/zas_area_test/mining_area
	name = "ZAS: Mining Area (Vacume)"
	area_path = /area/mine/explored
	disabled = 0
	expectation = UT_VACUME

datum/unit_test/zas_area_test/
	name = "ZAS:  Cargo Bay"
	area_path = /area/quartermaster/storage
	disabled = 0


// ==================================================================================================


// Here we move a shuttle then test it's area once the shuttle has arrived.

datum/unit_test/zas_supply_shuttle_moved
	name = "ZAS: Supply Shuttle (When Moved)"

	async=1				// We're moving the shuttle using built in procs.

	var/datum/shuttle/ferry/supply/Shuttle = null

datum/unit_test/zas_supply_shuttle_moved/start_test()

	if(!shuttle_controller || !shuttle_controller.shuttles.len)
		fail("Shuttle Controller not setup at time of test.")
	
	Shuttle = shuttle_controller.shuttles["Supply"]
	supply_controller.movetime = 5 // Speed up the shuttle movement.

	if(isnull(Shuttle))
		fail("Unable to locate the supply shuttle")

	// Initiate the Move.
	Shuttle.short_jump(Shuttle.area_offsite, Shuttle.area_station)

	sleep(20)	// Give the shuttle some time to do it's thing.

	return 1

datum/unit_test/zas_supply_shuttle_moved/check_result()
	if(Shuttle.moving_status == SHUTTLE_IDLE && !Shuttle.at_station())
		fail("Shuttle Did not Move")
		return 1

	if(!Shuttle.at_station())
		return 0

	sleep(20)	// Give ZAS a chance to catchup.

	var/list/result = test_air_in_area(/area/supply/station)
	if(isnull(result))
		fail("Check Runtimed")
		return 1

	if(result["success"])
		pass(result["msg"])
	else
		fail(result["msg"])
	return 1

#undef UT_NORMAL
#undef UT_VACUME
#undef UT_NORMAL_COLD
