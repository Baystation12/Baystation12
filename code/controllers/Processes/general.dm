var/global/list/general_tasks

/datum/controller/process/general/setup()
	name = "general"
	schedule_interval = 7 SECONDS
	general_tasks = list()

/datum/controller/process/general/doWork()
	for(last_object in general_tasks)
		var/datum/general_task/general_task = last_object
		try
			if(world.time > general_task.trigger_time)
				general_tasks -= general_task
				general_task.process()
		catch(var/exception/e)
			catchException(e, last_object)
		SCHECK

/datum/controller/process/general/statProcess()
	..()
	stat(null, "[general_tasks.len] tasks")

/*************
* Task Datum *
*************/
/datum/general_task
	var/trigger_time
	var/procedure
	var/list/arguments
	var/task_after_process
	var/list/task_after_process_args

/datum/general_task/New(var/trigger_time, var/procedure, var/list/arguments, var/proc/task_after_process, var/list/task_after_process_args)
	src.trigger_time = trigger_time
	src.procedure = procedure
	src.arguments = arguments ? arguments : list()
	src.task_after_process = task_after_process ? task_after_process : /proc/destroy_general_task
	src.task_after_process_args = istype(task_after_process_args) ? task_after_process_args : list()
	task_after_process_args += src
	general_tasks += src

/datum/general_task/Destroy()
	general_tasks -= src
	procedure = null
	arguments.Cut()
	task_after_process = null
	task_after_process_args.Cut()
	return ..()

/datum/general_task/proc/process()
	call(procedure)(arglist(arguments))
	after_process()

/datum/general_task/proc/after_process()
	call(task_after_process)(arglist(task_after_process_args))

/datum/general_task/source
	var/datum/source

/datum/general_task/source/New(var/trigger_time, var/datum/source, var/procedure, var/list/arguments, var/proc/task_after_process, var/list/task_after_process_args)
	src.source = source
	src.source.register(OBSERVER_EVENT_DESTROY, src, /datum/general_task/source/proc/source_destroyed)
	..(trigger_time, procedure, arguments, task_after_process, task_after_process_args)

/datum/general_task/source/Destroy()
	source = null
	return ..()

/datum/general_task/source/process()
	call(source, procedure)(arglist(arguments))
	after_process()

/datum/general_task/source/proc/source_destroyed()
	qdel(src)

/proc/destroy_general_task(var/datum/general_task/gt)
	qdel(gt)

/proc/repeat_general_task(var/trigger_delay, var/datum/general_task/gt)
	gt.trigger_time = world.time + trigger_delay
	general_tasks += gt
