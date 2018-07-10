SUBSYSTEM_DEF(shuttle)
	name = "Shuttle"
	wait = 2 SECONDS
	priority = SS_PRIORITY_SHUTTLE
	init_order = SS_INIT_SHUTTLE                 //Should be initialized after all maploading is over and atoms are initialized, to ensure that landmarks have been initialized.

	var/list/shuttles = list()                   //maps shuttle tags to shuttle datums, so that they can be looked up.
	var/list/process_shuttles = list()           //simple list of shuttles, for processing
	var/list/registered_shuttle_landmarks = list()
	var/last_landmark_registration_time
	var/list/shuttle_logs = list()               //Keeps records of shuttle movement, format is list(datum/shuttle = datum/shuttle_log)

	var/list/landmarks_awaiting_sector = list()  //Stores automatic landmarks that are waiting for a sector to finish loading.
	var/list/landmarks_still_needed = list()     //Stores landmark_tags that need to be assigned to the sector (landmark_tag = sector) when registered.
	var/list/shuttles_to_initialize              //A queue for shuttles that were asked to initialize too early.

	var/tmp/list/working_shuttles

/datum/controller/subsystem/shuttle/Initialize()
	last_landmark_registration_time = world.time
	initialize_shuttles()
	. = ..()

/datum/controller/subsystem/shuttle/fire(resumed = FALSE)
	if (!resumed)
		working_shuttles = process_shuttles.Copy()

	while (working_shuttles.len)
		var/datum/shuttle/shuttle = working_shuttles[working_shuttles.len]
		working_shuttles.len--
		if(shuttle.process_state && (shuttle.Process(wait, times_fired, src) == PROCESS_KILL))
			process_shuttles -= shuttle

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/shuttle/proc/register_landmark(shuttle_landmark_tag, obj/effect/shuttle_landmark/shuttle_landmark)
	if (registered_shuttle_landmarks[shuttle_landmark_tag])
		CRASH("Attempted to register shuttle landmark with tag [shuttle_landmark_tag], but it is already registered!")
	if (istype(shuttle_landmark))
		registered_shuttle_landmarks[shuttle_landmark_tag] = shuttle_landmark
		last_landmark_registration_time = world.time

		var/obj/effect/overmap/O = landmarks_still_needed[shuttle_landmark_tag]
		if(O) //These need to be added to sectors, which we handle.
			try_add_landmark_tag(shuttle_landmark_tag, O)
			landmarks_still_needed -= shuttle_landmark_tag
		else if(istype(shuttle_landmark, /obj/effect/shuttle_landmark/automatic)) //These find their sector automatically
			var/obj/effect/shuttle_landmark/automatic/automatic = shuttle_landmark
			O = map_sectors["[automatic.z]"]
			O ? O.add_landmark(automatic, automatic.shuttle_restricted) : (landmarks_awaiting_sector += shuttle_landmark)

/datum/controller/subsystem/shuttle/proc/get_landmark(var/shuttle_landmark_tag)
	return registered_shuttle_landmarks[shuttle_landmark_tag]

//Checks if the given sector's landmarks have initialized; if so, registers them with the sector, if not, marks them for assignment after they come in.
//Also adds automatic landmarks that were waiting on their sector to spawn.
/datum/controller/subsystem/shuttle/proc/initialize_sector(obj/effect/overmap/given_sector)
	for(var/landmark_tag in given_sector.initial_generic_waypoints)
		if(!try_add_landmark_tag(landmark_tag, given_sector))
			landmarks_still_needed[landmark_tag] = given_sector
	
	for(var/shuttle_name in given_sector.initial_restricted_waypoints)
		for(var/landmark_tag in given_sector.initial_restricted_waypoints[shuttle_name])
			if(!try_add_landmark_tag(landmark_tag, given_sector))
				landmarks_still_needed[landmark_tag] = given_sector

	var/landmarks_to_check = landmarks_awaiting_sector.Copy()
	for(var/thing in landmarks_to_check)
		var/obj/effect/shuttle_landmark/automatic/landmark = thing
		if(landmark.z in given_sector.map_z)
			given_sector.add_landmark(landmark, landmark.shuttle_restricted)
			landmarks_awaiting_sector -= landmark

/datum/controller/subsystem/shuttle/proc/try_add_landmark_tag(landmark_tag, obj/effect/overmap/given_sector)
	var/obj/effect/shuttle_landmark/landmark = get_landmark(landmark_tag)
	if(!landmark)
		return

	if(landmark.landmark_tag in given_sector.initial_generic_waypoints)
		given_sector.add_landmark(landmark)
		. = 1
	for(var/shuttle_name in given_sector.initial_restricted_waypoints)
		if(landmark.landmark_tag in given_sector.initial_restricted_waypoints[shuttle_name])
			given_sector.add_landmark(landmark, shuttle_name)
			. = 1

//This is called by gameticker after all the machines and radio frequencies have been properly initialized
/datum/controller/subsystem/shuttle/proc/initialize_shuttles()
	for(var/shuttle_type in subtypesof(/datum/shuttle))
		var/datum/shuttle/shuttle = shuttle_type
		if((shuttle in shuttles_to_initialize) || !initial(shuttle.defer_initialisation))
			initialise_shuttle(shuttle_type, TRUE)
	shuttles_to_initialize = null

/datum/controller/subsystem/shuttle/proc/initialise_shuttle(var/shuttle_type, during_init = FALSE)
	if(!initialized && !during_init)
		LAZYADD(shuttles_to_initialize, shuttle_type)
		return //We'll get back to it during init.
	var/datum/shuttle/shuttle = shuttle_type
	if(initial(shuttle.category) != shuttle_type)
		shuttle = new shuttle()

/datum/controller/subsystem/shuttle/stat_entry()
	..("S:[shuttles.len], L:[registered_shuttle_landmarks.len], Landmarks w/o Sector:[landmarks_awaiting_sector.len], Missing Landmarks:[landmarks_still_needed.len]")