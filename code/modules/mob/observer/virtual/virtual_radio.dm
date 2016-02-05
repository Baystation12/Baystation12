/mob/observer/virtual/radio
	host_type = /obj/item/device/radio

/mob/observer/virtual/radio/receive_sound(var/datum/communication/speech, var/datum/communication_metadata/cm)
	// Radio listeners don't know what to do without radio channels
	if(!cm.radio_channel)
		return
	..()
