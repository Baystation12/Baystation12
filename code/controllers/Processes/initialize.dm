var/list/pending_init_objects

/datum/controller/process/initialize
	var/list/objects_to_initialize

/datum/controller/process/initialize/setup()
	name = "init"
	schedule_interval = 1 // Every tick, scary
	objects_to_initialize = pending_init_objects

/datum/controller/process/initialize/doWork()
	for(var/atom/movable/A in objects_to_initialize)
		A.initialize()
		scheck()
		objects_to_initialize.Remove(A)

	if(!objects_to_initialize.len)
		disable()

/proc/initialize_object(var/atom/movable/obj_to_init)
	if(processScheduler.hasProcess("init"))
		var/datum/controller/process/initialize/init = processScheduler.getProcess("init")
		init.objects_to_initialize += obj_to_init
		init.enable()
	else
		world.log << "Not yet"
		if(!pending_init_objects) pending_init_objects = list()
		pending_init_objects += obj_to_init

/datum/controller/process/initialize/getStatName()
	return ..()+"([objects_to_initialize.len])"
