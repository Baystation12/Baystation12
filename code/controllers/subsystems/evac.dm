SUBSYSTEM_DEF(evac)
	name = "Evacuation"
	priority = SS_PRIORITY_EVAC
	flags = SS_NO_TICK_CHECK | SS_BACKGROUND
	wait = 2 SECONDS


/datum/controller/subsystem/evac/Initialize(start_uptime)
	evacuation_controller = new GLOB.using_map.evac_controller_type
	evacuation_controller.set_up()


/datum/controller/subsystem/evac/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	return ..(evacuation_controller?.UpdateStat()||"Not Initialized")


/datum/controller/subsystem/evac/fire(resumed, no_mc_tick)
	evacuation_controller.process()
