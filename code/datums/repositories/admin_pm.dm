var/repository/admin_pm/admin_pm_repository = new()

/repository/admin_pm
	var/list/admin_pms_

/repository/admin_pm/New()
	..()
	admin_pms_ = list()

/repository/admin_pm/proc/store_pm(var/client/sender, var/client/receiver, var/message)
	// Newest messages first
	admin_pms_.Insert(1, new/datum/admin_privat_message(sender, receiver, message))

/datum/admin_privat_message
	var/station_time
	var/datum/client_lite/sender // We don't store the proper client because it gets deleted if banned
	var/datum/client_lite/receiver
	var/message

/datum/admin_privat_message/New(var/client/sender, var/client/receiver, var/message)
	station_time = time_stamp()
	src.message = message
	src.sender = client_repository.get_lite_client(sender)
	if(receiver)
		src.receiver = client_repository.get_lite_client(receiver)
