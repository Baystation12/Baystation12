var/all_unit_tests_passed = 1
var/failed_unit_tests = 0
var/total_unit_tests = 0

datum/unit_test
	var/name = "Fix Me"
	var/success = 0 // Not currently used.
	var/async = 0   // If the check can be left to do it's own thing, you must define a check_result() proc if you use this.

datum/unit_test/proc/fail(var/message)
	all_unit_tests_passed = 0
	log_unit_test(" *** FAILURE *** \[[name]\]: [message]")

datum/unit_test/proc/pass(var/message)
	success = 1
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
		CRASH("No Ticker")
	if(ticker.current_state == GAME_STATE_PREGAME)
		ticker.current_state = GAME_STATE_SETTING_UP
	else
		CRASH("Game wasn't in pregame.")

	//
	// Run Tests
	//

	var/list/test_datums = typesof(/datum/unit_test) - /datum/unit_test

	var/testnum = 1
	var/list/test_running = list()

	for (var/test in test_datums)
		var/datum/unit_test/d = new test()
		log_unit_test("Now starting [d.name] [testnum++] of [test_datums.len]")
		d.start_test()
		if(d.async)
			test_running.Add(d)
		total_unit_tests++

	while(test_running.len)
		for(var/datum/unit_test/test  in test_running)
			if(test.check_result())
				test_running.Remove(test)
		sleep(1)

	
	if(all_unit_tests_passed)
		log_unit_test("**** All Unit Tests Passed ****")
		world.Del()
	else
		log_unit_test("**** \[[failed_unit_tests]\\[total_unit_tests]\] Unit Tests Failed ****")
		world.Del()
