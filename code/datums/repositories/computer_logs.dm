var/global/repository/computer_logs/computer_log_repository = new()

/repository/computer_logs
	var/list/computer_logs_

/repository/computer_logs/New()
	..()
	computer_logs_ = list()

/repository/computer_logs/proc/store_computer_log(mob/user, turf/location, command)
	// Newest logs first
	computer_logs_.Insert(1, new/datum/computer_log(user, location, command))

/datum/computer_log
	var/station_time
	var/datum/mob_lite/user
	var/turf/location
	var/command

/datum/computer_log/New(mob/user, location, command)
	station_time = time_stamp()
	src.user = mob_repository.get_lite_mob(user)
	src.location = location
	src.command = command

	location = get_turf(user)
