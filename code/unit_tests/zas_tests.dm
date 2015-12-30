/*
 *
 *  Zas Unit Tests.
 *  Shuttle Pressurized.
 *  
 *
 */

//
// Tests Pressurization of known problem areas.

datum/unit_test/zas_escape_shuttle
        name = "ZAS: Escape Shuttle"

datum/unit_test/zas_escape_shuttle/start_test()
	var/list/result = test_air_in_area(/area/shuttle/escape/centcom)
	if(isnull(result))
		fail("Check Runtimed")

	if(result["success"])
		pass(result["msg"])
	else
		fail(result["msg"])
	return 1

// ==================================================================================================

proc/test_air_in_area(var/test_area)
	var/area/A = locate(test_area)

	if(!istype(A, test_area))
		return(list("success" = 0,  "msg" = "Unable to get [test_area]"))

	var/list/GM_checked = list()

	for(var/turf/simulated/T in A)

		if(!istype(T) || isnull(T.zone) || istype(T, /turf/simulated/floor/airless))
			continue
		if(T.zone.air in GM_checked)
			continue

		var/datum/gas_mixture/GM = T.return_air()

		var/pressure = GM.return_pressure()

		if(abs(pressure - ONE_ATMOSPHERE) > 10)
			return(list("success" = 0, "msg" = "Pressure out of bounds: [pressure]"))

		var/temp = GM.temperature

		if(abs(temp - T20C) > 10)
			return(list("success" = 0, "msg" = "Temperature out of bounds: [temp]"))

		GM_checked.Add(GM)

	if(GM_checked.len)
		return(list("success"=1, "msg" = "Checked [GM_checked.len] zones"))
	else
		return(list("success"=0, "msg" = "No zones checked."))


// ==================================================================================================

datum/unit_test/zas_supply_shuttle_centcomm
	name = "ZAS: Supply Shuttle (At CentComm)"

datum/unit_test/zas_supply_shuttle_centcomm/start_test()
	var/list/result = test_air_in_area(/area/supply/dock)
	if(isnull(result))
		fail("Check Runtimed")
		return 1

	if(result["success"])
		pass(result["msg"])
	else
		fail(result["msg"])
	return 1

// ==================================================================================================

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


