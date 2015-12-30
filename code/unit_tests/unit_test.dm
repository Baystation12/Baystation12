var/all_unit_tests_passed = 1
var/failed_unit_tests = 0
var/total_unit_tests = 0

datum/unit_test
	var/name = "Fix Me"
	var/DISABLED = 0	// If we want to keep a unit test in the codebase but not run it for some reason.
	var/async = 0   	// If the check can be left to do it's own thing, you must define a check_result() proc if you use this.
	var/reported = 0

datum/unit_test/proc/fail(var/message)
	all_unit_tests_passed = 0
	failed_unit_tests++
	reported = 1
	log_unit_test("*** FAILURE *** \[[name]\]: [message]")

datum/unit_test/proc/pass(var/message)
	reported = 1
	log_unit_test("*** SUCCESS *** \[[name]\]: [message]")

datum/unit_test/proc/start_test()
	fail("No test proc.")

datum/unit_test/proc/check_result()
	fail("No check results")
	return 1
	
proc/initialize_unit_tests()
	log_unit_test("Initializing Unit Testing")	
	
	//
	//Start the Round.
	//

	world.save_mode("extended")

	sleep(1)

	if(!ticker)
		crash_with("No Ticker")
		world.Del()

	if(ticker.current_state == GAME_STATE_PREGAME)
		ticker.current_state = GAME_STATE_SETTING_UP
	else
		crash_with("Game wasn't in pregame.")
		world.Del()


	log_unit_test("Waiting 10 seconds or more for roundstart functions to finish")	
	sleep(100)

	//
	// Run Tests
	//

	var/list/test_datums = typesof(/datum/unit_test) - /datum/unit_test


	//var/testnum = 1
	var/list/async_test = list()
	var/list/started_tests = list()

	for (var/test in test_datums)
		var/datum/unit_test/d = new test()
		//log_unit_test("Now starting \[[d.name]\] [testnum++] of [test_datums.len]")

		if(isnull(d.start_test()))		// Start the test.
			d.fail("Test Runtimed")
		if(d.async)				// If it's async then we'll need to check back on it later.
			async_test.Add(d)
		total_unit_tests++
		


	//
	// Check the async tests to see if they are finished.
	// 

	while(async_test.len)
		for(var/datum/unit_test/test  in async_test)
			if(test.check_result())
				async_test.Remove(test)
		sleep(1)

	//
	// Make sure all Unit Tests reported a result
	//

	for(var/datum/unit_test/test in started_tests)
		if(!test.reported)
			test.fail("Test failed to report a result.")

	
	
	if(all_unit_tests_passed)
		log_unit_test("**** All Unit Tests Passed \[[total_unit_tests]\] ****")
		world.Del()
	else
		log_unit_test("**** \[[failed_unit_tests]\\[total_unit_tests]\] Unit Tests Failed ****")
		world.Del()
