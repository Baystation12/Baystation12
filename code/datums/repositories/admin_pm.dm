var/global/datum/repository/admin_pm/admin_pm_repository = new()

/datum/repository/admin_pm
	var/list/admin_pms_
	var/list/irc_clients_by_name

/datum/repository/admin_pm/New()
	..()
	admin_pms_ = list()
	irc_clients_by_name = list()

/datum/repository/admin_pm/proc/store_pm(client/sender, client/receiver, message)
	if(receiver)
		if(istype(receiver))
			receiver = client_repository.get_lite_client(receiver)
		else if(text_starts_with(receiver, "IRC-"))
			receiver = get_irc_client(receiver)
		else
			CRASH("Invalid receiver: [log_info_line(receiver)]")

	// Newest messages first
	admin_pms_.Insert(1, new/datum/admin_privat_message(client_repository.get_lite_client(sender), receiver, message))

/datum/repository/admin_pm/proc/get_irc_client(key)
	var/datum/client_lite/cl = irc_clients_by_name[key]
	if(!cl)
		cl = new/datum/client_lite()
		cl.name = "IRC"
		cl.key = key
		irc_clients_by_name[key] = cl
	return cl

/datum/admin_privat_message
	var/station_time
	var/datum/client_lite/sender // We don't store the proper client because it gets deleted if banned
	var/datum/client_lite/receiver
	var/message

/datum/admin_privat_message/New(sender, receiver, message)
	station_time = time_stamp()
	src.message = message
	src.sender = sender
	src.receiver = receiver
