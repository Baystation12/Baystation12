/*
* Unit tests for built-in BYOND procs, to ensure overrides have not affected functionality.
*/
datum/unit_test/foundation
	name = "FOUNDATION template"
	async = 0

datum/unit_test/foundation/step_shall_return_true_on_success
	name = "FOUNDATION: step() shall return true on success"

datum/unit_test/foundation/step_shall_return_true_on_success/start_test()
	var/mob_step_result = TestStep(/mob)
	var/obj_step_result = TestStep(/obj)

	if(mob_step_result && obj_step_result)
		pass("step() returned true.")
	else
		fail("step() did not return true: Mob result: [mob_step_result] - Obj result: [obj_step_result].")

	return 1

datum/unit_test/foundation/proc/TestStep(type_to_test)
	var/turf/start = get_safe_turf()
	var/atom/movable/T = new type_to_test(start)

	. = step(T, NORTH)
	. = . && start.x == T.x
	. = . && start.y + 1 == T.y
	. = . && start.z == T.z
