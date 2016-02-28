/*   Unit Tests originally designed by Ccomp5950
 *
 *   Tests are created to prevent changes that would create bugs or change expected behaviour.
 *   For the most part I think any test can be created that doesn't require a client in a mob or require a game mode other then extended
 *
 *   The easiest way to make effective tests is to create a "template" if you intend to run the same test over and over and make your actual
 *   tests be a "child object" of those templates.  Be sure and name your templates with the word "template" somewhere in var/name.
 *
 *   The goal is to have all sorts of tests that run and to run them as quickly as possible.
 *
 *   Tests that require time to run we instead just check back on their results later instead of waiting around in a sleep(1) for each test.
 *   This allows us to finish unit testing quicker since we can start other tests while we're waiting on that one to finish.
 *
 *   An example of that is listed in mob_tests.dm with the human_breath test.  We spawn the mob in space and set the async flag to 1 so that we run the check later.
 *   After 10 life ticks for that mob we check it's oxyloss but while that is going on we've already ran other tests.
 *
 *   If your test requires a significant amount of time...cheat on the timers.  Either speed up the process/life runs or do as we did in the timers for the shuttle
 *   transfers in zas_tests.dm   we move a shuttle but instead of waiting 3 minutes we set the travel time to a very low number.
 *
 *   At the same time, Unit tests are intended to reflect standard usage so avoid changing to much about how stuff is processed.
 *
 *
 *   WRITE UNIT TEST TEMPLATES AS GENERIC AS POSSIBLE (makes for easy reusability)
 *
 */


var/all_unit_tests_passed = 1
var/failed_unit_tests = 0
var/total_unit_tests = 0
var/currently_running_tests = 0

// For console out put in Linux/Bash makes the output green or red.
// Should probably only be used for unit tests/Travis since some special folks use winders to host servers.
var/ascii_esc = ascii2text(27)
var/ascii_red = "[ascii_esc]\[31m"
var/ascii_green = "[ascii_esc]\[32m"
var/ascii_reset = "[ascii_esc]\[0m"


// We list these here so we can remove them from the for loop running this.
// Templates aren't intended to be ran but just serve as a way to create child objects of it with inheritable tests for quick test creation.

datum/unit_test
	var/name = "template - should not be ran."
	var/disabled = 0        // If we want to keep a unit test in the codebase but not run it for some reason.
	var/async = 0           // If the check can be left to do it's own thing, you must define a check_result() proc if you use this.
	var/reported = 0	// If it's reported a success or failure.  Any tests that have not are assumed to be failures.
	var/why_disabled = "No reason set."   // If we disable a unit test we will display why so it reminds us to check back on it later.


datum/unit_test/proc/fail(var/message)
	all_unit_tests_passed = 0
	failed_unit_tests++
	reported = 1
	log_unit_test("[ascii_red]!!! FAILURE !!! \[[name]\]: [message][ascii_reset]")

datum/unit_test/proc/pass(var/message)
	reported = 1
	log_unit_test("[ascii_green]*** SUCCESS *** \[[name]\]: [message][ascii_reset]")

datum/unit_test/proc/start_test()
	fail("No test proc.")

datum/unit_test/proc/check_result()
	fail("No check results proc")
	return 1


proc/load_unit_test_changes()
/*
	//This takes about 60 seconds to run on Travis and is only used for the ZAS vacume check on The Asteroid.
	if(config.generate_asteroid != 1)
		log_unit_test("Overiding Configuration option for Asteroid Generation to ENABLED")
		config.generate_asteroid = 1	// The default map requires it, the example config doesn't have this enabled.
 */




proc/initialize_unit_tests()
	log_unit_test("Initializing Unit Testing")

	//
	//Start the Round.
	//

	if(!ticker)
		crash_with("No Ticker")
		del(world)

	var/said_msg = 0
	while(ticker.pregame_timeleft && ticker.pregame_timeleft > 160) 	// Make sure the initial startup is complete.
		if(ticker.pregame_timeleft < 175 && !said_msg)
			said_msg = 1
			log_unit_test("Pregame Count down has started, giving it 20 seconds to finish.")
		sleep(1)

	world.save_mode("extended")

	sleep(1)

	ticker.current_state = GAME_STATE_SETTING_UP

	log_unit_test("Round has been started.  Waiting 10 seconds to start tests.")
	sleep(100)

	//
	// Run Tests
	//

	var/list/test_datums = get_test_datums()
	run_unit_tests(test_datums)
	del(world)

/proc/run_unit_tests(var/list/test_datums, var/skip_disabled_tests = TRUE)
	if(currently_running_tests)
		log_unit_test("Already running unit tests")
		return
	currently_running_tests = 1

	all_unit_tests_passed = 1
	failed_unit_tests = 0
	total_unit_tests = 0

	var/list/async_test = list()
	var/list/started_tests = list()

	log_unit_test("Testing Started.")

	for (var/test in test_datums)
		var/datum/unit_test/d = new test()

		if(d.disabled && skip_disabled_tests)
			d.pass("[ascii_red]Check Disabled: [d.why_disabled]")
			continue

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
		log_unit_test("[ascii_green]**** All Unit Tests Passed \[[total_unit_tests]\] ****[ascii_reset]")
	else
		log_unit_test("[ascii_red]**** \[[failed_unit_tests]\\[total_unit_tests]\] Unit Tests Failed ****[ascii_reset]")
	currently_running_tests = 0

/proc/get_test_datums()
	var/list/tests = list()
	for(var/test in typesof(/datum/unit_test))
		var/datum/unit_test/d = test
		if(!findtext(initial(d.name), "template"))
			tests += d
	return tests

/datum/admins/proc/run_unit_test(var/datum/unit_test/unit_test_type in get_test_datums())
	set name = "Run Unit Test"
	set desc = "Runs the selected unit test - Remember to enable Debug Log Messages"
	set category = "Debug"

	if(!unit_test_type)
		return

	if(!check_rights(R_DEBUG))
		return

	log_and_message_admins("has started the unit test '[initial(unit_test_type.name)]'")
	run_unit_tests(list(unit_test_type), FALSE)
