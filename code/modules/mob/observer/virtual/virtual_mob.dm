/mob/living
	speech_handler = new/datum/speech_handler/death()
	virtual = /mob/observer/virtual/mob

/mob/observer/virtual/mob
	host_type = /mob

/mob/observer/virtual/mob/receive_sound(var/datum/communication/communication, var/datum/communication_metadata/cm)
	if(cm.get_distance(src) > cm.range)
		return
	..()
