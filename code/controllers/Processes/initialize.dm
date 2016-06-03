var/datum/controller/process/initialize/initialization_process
var/list/queued_initializations_

/datum/controller/process/initialize/setup()
	name = "initialize"
	schedule_interval = 1 // Often, very often
	initialization_process = src

/datum/controller/process/initialize/doWork()
	for(last_object in queued_initializations_)
		var/atom/movable/AM = last_object
		dequeue_for_initialization(AM)
		AM.initialize()
		SCHECK

	if(!queued_initializations_.len)
		disable()	// If we've initialized all pending objects, disable ourselves

/proc/queue_for_initialization(var/atom/movable/AM)
	if(!istype(AM))
		CRASH("Invalid type. Was [AM.type].")
	if(!queued_initializations_) queued_initializations_ = list()
	queued_initializations_ += AM
	if(initialization_process && initialization_process.disabled)
		initialization_process.enable() // If a new object has been queued and the initializer is disabled, awaken it

/proc/dequeue_for_initialization(var/atom/movable/AM)
	if(!queued_initializations_) queued_initializations_ = list()
	queued_initializations_.Remove(AM)

/datum/controller/process/initialize/statProcess()
	..()
	stat(null, "[queued_initializations_.len] pending object\s")
