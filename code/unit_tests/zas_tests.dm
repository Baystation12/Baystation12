/*
 *
 *  Zas Unit Tests.
 *  Shuttle Pressurized.
 *  
 *
 */

//
// Tests Life() and mob breathing in space.

datum/unit_test/zas_shuttle_pressure
        name = "Escape Shuttle Pressurized"

datum/unit_test/zas_shuttle_pressure/start_test()
	//This needs to be broken down into a helper proc.
	var/area/A = locate(/area/shuttle/escape/centcom)

	if(!istype(A, /area/shuttle/escape/centcom))
		fail("Unable to get /area/shuttle/escape/centcom")

	var/list/GM_checked = list()

	for(var/turf/simulated/T in A)

		if(!istype(T) || isnull(T.zone) || istype(T, /turf/simulated/floor/airless))
			continue
		if(T.zone.air in GM_checked)
			continue

		var/datum/gas_mixture/GM = T.return_air()

		var/pressure = GM.return_pressure()

		if(abs(pressure - ONE_ATMOSPHERE) > 10)
			fail("Pressure out of bounds: [pressure]")
			return 0
		
		var/temp = GM.temperature

		if(abs(temp - T20C) > 10)
			fail("Temperature out of bounds: [temp]")
			return 0

		GM_checked.Add(GM)

	
	pass("Pass.  Checked [GM_checked.len] zones")
	return 1

// ============================================================================
