SUBSYSTEM_DEF(misc)
	name = "Early Initialization"
	init_order = SS_INIT_MISC
	flags = SS_NO_FIRE

/datum/controller/subsystem/misc/Initialize()
	if(config.generate_map)
		GLOB.using_map.perform_map_generation()

	// Create robolimbs for chargen.
	populate_robolimb_list()
	setupgenetics()

	transfer_controller = new
	. = ..()