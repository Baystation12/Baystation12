//-------------------------------
// Wifi
//-------------------------------
/datum/wifi
	var/obj/parent
	var/list/connected_devices

/datum/wifi/New(var/obj/O)
	connected_devices = new()
	if(istype(O))
		parent = O

/datum/wifi/Destroy(var/wifi/device)
	parent = null
	for(var/datum/wifi/D in connected_devices)
		D.disconnect_device(src)
		disconnect_device(D)
	return ..()

/datum/wifi/proc/connect_device(var/datum/wifi/device)
	connected_devices |= device

/datum/wifi/proc/disconnect_device(var/datum/wifi/device)
	connected_devices -= device


//-------------------------------
// Receiver
//-------------------------------
/datum/wifi/receiver
	var/id

/datum/wifi/receiver/New(var/new_id, var/obj/O)
	..(O)
	id = new_id
	wirelessProcess.add_device(src)

/datum/wifi/receiver/Destroy()
	wirelessProcess.remove_device(src)
	return ..()


//-------------------------------
// Sender
//-------------------------------
/datum/wifi/sender
	var/target

/datum/wifi/sender/New(var/new_target, var/obj/O)
	..(O)
	target = new_target
	send_connection_request()

/datum/wifi/sender/proc/set_target(var/new_target)
	target = new_target

/datum/wifi/sender/proc/send_connection_request()
	var/datum/connection_request/C = new(src, target)
	wirelessProcess.add_request(C)


//-------------------------------
// Connection request
//-------------------------------
/datum/connection_request
	var/datum/wifi/sender/source	//wifi_sender object creating the request
	var/target						//id tag of the target device to try to connect to

/datum/connection_request/New(var/datum/wifi/sender/sender, var/receiver)
	source = sender
	target = receiver


//-------------------------------
// Wireless tool (temp)
//-------------------------------
/obj/item/device/wireless_tool
	name = "wireless tool"
	desc = "Used for connecting machinery to controls for remote operation."
	icon_state = "wirelesstool_off"

/obj/item/device/wireless_tool/attack_self()
	if(icon_state == "wirelesstool_off")
		icon_state = "wirelesstool_on"
	else
		icon_state = "wirelesstool_off"
