
/datum/map_template/ruin/exoplanet/cappoint1
	name = "Uplink Site Zarye"
	id = "exoplanet_cappoint1"
	description = "an abandoned lab"
	suffixes = list("cappoint1/cappoint1.dmm")
	spawn_cost = 1
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS | TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	ruin_tags = RUIN_HUMAN

	// Areas //

/area/map_template/cappoint1

/area/map_template/cappoint1/solars
	name = "\improper Solar Array and hall"
	icon_state = "solar"

/area/map_template/cappoint1/station/hall
	name = "\improper Hallway"
	icon_state = "processing"

/area/map_template/cappoint1/station/breakroom
	name = "Break Room"
	icon_state = "processing"

/area/map_template/cappoint1/station/chem
	name = "\improper Chemistry"
	icon_state = "chemistry"

/area/map_template/cappoint1/station/xenobio
	name = "\improper Xenobiology"
	icon_state = "surgery"

/area/map_template/cappoint1/station/northairlockatmos
	name = "\improper Atmos and Robotics"
	icon_state = "airlock"

/area/map_template/cappoint1/station/southairlock
	name = "\improper Southern Airlock"
	icon_state = "airlock"

/area/map_template/cappoint1/station/living
	name = "\improper Living Quarters"
	icon_state = "surgery"
