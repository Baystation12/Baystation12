/datum/controller/process/powernet/setup()
	name = "powernet"
	schedule_interval = 20 // every 2 seconds

/datum/controller/process/powernet/doWork()
	for(var/datum/powernet/powerNetwork in powernets)
		if(istype(powerNetwork) && !powerNetwork.disposed)
			powerNetwork.reset()
			scheck()
			continue

		powernets.Remove(powerNetwork)

	// This is necessary to ensure powersinks are always the first devices that drain power from powernet.
	// Otherwise APCs or other stuff go first, resulting in bad things happening.
	for(var/obj/item/device/powersink/S in processing_objects)
		S.drain()

/datum/controller/process/powernet/getStatName()
	return ..()+"([powernets.len])"
