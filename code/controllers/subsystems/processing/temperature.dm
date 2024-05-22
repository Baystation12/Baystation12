PROCESSING_SUBSYSTEM_DEF(temperature)
	name = "Temperature"
	priority = SS_PRIORITY_TEMPERATURE
	wait = 5 SECONDS
	process_proc = TYPE_PROC_REF(/atom, ProcessAtomTemperature)
