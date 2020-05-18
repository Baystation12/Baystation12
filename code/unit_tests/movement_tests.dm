/datum/unit_test/movement
	name = "MOVEMENT template"
	template = /datum/unit_test/movement
	async = 0

/datum/unit_test/movement/force_move_shall_trigger_crossed_when_entering_turf
	name = "MOVEMENT - Force Move Shall Trigger Crossed When Entering Turf"

/datum/unit_test/movement/force_move_shall_trigger_crossed_when_entering_turf/start_test()
	var/turf/start = get_safe_turf()
	var/turf/target = get_step(start, NORTH)

	var/obj/mover = new /obj/test(start, 1)
	var/obj/test/crossed_obj/crossed = new(target, 1)

	mover.forceMove(target)

	if(!crossed.crossers)
		fail("The target object was never crossed.")
	else if(crossed.crossers.len != 1)
		fail("The target object was crossed [crossed.crossers.len] times, expected 1.")
	else
		pass("The target was crossed 1 time.")

	qdel(mover)
	qdel(crossed)
	return TRUE

/datum/unit_test/movement/force_move_shall_trigger_entered
	name = "MOVEMENT - Force Move Shall Trigger Entered"

/datum/unit_test/movement/force_move_shall_trigger_entered/start_test()
	var/turf/start = get_safe_turf()
	var/obj/mover = new /obj/test(start, 1)
	var/obj/test/entered_obj/target = new(start, 1)

	mover.forceMove(target)

	if(!target.enterers)
		fail("The target object was never entered.")
	else if(target.enterers.len != 1)
		fail("The target object was entered [target.enterers.len] times, expected 1.")
	else
		pass("The target was entered 1 time.")

	qdel(mover)
	qdel(target)
	return TRUE

/obj/test/crossed_obj
	var/list/crossers

/obj/test/crossed_obj/Crossed(var/crosser)
	if(!crossers)
		crossers = list()
	crossers += crosser

/obj/test/entered_obj
	var/list/enterers

/obj/test/entered_obj/Entered(var/enterer)
	if(!enterers)
		enterers = list()
	enterers += enterer
