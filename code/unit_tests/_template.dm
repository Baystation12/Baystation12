/*
 *
 *  Unit Test Template
 *  This file is not used.
 *
 */

/datum/unit_test/template
	name = "Test Template - Change My name"
	template = /datum/unit_test/template    // Set this var equal to the test path to treat it as a template, i.e. it should not be run
	async = 1                               // Set if we should continue testing elsewhere and come back and check on the results.


/datum/unit_test/template/start_test()
	// This must return something, if it's null the unit_test runner will think we runtimed.
	// If your test requires any kind of delay use async so we can finish tests faster.
	// Be sure and have a pass/fail procs in here if it's not using async.

	if(0)
		fail("Zero is somehow True, that sucks")
	else
		pass("Zero is false, yay")


	return 1

/datum/unit_test/template/check_result()
	// Only Ran if async is set.  Use this proc for checking back if the test passed or not.
	// Return 0 if we need to come back again and check this.
	// Return 1 if the test is complete.

	//

	pass("Winner is you")

	return 1

// ============================================================================
