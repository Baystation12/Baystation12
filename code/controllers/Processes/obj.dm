/datum/controller/process/obj/setup()
	name = "obj"
	schedule_interval = 20 // every 2 seconds
	start_delay = 8

/datum/controller/process/obj/started()
	..()
	if(!GLOB.processing_objects)
		GLOB.processing_objects = list()

/datum/controller/process/obj/doWork()
	for(last_object in GLOB.processing_objects)
		var/datum/O = last_object
		if(!QDELETED(O))
			try
				O:process()
			catch(var/exception/e)
				catchException(e, O)
			SCHECK
		else
			catchBadType(O)
			GLOB.processing_objects -= O

/datum/controller/process/obj/statProcess()
	..()
	stat(null, "[GLOB.processing_objects.len] object\s")
