
/datum/map/torch
	name = "Torch"
	full_name = "IEV Torch"
	path = "torch"

	station_levels = list(1,2,3,4)
	contact_levels = list(1,2,3,4)
	player_levels = list(1,2,3,4)

	// Unit test exemptions
	exempt_areas = list(
		/area/tcommsat/chamber = NO_SCRUBBER,
		/area/vacant/infirmary = NO_SCRUBBER | NO_VENT,
		/area/vacant/monitoring = NO_SCRUBBER | NO_VENT
	)
