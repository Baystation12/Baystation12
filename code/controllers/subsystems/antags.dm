SUBSYSTEM_DEF(antags)
	name = "Antags"
	init_order = SS_INIT_ANTAGS
	flags = SS_NO_FIRE

	var/static/list/antag_types


/datum/controller/subsystem/antags/stat_entry(msg)
	..("[msg] [antag_types.len] antag datums")


/datum/controller/subsystem/antags/Initialize(timeofday)
	antag_types = GLOB.all_antag_types_
	var/datum/antagonist/A
	for (var/key in antag_types)
		A = antag_types[key]
		A.Initialize()
