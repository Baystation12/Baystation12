PROCESSING_SUBSYSTEM_DEF(overmap)

/datum/controller/subsystem/processing/overmap
	name = "Overmap"
	priority = SS_PRIORITY_OVERMAP
	flags = SS_TICKER|SS_NO_INIT
	wait = 7

/datum/controller/subsystem/processing/overmap/New()
	NEW_SS_GLOBAL(SSovermap)
