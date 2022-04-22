SUBSYSTEM_DEF(init_misc)
	name = "Misc Initialization"
	init_order = SS_INIT_MISC
	flags = SS_NO_FIRE


/datum/controller/subsystem/init_misc/UpdateStat(time)
	if (initialized)
		return
	..()


/datum/controller/subsystem/init_misc/Initialize(start_uptime)
	GLOB.changelog_hash = md5('html/changelog.html')
	if(config.generate_map)
		GLOB.using_map.perform_map_generation()
	init_antags()
	initialize_pipe_datum_category_list()
	populate_robolimb_list()
	setupgenetics()
	transfer_controller = new


/datum/controller/subsystem/init_misc/proc/init_antags()
	for (var/antag_type in GLOB.all_antag_types_)
		var/datum/antagonist/antag = GLOB.all_antag_types_[antag_type]
		antag.Initialize()


GLOBAL_VAR(changelog_hash)
