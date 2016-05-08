
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

	shuttle_docked_message = "Bluespace drive has been spooled up, prepare for launch. Time to jump, approximately %ETD%."
	shuttle_leaving_dock = "Jump iniated, entering bluespace in %ETA%."
	shuttle_called_message = "All hands, bluespace drive is spooling up. Jump in %ETA%."
	shuttle_recall_message = "Jump sequence aborted, please return to your duties."
	emergency_shuttle_docked_message = "Emergency escape pods are prepped. You have %ETD% to board the emergency escape pods."
	emergency_shuttle_leaving_dock = "Emergency escape pods are launched, arriving at rendezvous point in %ETA%."
	emergency_shuttle_called_message = "Emergency escape pods are being prepped. ETA %ETA%"
	emergency_shuttle_recall_message = "Emergency escape sequence aborted, please return to your duties."
