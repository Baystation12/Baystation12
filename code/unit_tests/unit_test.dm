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

var/global/all_unit_tests_passed = 1
var/global/failed_unit_tests = 0
var/global/skipped_unit_tests = 0
var/global/total_unit_tests = 0

// For console out put in Linux/Bash makes the output green or red.
// Should probably only be used for unit tests since some special folks use winders to host servers.
// if you want plain output, use dm.sh -DUNIT_TEST -DUNIT_TEST_PLAIN baystation12.dme
#ifdef UNIT_TEST_PLAIN
var/global/ascii_esc = ""
var/global/ascii_red = ""
var/global/ascii_green = ""
var/global/ascii_yellow = ""
var/global/ascii_reset = ""
#else
var/global/ascii_esc = ascii2text(27)
var/global/ascii_red = "[ascii_esc]\[31m"
var/global/ascii_green = "[ascii_esc]\[32m"
var/global/ascii_yellow = "[ascii_esc]\[33m"
var/global/ascii_reset = "[ascii_esc]\[0m"
#endif


// We list these here so we can remove them from the for loop running this.
// Templates aren't intended to be ran but just serve as a way to create child objects of it with inheritable tests for quick test creation.

/datum/unit_test
	var/name = "template - should not be ran."
	var/template        // Treat the unit test as a template if its type is the same as the value of this var
	var/disabled = 0    // If we want to keep a unit test in the codebase but not run it for some reason.
	var/async = 0       // If the check can be left to do it's own thing, you must define a check_result() proc if you use this.
	var/reported = 0	// If it's reported a success or failure.  Any tests that have not are assumed to be failures.
	var/why_disabled = "No reason set."   // If we disable a unit test we will display why so it reminds us to check back on it later.

	var/safe_landmark
	var/space_landmark

/datum/unit_test/proc/log_debug(var/message)
	log_unit_test("[ascii_yellow]---  DEBUG  --- \[[name]\]: [message][ascii_reset]")

/datum/unit_test/proc/log_bad(var/message)
	log_unit_test("[ascii_red]\[[name]\]: [message][ascii_reset]")

/datum/unit_test/proc/fail(var/message)
	all_unit_tests_passed = 0
	failed_unit_tests++
	reported = 1
	log_unit_test("[ascii_red]!!! FAILURE !!! \[[name]\]: [message][ascii_reset]")

/datum/unit_test/proc/pass(var/message)
	reported = 1
	log_unit_test("[ascii_green]*** SUCCESS *** \[[name]\]: [message][ascii_reset]")

/datum/unit_test/proc/skip(var/message)
	skipped_unit_tests++
	reported = 1
	log_unit_test("[ascii_yellow]--- SKIPPED --- \[[name]\]: [message][ascii_reset]")

/datum/unit_test/proc/start_test()
	fail("No test proc - [type]")

/datum/unit_test/proc/check_result()
	fail("No check results proc - [type]")
	return 1

/datum/unit_test/proc/get_safe_turf()
	if(!safe_landmark)
		for(var/landmark in landmarks_list)
			if(istype(landmark, /obj/effect/landmark/test/safe_turf))
				safe_landmark = landmark
				break
	return get_turf(safe_landmark)

/datum/unit_test/proc/get_space_turf()
	if(!space_landmark)
		for(var/landmark in landmarks_list)
			if(istype(landmark, /obj/effect/landmark/test/space_turf))
				space_landmark = landmark
				break
	return get_turf(space_landmark)

// Async unit tests will be delayed until the subsystems in this list have fired at least once.
/datum/unit_test/proc/subsystems_to_await()
	return list()

/proc/load_unit_test_changes()
/*
	//This takes about 60 seconds to run when unit testing and is only used for the ZAS vacume check on The Asteroid.
	if(config.generate_map != 1)
		log_unit_test("Overiding Configuration option for Asteroid Generation to ENABLED")
		config.generate_map = 1	// The default map requires it, the example config doesn't have this enabled.
 */

/proc/get_test_datums()
	. = list()
	for(var/test in subtypesof(/datum/unit_test))
		var/datum/unit_test/d = test
		if(test == initial(d.template))
			continue
		. += d

/proc/do_unit_test(datum/unit_test/test, end_time, skip_disabled_tests = TRUE)
	if(test.disabled && skip_disabled_tests)
		test.pass("[ascii_red]Check Disabled: [test.why_disabled]")
		return
	if(world.time > end_time)
		test.fail("Unit Tests Ran out of time")   // This should never happen, and if it does either fix your unit tests to be faster or if you can make them async checks.
		return
	if (test.start_test() == null)	// Runtimed.
		test.fail("Test Runtimed")
	return 1

//For async tests. Returns 1 if done.
/proc/check_unit_test(datum/unit_test/test, end_time)
	if(world.time > end_time)
		test.fail("Unit Tests Ran out of Time")// If we're going to run out of time, most likely it's here.  If you can't speed up your unit tests then add time to the timeout at the top.
		return 1
	var/result = test.check_result()
	if(isnull(result))
		test.fail("Test Runtimed")
		return 1
	else if(result)
		return 1

/proc/unit_test_final_message()
	var/skipped_message = ""
	if(skipped_unit_tests)
		skipped_message = "| \[[skipped_unit_tests]\\[total_unit_tests]\] Unit Tests Skipped "
	if(all_unit_tests_passed)
		log_unit_test("[ascii_green]**** All Unit Tests Passed \[[total_unit_tests]\] [skipped_message]****[ascii_reset]")
	else
		log_unit_test("[ascii_red]**** \[[failed_unit_tests]\\[total_unit_tests]\] Unit Tests Failed [skipped_message]****[ascii_reset]")

/datum/admins/proc/run_unit_test(var/datum/unit_test/unit_test_type in get_test_datums())
	set name = "Run Unit Test"
	set desc = "Runs the selected unit test - Remember to enable Debug Log Messages"
	set category = "Debug"

	if(!unit_test_type)
		return

	if(!check_rights(R_DEBUG))
		return

	log_and_message_admins("has started the unit test '[initial(unit_test_type.name)]'")
	var/datum/unit_test/test = new unit_test_type
	var/end_unit_tests = world.time + MAX_UNIT_TEST_RUN_TIME
	do_unit_test(test, end_unit_tests, FALSE)
	if(test.async)
		while(!check_unit_test(test, end_unit_tests))
			sleep(20)
	unit_test_final_message()

/obj/effect/landmark/test/safe_turf
	name = "safe_turf" // At creation, landmark tags are set to: "landmark*[name]"
	desc = "A safe turf should be an as large block as possible of livable, passable turfs, preferably at least 3x3 with the marked turf as the center."

/obj/effect/landmark/test/space_turf
	name = "space_turf"
	desc = "A space turf should be an as large block as possible of space, preferably at least 3x3 with the marked turf as the center."
