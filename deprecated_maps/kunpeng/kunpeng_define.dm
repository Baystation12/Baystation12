
/datum/map/kunpeng
	name = "Kun-Peng - Deprecated"
	full_name = "IOV Kun-Peng"
	path = "kunpeng"

	station_levels = list()
	admin_levels = list()
	contact_levels = list()
	player_levels = list()

	// Unit test exemptions
	/*exempt_areas = list(
		/area/medical/genetics = NO_APC,
		/area/engineering/atmos/storage = NO_SCRUBBER | NO_VENT,
		/area/server = NO_SCRUBBER
	)*/

	shuttle_docked_message = "Bluespace drive has been spooled up, prepare for launch. Time to jump, approximately %ETD%."
	shuttle_leaving_dock = "Jump iniated, entering bluespace in %ETA%."
	shuttle_called_message = "All hands, bluespace drive is spooling up. Jump in %ETA%."
	shuttle_recall_message = "Jump sequence aborted, please return to your duties."
	emergency_shuttle_docked_message = "Emergency escape pods are prepped. You have %ETD% to board the emergency escape pods."
	emergency_shuttle_leaving_dock = "Emergency escape pods are launched, arriving at rendezvous point in %ETA%."
	emergency_shuttle_called_message = "Emergency escape pods are being prepped. ETA %ETA%"
	emergency_shuttle_recall_message = "Emergency escape sequence aborted, please return to your duties."
