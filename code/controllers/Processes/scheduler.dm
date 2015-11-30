var/global/list/scheduled_tasks

/datum/controller/process/scheduler/setup()
	name = "scheduler"
	schedule_interval = 7 SECONDS
	scheduled_tasks = list()

/datum/controller/process/scheduler/doWork()
	for(last_object in scheduled_tasks)
		var/datum/scheduled_task/scheduled_task = last_object
		try
			if(world.time > scheduled_task.trigger_time)
				scheduled_tasks -= scheduled_task
				scheduled_task.process()
		catch(var/exception/e)
			catchException(e, last_object)
		SCHECK

/datum/controller/process/scheduler/statProcess()
	..()
	stat(null, "[scheduled_tasks.len] tasks")

/*************
* Task Datum *
*************/
/datum/scheduled_task
	var/trigger_time
	var/procedure
	var/list/arguments
	var/task_after_process
	var/list/task_after_process_args

/datum/scheduled_task/New(var/trigger_time, var/procedure, var/list/arguments, var/proc/task_after_process, var/list/task_after_process_args)
	src.trigger_time = trigger_time
	src.procedure = procedure
	src.arguments = arguments ? arguments : list()
	src.task_after_process = task_after_process ? task_after_process : /proc/destroy_scheduled_task
	src.task_after_process_args = istype(task_after_process_args) ? task_after_process_args : list()
	task_after_process_args += src
	scheduled_tasks += src

/datum/scheduled_task/Destroy()
	scheduled_tasks -= src
	procedure = null
	arguments.Cut()
	task_after_process = null
	task_after_process_args.Cut()
	return ..()

/datum/scheduled_task/proc/process()
	call(procedure)(arglist(arguments))
	after_process()

/datum/scheduled_task/proc/after_process()
	call(task_after_process)(arglist(task_after_process_args))

/datum/scheduled_task/source
	var/datum/source

/datum/scheduled_task/source/New(var/trigger_time, var/datum/source, var/procedure, var/list/arguments, var/proc/task_after_process, var/list/task_after_process_args)
	src.source = source
	src.source.register(OBSERVER_EVENT_DESTROY, src, /datum/scheduled_task/source/proc/source_destroyed)
	..(trigger_time, procedure, arguments, task_after_process, task_after_process_args)

/datum/scheduled_task/source/Destroy()
	source = null
	return ..()

/datum/scheduled_task/source/process()
	call(source, procedure)(arglist(arguments))
	after_process()

/datum/scheduled_task/source/proc/source_destroyed()
	qdel(src)

/proc/destroy_scheduled_task(var/datum/scheduled_task/gt)
	qdel(gt)

/proc/repeat_scheduled_task(var/trigger_delay, var/datum/scheduled_task/gt)
	gt.trigger_time = world.time + trigger_delay
	scheduled_tasks += gt
