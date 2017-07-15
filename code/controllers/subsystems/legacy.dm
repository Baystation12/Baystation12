SUBSYSTEM_DEF(legacy)
	name = "Legacy"
	init_order = INIT_BAY_LEGACY
	flags = SS_NO_FIRE

/datum/controller/subsystem/legacy/Initialize(timeofday)
	master_controller.setup()
	return ..()
