/obj/effect/landmark/map_data/deepmaint/lvl1
	name = "Deep Dark Marvelous"
	height = 1

/datum/map_template/ruin/deepmaint
	name = "Deepmaint"
	id = "deepmaint"
	description = "Somewhere inbetween. How did we get here? How do we leave?"
	suffixes = list("maps/deepmaint/deepmaint-1.dmm")

/area/map_template/deepmaint
	name = "\improper Deep Maintenance"
	sound_env = TUNNEL_ENCLOSED
	turf_initializer = /singleton/turf_initializer/maintenance
	// ambience = list('sound/ambience/occ_scaryambie.ogg')
	forced_ambience = list('sound/ambience/maintambience.ogg')
	requires_power = FALSE
