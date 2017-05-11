/datum/controller/process/mob
	var/tmp/datum/updateQueue/updateQueueInstance

/datum/controller/process/mob/setup()
	name = "mob"
	schedule_interval = 20 // every 2 seconds
	start_delay = 16

/datum/controller/process/mob/started()
	..()
	if(!mob_list)
		mob_list = list()

/datum/controller/process/mob/doWork()
	for(last_object in mob_list)
		var/mob/M = last_object
		if(istype(M) && !QDELETED(M))
			try
				M.Life()
			catch(var/exception/e)
				catchException(e, M)
			SCHECK
		else
			catchBadType(M)
			mob_list -= M

/datum/controller/process/mob/statProcess()
	..()
	stat(null, "[mob_list.len] mobs")
