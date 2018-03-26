SUBSYSTEM_DEF(antags)
	name = "Antags"
	init_order = INIT_ORDER_ANTAGS
	flags = SS_NO_FIRE

/datum/controller/subsystem/antags/Initialize(timeofday)
	for(var/antag_type in GLOB.all_antag_types_)
		var/datum/antagonist/antag = GLOB.all_antag_types_[antag_type]
		antag.Initialize()
	. = ..()

/datum/controller/subsystem/antags/stat_entry(msg)
	..("[GLOB.all_antag_types_.len] antag datums")