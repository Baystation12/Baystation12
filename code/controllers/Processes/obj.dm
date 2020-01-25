/datum/controller/process/obj
	var/start_obj_time = 0
	var/obj/highest_obj
	var/highest_obj_time = 0

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
		var/start_obj_time = world.time
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
		var/time_taken = world.time - start_obj_time
		if(time_taken > highest_obj_time)
			highest_obj = last_object

/datum/controller/process/obj/statProcess()
	..()
	stat(null, "[GLOB.processing_objects.len] object\s")
