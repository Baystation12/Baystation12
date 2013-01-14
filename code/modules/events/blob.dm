/datum/event/blob
	announceWhen	= 12
	endWhen			= 120

	var/obj/effect/blob/core/Blob


/datum/event/blob/announce()
	command_alert("Confirmed outbreak of level 5 biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert")
	world << sound('sound/AI/outbreak5.ogg')


/datum/event/blob/start()
	var/turf/T = pick(blobstart)
	if(!T)	kill()
	Blob = new /obj/effect/blob/core(T, 200)
	Blob.Life()
	Blob.Life()
	Blob.Life()


/datum/event/blob/tick()
	if(!Blob)	kill()
	if(IsMultiple(activeFor, 3))
		Blob.Life()