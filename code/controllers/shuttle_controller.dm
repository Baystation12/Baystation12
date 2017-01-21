
var/global/datum/shuttle_controller/shuttle_controller


/datum/shuttle_controller
	var/list/shuttles	//maps shuttle tags to shuttle datums, so that they can be looked up.
	var/list/process_shuttles	//simple list of shuttles, for processing

/datum/shuttle_controller/proc/process()
	//process ferry shuttles
	for (var/datum/shuttle/autodock/shuttle in process_shuttles)
		if (shuttle.process_state)
			shuttle.process()

//This is called by gameticker after all the machines and radio frequencies have been properly initialized
/datum/shuttle_controller/proc/initialize_shuttles()
	waypoint_repository.initialize_waypoints()

	for(var/shuttle_type in subtypesof(/datum/shuttle))
		var/datum/shuttle/shuttle = shuttle_type
		if(initial(shuttle.category) == shuttle_type)
			continue
		shuttle = new shuttle()

/datum/shuttle_controller/New()
	shuttles = list()
	process_shuttles = list()
