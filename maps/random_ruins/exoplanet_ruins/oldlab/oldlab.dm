
/datum/map_template/ruin/exoplanet/oldlab
	name = "Old Lab"
	id = "exoplanet_oldlab"
	description = "an abandoned lab"
	suffixes = list("oldlab/oldlab.dmm")
	spawn_cost = 1
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS
	ruin_tags = RUIN_HUMAN

	// Areas //

area/map_template/oldlab

/area/map_template/oldlab/solars
	name = "\improper Solar Array and hall"
	icon_state = "solar"

/area/map_template/oldlab/station/hall
	name = "\improper Hallway"
	icon_state = "processing"

/area/map_template/oldlab/station/breakroom
	name = "Break Room"
	icon_state = "processing"

/area/map_template/oldlab/station/chem
	name = "\improper Chemistry"
	icon_state = "chemistry"

/area/map_template/oldlab/station/xenobio
	name = "\improper Xenobiology"
	icon_state = "surgery"

/area/map_template/oldlab/station/northairlockatmos
	name = "\improper Atmos and Robotics"
	icon_state = "airlock"

/area/map_template/oldlab/station/southairlock
	name = "\improper Southern Airlock"
	icon_state = "airlock"

/area/map_template/oldlab/station/living
	name = "\improper Living Quarters"
	icon_state = "surgery"