//-------------------------------
/*
	Interfaces

	These are the datums that an object needs to connect via the wireless controller. You will need a /wifi/receiver to
	allow other devices to connect to your device and send it instructions. You will need a /wifi/sender to send signals
	to other devices with wifi receivers. You can have multiple devices (senders and receivers) if you program your
	device to handle them.

	Each wifi interface has one "id". This identifies which devices can connect to each other. Multiple senders can
	connect to multiple receivers as long as they have the same id.

	Variants are found in devices.dm

	To add a receiver to an object:
		Add the following variables to the object:
			var/_wifi_id		<< variable that can be configured on the map, this is passed to the receiver later
			var/datum/wifi/receiver/subtype/wifi_receiver		<< the receiver (and subtype itself)

		Add or modify the objects initialize() proc to include:
			if(_wifi_id)		<< only creates a wifi receiver if an id is set
				wifi_receiver = new(_wifi_id, src)		<< this needs to be in initialize() as New() is usually too
														   early, and the receiver will try to connect to the controller
														   before it is setup.

		Add or modify the objects Destroy() proc to include:
			qdel(wifi_receiver)
			wifi_receiver = null

	Senders are setup the same way, except with a  var/datum/wifi/sender/subtype/wifi_sender  variable instead of (or in
	addition to) a /wifi/receiver variable.
	You will however need to call the /wifi/senders code to pass commands onto any connected receivers.
	Example:
		obj/machinery/button/attack_hand()
			wifi_sender.activate()
*/
//-------------------------------


//-------------------------------
// Wifi
//-------------------------------
/datum/wifi
	var/obj/parent
	var/list/connected_devices
	var/id

/datum/wifi/New(var/new_id, var/obj/O)
	connected_devices = new()
	id = new_id
	if(istype(O))
		parent = O

/datum/wifi/Destroy(var/wifi/device)
	parent = null
	for(var/datum/wifi/D in connected_devices)
		D.disconnect_device(src)
		disconnect_device(D)
	return ..()

/datum/wifi/proc/connect_device(var/datum/wifi/device)
	if(connected_devices)
		connected_devices |= device
	else
		connected_devices = new()
		connected_devices |= device

/datum/wifi/proc/disconnect_device(var/datum/wifi/device)
	if(connected_devices)
		connected_devices -= device

//-------------------------------
// Receiver
//-------------------------------
/datum/wifi/receiver/New()
	..()
	if(SSwireless)
		SSwireless.add_device(src)

/datum/wifi/receiver/Destroy()
	if(SSwireless)
		SSwireless.remove_device(src)
	return ..()

//-------------------------------
// Sender
//-------------------------------
/datum/wifi/sender/New()
	..()
	send_connection_request()

/datum/wifi/sender/proc/set_target(var/new_target)
	id = new_target

/datum/wifi/sender/proc/send_connection_request()
	var/datum/connection_request/C = new(src, id)
	SSwireless.add_request(C)

/datum/wifi/sender/proc/activate(mob/living/user)
	return

/datum/wifi/sender/proc/deactivate(mob/living/user)
	return

//-------------------------------
// Connection request
//-------------------------------
/datum/connection_request
	var/datum/wifi/sender/source	//wifi/sender object creating the request
	var/id							//id tag of the target device(s) to try to connect to

/datum/connection_request/New(var/datum/wifi/sender/sender, var/receiver)
	if(istype(sender))
		source = sender
		id = receiver
