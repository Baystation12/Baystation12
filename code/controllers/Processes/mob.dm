/datum/controller/process/mob
	var/tmp/datum/updateQueue/updateQueueInstance

/datum/controller/process/mob/setup()
	name = "mob"
	schedule_interval = 20 // every 2 seconds
	start_delay = 16

/datum/controller/process/mob/started()
	..()
	if(!GLOB.mob_list)
		GLOB.mob_list = list()

/datum/controller/process/mob/doWork()
	for(last_object in GLOB.mob_list)
		var/mob/M = last_object
		if(istype(M) && !QDELETED(M))
			try
				M.Life()
			catch(var/exception/e)
				catchException(e, M)
			SCHECK
		else
			catchBadType(M)
			GLOB.mob_list -= M

/datum/controller/process/mob/statProcess()
	..()
	stat(null, "[GLOB.mob_list.len] mob\s")
