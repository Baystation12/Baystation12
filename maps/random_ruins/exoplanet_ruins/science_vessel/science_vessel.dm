/datum/map_template/ruin/exoplanet/science_vessel
	name = "crashed science vessel"
	id = "science_vessel"
	description = "A science vessel crashing after a drone malfunction."
	suffixes = list("science_vessel/science_vessel.dmm")
	cost = 2
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS

// Areas

/area/map_template/science_vessel
	name = "Unknown Science Vessel"
	icon_state = "red"

/area/map_template/science_vessel/cockpit
	name = "Unknown Science Vessel Cockpit"
	icon_state = "party"

/area/map_template/science_vessel/bedroom
	name = "Unknown Science Vessel Bedroom"
	icon_state = "blue"

/area/map_template/science_vessel/hydroponics
	name = "Unknown Science Vessel Hydroponics"
	icon_state = "green"

/area/map_template/science_vessel/engineering
	name = "Unknown Science Vessel Engineering"
	icon_state = "purple"

/area/map_template/science_vessel/atmospherics
	name = "Unknown Science Vessel Atmospherics"
	icon_state = "yellow"