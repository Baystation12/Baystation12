/datum/controller/process/obj/setup()
	name = "obj"
	schedule_interval = 20 // every 2 seconds
	start_delay = 8

/datum/controller/process/obj/started()
	..()
	if(!processing_objects)
		processing_objects = list()

/datum/controller/process/obj/doWork()
	for(last_object in processing_objects)
		var/datum/O = last_object
		if(!QDELETED(O))
			try
				O:process()
			catch(var/exception/e)
				catchException(e, O)
			SCHECK
		else
			catchBadType(O)
			processing_objects -= O

/datum/controller/process/obj/statProcess()
	..()
	stat(null, "[processing_objects.len] objects")
