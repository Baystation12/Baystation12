SUBSYSTEM_DEF(misc)
	name = "Early Initialization"
	init_order = SS_INIT_MISC
	flags = SS_NO_FIRE

/datum/controller/subsystem/misc/Initialize()
	if(config.generate_map)
		GLOB.using_map.perform_map_generation()

	// Create robolimbs for chargen.
	populate_robolimb_list()

	job_master = new /datum/controller/occupations()
	job_master.SetupOccupations(setup_titles=1)
	job_master.LoadJobs("config/jobs.txt")

	syndicate_code_phrase = generate_code_phrase()
	syndicate_code_response	= generate_code_phrase()

	setupgenetics()

	transfer_controller = new
	. = ..()