/obj/landmark/map_data/deepmaint/lvl1
	name = "Deep Dark Marvelous"
	height = 1

/singleton/map_template/ruin/deepmaint
	name = "Deepmaint"
	id = "deepmaint"
	description = "Somewhere inbetween. How did we get here? How do we leave?"
	prefix = "packs/deepmaint/"
	suffixes = list("deepmaint-1.dmm")

/area/map_template/deepmaint
	name = "\improper Deep Maintenance"
	sound_env = TUNNEL_ENCLOSED
	turf_initializer = /singleton/turf_initializer/maintenance
	forced_ambience = list('sound/ambience/maintambience.ogg')
	requires_power = FALSE
