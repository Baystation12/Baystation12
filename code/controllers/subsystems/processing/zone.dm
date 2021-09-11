//Used for zone processing, interacts with the melt subsystem. Fires once every two seconds.

PROCESSING_SUBSYSTEM_DEF(zone)
	name = "Zones"
	priority = SS_PRIORITY_ZONE
	wait = 2 SECONDS