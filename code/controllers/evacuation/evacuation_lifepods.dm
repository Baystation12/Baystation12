#define EVAC_OPT_ABANDON_SHIP "abandon_ship"
#define EVAC_OPT_CANCEL_ABANDON_SHIP "cancel_abandon_ship"

/datum/evacuation_controller/lifepods
	name = "escape pod controller"

	evac_prep_delay    = 7 MINUTES
	evac_launch_delay  = 0
	evac_transit_delay = 2 MINUTES

	evacuation_options = list(
		EVAC_OPT_ABANDON_SHIP = new /datum/evacuation_option/abandon_ship(),
		EVAC_OPT_CANCEL_ABANDON_SHIP = new /datum/evacuation_option/cancel_abandon_ship(),
	)

/datum/evacuation_controller/lifepods/launch_evacuation()
	priority_announcement.Announce(replacetext(replacetext(GLOB.using_map.emergency_shuttle_leaving_dock, "%dock_name%", "[GLOB.using_map.dock_name]"),  "%ETA%", "[round(get_eta()/60,1)] minute\s"))

/datum/evacuation_controller/lifepods/available_evac_options()
	if (is_on_cooldown())
		return list()
	if (is_idle())
		return list(evacuation_options[EVAC_OPT_ABANDON_SHIP])
	if (is_evacuating())
		return list(evacuation_options[EVAC_OPT_CANCEL_ABANDON_SHIP])

#undef EVAC_OPT_ABANDON_SHIP
#undef EVAC_OPT_CANCEL_ABANDON_SHIP