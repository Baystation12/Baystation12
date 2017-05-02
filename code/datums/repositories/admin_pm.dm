var/repository/admin_pm/admin_pm_repository = new()

/repository/admin_pm
	var/list/admin_pms_
	var/list/irc_clients_by_name

/repository/admin_pm/New()
	..()
	admin_pms_ = list()
	irc_clients_by_name = list()

/repository/admin_pm/proc/store_pm(var/client/sender, var/client/receiver, var/message)
	if(receiver)
		if(istype(receiver))
			receiver = client_repository.get_lite_client(receiver)
		else if(starts_with(receiver, "IRC-"))
			receiver = get_irc_client(receiver)
		else
			CRASH("Invalid receiver: [log_info_line(receiver)]")

	// Newest messages first
	admin_pms_.Insert(1, new/datum/admin_privat_message(client_repository.get_lite_client(sender), receiver, message))

/repository/admin_pm/proc/get_irc_client(key)
	var/datum/client_lite/cl = irc_clients_by_name[key]
	if(!cl)
		cl = new/datum/client_lite()
		cl.mob_name = "IRC"
		cl.key = key
		irc_clients_by_name[key] = cl
	return cl

/datum/admin_privat_message
	var/station_time
	var/datum/client_lite/sender // We don't store the proper client because it gets deleted if banned
	var/datum/client_lite/receiver
	var/message

/datum/admin_privat_message/New(var/sender, var/receiver, var/message)
	station_time = time_stamp()
	src.message = message
	src.sender = sender
	src.receiver = receiver

