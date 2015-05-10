/datum/controller/process/pipenet/setup()
	name = "pipenet"
	schedule_interval = 20 // every 2 seconds

/datum/controller/process/pipenet/doWork()
	if(!pipe_processing_killed)
		for(var/datum/pipe_network/pipeNetwork in pipe_networks)
			if(istype(pipeNetwork) && !pipeNetwork.disposed)
				pipeNetwork.process()
				scheck()
				continue

			pipe_networks.Remove(pipeNetwork)

/datum/controller/process/pipenet/getStatName()
	return ..()+"([pipe_networks.len])"