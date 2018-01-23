// This is a separate processor so the MC can schedule singuloth/Nar-sie independent from other objects.

PROCESSING_SUBSYSTEM_DEF(disaster)
	name = "Disaster"
	priority = SS_PRIORITY_DISASTER
	var/list/singularities = list()

/datum/controller/subsystem/processing/disaster/PreInit()
	wait = GLOB.using_map.cascade_speed
