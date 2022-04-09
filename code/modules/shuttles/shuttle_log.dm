//Store information about shuttle missions. Used by deck management program.

/datum/shuttle_log
	var/shuttle_name                                  //The shuttle for which this is the log.
	var/list/datum/shuttle_mission/missions = list()  //The actual log entries. This includes all past missions and the current one if started.
	var/list/datum/shuttle_mission/queued_missions = list() //Missions which are queued up, in order ([1] is the next one scheduled).
	var/datum/shuttle_mission/current_mission         //The current mission, planned or ongoing. Will also be in either missions or queued_missions, depending on stage.
	var/home_base                                     //The landmark tag from which missions originate.
	var/list/datum/nano_module/registered = list()    //Nanomodules using logs should register to receive updates.
	var/last_spam = 0                                 //Helps with spam control from deck software.

/datum/shuttle_log/New(datum/shuttle/given_shuttle)
	..()
	if(given_shuttle.logging_home_tag)
		shuttle_name = given_shuttle.name
		home_base = given_shuttle.logging_home_tag
		SSshuttle.shuttle_logs[given_shuttle] = src

/datum/shuttle_log/Destroy()
	update_registred()
	registered = null
	current_mission = null
	QDEL_NULL_LIST(missions)
	QDEL_NULL_LIST(queued_missions)
	. = ..()

/datum/shuttle_log/proc/register(datum/nano_module/module)
	registered += module

/datum/shuttle_log/proc/unregister(datum/nano_module/module)
	registered -= module	

/datum/shuttle_log/proc/update_registred()
	for(var/datum/nano_module/module in registered)
		SSnano.update_uis(module)

/datum/shuttle_log/proc/submit_report(datum/shuttle_mission/mission, datum/computer_file/report/report, mob/user)
	if(!report.submit(user))
		return 0
	if(istype(report, /datum/computer_file/report/flight_plan))
		if(mission.flight_plan)
			qdel(mission.flight_plan)
		mission.flight_plan = report
	if(istype(report, /datum/computer_file/report/recipient/shuttle))
		var/datum/computer_file/report/recipient/shuttle/new_report = report
		var/old_report = locate(report.type) in mission.other_reports
		if(old_report)
			mission.other_reports -= old_report
			qdel(old_report)
		new_report.mission.set_value(mission.name)
		mission.other_reports += report
	update_registred()
	return 1

/datum/shuttle_log/proc/process_queue()
	if(current_mission) //Process queue changes due to stage changes.
		switch(current_mission.stage)
			if(SHUTTLE_MISSION_FINISHED)
				current_mission = null
			if(SHUTTLE_MISSION_STARTED)
				if(current_mission in queued_missions)
					queued_missions -= current_mission
					missions += current_mission
	if(!current_mission && length(queued_missions))
		current_mission = queued_missions[1]
		current_mission.stage = SHUTTLE_MISSION_PLANNED
	update_registred()

/datum/shuttle_log/proc/create_mission(name)
	var/datum/shuttle_mission/mission = new()
	if(name)
		mission.name = name
	else
		mission.name = "[shuttle_name]: Mission [length(missions)+1]"
	mission.ID = sequential_id(type)
	mission.shuttle_name = shuttle_name
	queued_missions += mission
	process_queue()
	return mission

/datum/shuttle_log/proc/rename_mission(datum/shuttle_mission/mission, name)
	if(!(mission in (missions + queued_missions)))
		return
	if(name)
		mission.name = name
		for(var/datum/computer_file/report/recipient/shuttle/report in mission.other_reports)
			report.mission.set_value(name)
		update_registred()

//Only missions that haven't started can be deleted; returns 0 on failure.
/datum/shuttle_log/proc/delete_mission(datum/shuttle_mission/mission)
	if(!(mission in queued_missions))
		return 0
	queued_missions -= mission
	if(current_mission == mission)
		current_mission = null
	qdel(mission)
	process_queue()
	return 1

//Tries to move the mission in the queue, relative position = 1 means one ahead in the queue, -1 one back.
/datum/shuttle_log/proc/move_in_queue(datum/shuttle_mission/mission, relative_position)
	if(!(mission in queued_missions))
		return
	if(current_mission in queued_missions)
		current_mission.stage = SHUTTLE_MISSION_QUEUED
		current_mission = null //We'll reset this at the end.
	var/index = list_find(queued_missions, mission)
	var/new_index = clamp(index - relative_position, 1, length(queued_missions))
	queued_missions -= mission
	queued_missions.Insert(new_index, mission)
	process_queue()

/datum/shuttle_log/proc/mission_from_ID(given_id)
	for(var/datum/shuttle_mission/mission in (missions + queued_missions))
		if(given_id == mission.ID)
			return mission

/datum/shuttle_log/proc/handle_move(obj/effect/shuttle_landmark/origin, obj/effect/shuttle_landmark/destination)
	var/obj/effect/shuttle_landmark/home = SSshuttle.get_landmark(home_base)
	if(origin == home)
		shuttle_launched()
	if(destination == home)
		shuttle_returned()

/datum/shuttle_log/proc/shuttle_launched()
	if(!current_mission || (current_mission.stage != SHUTTLE_MISSION_PLANNED))
		create_mission()
	current_mission.stage = SHUTTLE_MISSION_STARTED
	current_mission.depart_time = stationtime2text()
	process_queue()

/datum/shuttle_log/proc/shuttle_returned()
	if(!current_mission || (current_mission.stage != SHUTTLE_MISSION_STARTED))
		current_mission = null
		CRASH("Shuttle returned, but mission stage was incorrect or no mission was logged.")
	current_mission.stage = SHUTTLE_MISSION_FINISHED
	current_mission.return_time = stationtime2text()
	process_queue()

/datum/shuttle_mission
	var/shuttle_name
	var/name                                          //Name assigned to the mission; visible to players.
	var/ID                                            //Autogenerated ID; don't change this manually.
	var/stage = SHUTTLE_MISSION_QUEUED                //The stage the mission is in.
	var/depart_time                                   //The station time the shuttle left (null if hasn't left).
	var/return_time                                   //The station time the shuttle came back.
	var/datum/computer_file/report/flight_plan/flight_plan
	var/list/other_reports = list()

/datum/shuttle_mission/Destroy()
	QDEL_NULL(flight_plan)
	QDEL_NULL_LIST(other_reports)
	. = ..()