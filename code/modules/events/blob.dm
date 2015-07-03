/datum/event/blob
	announceWhen	= 12
	endWhen			= 120

	var/obj/effect/blob/core/Blob

/datum/event/blob/announce()
	level_seven_announcement()

/datum/event/blob/start()
	var/turf/T = pick(blobstart)
	if(!T)
		kill()
		return
	Blob = new /obj/effect/blob/core(T, 120)
	for(var/i = 1; i < rand(3, 4), i++)
		Blob.process()

/datum/event/blob/tick()
	if(!Blob)
		kill()
		return
	if(IsMultiple(activeFor, 3))
		Blob.process()
