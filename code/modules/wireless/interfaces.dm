/datum/wifi
	var/list/connected_devices

/datum/wifi/New()
	connected_devices = new()

/datum/wifi/Destroy(var/wifi/device)
	..()
	for(var/datum/wifi/D in connected_devices)
		D.disconnect_device(src)

/datum/wifi/proc/connect_device(var/datum/wifi/device)
	connected_devices |= device

/datum/wifi/proc/disconnect_device(var/datum/wifi/device)
	connected_devices -= device



/datum/wifi/receiver
	var/id

/datum/wifi/receiver/New(var/new_id)
	..()
	id = new_id
	wifi_manager.add_device(src)

/datum/wifi/receiver/Destroy()
	..()
	wifi_manager.remove_device(src)



/datum/wifi/sender
	var/target

/datum/wifi/sender/New(var/new_target)
	..()
	target = new_target

/datum/wifi/sender/proc/set_target(var/new_target)
	target = new_target

/datum/wifi/sender/proc/send_connection_request()
	var/datum/connection_request/C = new(src, target)
	wifi_manager.add_request(C)



/datum/connection_request
	var/datum/wifi/sender/source	//wifi_sender object creating the request
	var/target						//id tag of the target device to try to connect to

/datum/connection_request/New(var/datum/wifi/sender/sender, var/receiver)
	source = sender
	target = receiver
