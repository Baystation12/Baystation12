/datum/map_template/ruin/exoplanet/commonwealthmining
	name = "commonwealth mining base"
	id = "exoplanet_commonwealthmining"
	description = "Terran commonwealth mining base, abandoned, re-occupied, and abandoned again. Stalked by a nameless creature of the deep."
	suffixes = list("commonwealthwoes/commonwealthmining.dmm")
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS
	ruin_tags = RUIN_HABITAT
	area_usage_test_exempted_root_areas = list(/area/map_template/commonwealthwoes)

/datum/map_template/ruin/exoplanet/commonwealthmining/survey
	name = "commonwealth survey complex"
	id = "exoplanet_commonwealthsurvey"
	description = "Terran commonwealth Survey base, long abandoned and non-operable. In a sorry state, but with bears!"
	suffixes = list("commonwealthwoes/commonwealthsurvey.dmm")

/area/map_template/commonwealthwoes
	name = "\improper Commonwealth"
	icon_state = "hydro"
	icon = 'maps/random_ruins/exoplanet_ruins/commonwealthwoes/commonwealthwoes.dmi'

/area/map_template/commonwealthwoes
	name = "\improper Survey External"
	icon_state = "solar"

/area/map_template/commonwealthwoes/survey
	name = "\improper Survey Dining Complex"
	icon_state = "A"

/area/map_template/commonwealthwoes/survey/barracks
	name = "\improper Survey Barracks"
	icon_state = "B"

/area/map_template/commonwealthwoes/survey/dorms
	name = "\improper Survey Dorms"
	icon_state = "C"

/area/map_template/commonwealthwoes/survey/fueling
	name = "\improper Survey Fueling Bay"
	icon_state = "D"

/area/map_template/commonwealthwoes/survey/operations
	name = "\improper Survey Operations"
	icon_state = "F"

/area/map_template/commonwealthwoes/survey/power
	name = "\improper Survey Power Generation"
	icon_state = "X"

/area/map_template/commonwealthwoes/mining
	name = "\improper Mining Complex"
	icon_state = "processing"
