SUBSYSTEM_DEF(misc)
	name = "Early Initialization"
	init_order = SS_INIT_MISC
	flags = SS_NO_FIRE

	var/changelog_hash

/datum/controller/subsystem/misc/Initialize()
	changelog_hash = md5('html/changelog.html')

	if(config.generate_map)
		GLOB.using_map.perform_map_generation()

	//creates pipe categories for pipe dispensers
	initialize_pipe_datum_category_list()

	// Create robolimbs for chargen.
	populate_robolimb_list()
	setupgenetics()

	transfer_controller = new
	. = ..()
