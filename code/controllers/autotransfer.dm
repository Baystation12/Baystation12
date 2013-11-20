var/datum/controller/transfer_controller = new /transfer_controller()
var/timerbuffer = 0 //buffer for time check
/transfer_controller/New()
	timerbuffer = config.vote_autotransfer_initial
	processing_objects += src

/transfer_controller/Del()
	processing_objects -= src

/transfer_controller/proc/process()
	if (world.time >= timerbuffer - 600)
		vote.autotransfer()
		timerbuffer = timerbuffer + config.vote_autotransfer_interval