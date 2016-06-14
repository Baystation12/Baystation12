/**********
* Jamming *
**********/
/datum/uplink_item/item/jamming
	category = /datum/uplink_category/jamming

/datum/uplink_item/item/jamming/suit_sensor_mobile
	name = "Suit Sensor Jamming Device"
	desc = "This device will affect suit sensor data using method and radius defined by the user."
	item_cost = 5
	path = /obj/item/device/suit_sensor_jammer

/datum/uplink_item/item/jamming/suit_sensor_shutdown
	name = "Complete Suit Sensor Shutdown"
	desc = "Completely disables all suit sensors for 10 minutes."
	item_cost = 10
	path = /obj/item/device/uplink_service/jamming


/datum/uplink_item/item/jamming/suit_sensor_garble
	name = "Complete Suit Sensor Jamming"
	desc = "Garbles all suit sensor data for 10 minutes."
	item_cost = 4
	path = /obj/item/device/uplink_service/jamming/garble
