
var/global/datum/shuttle_controller/shuttle_controller


/datum/shuttle_controller
	var/list/shuttles	//maps shuttle tags to shuttle datums, so that they can be looked up.
	var/list/process_shuttles	//simple list of shuttles, for processing
	var/list/registered_shuttle_landmarks
	var/last_landmark_registration_time

/datum/shuttle_controller/New()
	shuttles = list()
	process_shuttles = list()
	registered_shuttle_landmarks = list()
	last_landmark_registration_time = world.time

/datum/shuttle_controller/proc/register_landmark(var/shuttle_landmark_tag, var/obj/effect/shuttle_landmark/shuttle_landmark)
	if (registered_shuttle_landmarks[shuttle_landmark_tag])
		CRASH("Attempted to register shuttle landmark with tag [shuttle_landmark_tag], but it is already registered!")
	if (istype(shuttle_landmark))
		registered_shuttle_landmarks[shuttle_landmark_tag] = shuttle_landmark
		last_landmark_registration_time = world.time

/datum/shuttle_controller/proc/get_landmark(var/shuttle_landmark_tag)
	return registered_shuttle_landmarks[shuttle_landmark_tag]

/datum/shuttle_controller/proc/process()
	//process ferry shuttles
	for (var/datum/shuttle/autodock/shuttle in process_shuttles)
		if (shuttle.process_state)
			shuttle.process()

//This is called by gameticker after all the machines and radio frequencies have been properly initialized
/datum/shuttle_controller/proc/initialize_shuttles()
	for(var/shuttle_type in subtypesof(/datum/shuttle))
		var/datum/shuttle/shuttle = shuttle_type
		if (!initial(shuttle.defer_initialisation))
			initialise_shuttle(shuttle_type)

/datum/shuttle_controller/proc/initialise_shuttle(var/shuttle_type)
	var/datum/shuttle/shuttle = shuttle_type
	if(initial(shuttle.category) != shuttle_type)
		shuttle = new shuttle()
