/datum/map_template/ruin/exoplanet/skrell_biodome
	name = "Skrellian Biodome"
	id = "skrell_biodome"
	description = "Strange round structure."
	suffixes = list("skrell_biodome/skrell_biodome.dmm")
	spawn_cost = 0.5
	ruin_tags = RUIN_HUMAN
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS

/area/map_template/biodome/living
	name = "\improper Life support area"
	icon_state = "bridge"

/area/map_template/biodome/medbay
	name = "\improper Medical Bay"
	icon_state = "medbay"

/area/map_template/biodome/engineering
	name = "\improper Power supply area"
	icon_state = "engineering_supply"

/area/map_template/biodome/atmos
	name = "\improper Gas compartment"
	icon_state = "atmos"
