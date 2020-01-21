
#include "../faction_base_unsc.dm"

#include "Cassius_Station_1.dmm"
#include "Cassius_Station_2.dmm"

/obj/effect/overmap/ship/unsc_cassius
	name = "Cassius Station"
	desc = "Located in geosynchronous above the planet, its MAC gun can put a round clean through a Covenant capital ship."
	icon = 'code/modules/halo/icons/overmap/faction_misc.dmi'
	icon_state = "SMAC"
	faction = "UNSC"
	overmap_spawn_near_me = list(/obj/effect/overmap/ship/unsclightbrigade)
	base = 1
	block_slipspace = 1
	fore_dir = WEST
	anchored = 1

	parent_area_type = /area/faction_base/unsc

	map_bounds = list(37,117,114,68) //Format: (TOP_LEFT_X,TOP_LEFT_Y,BOTTOM_RIGHT_X,BOTTOM_RIGHT_Y)

/obj/effect/overmap/ship/unsc_cassius/Initialize()
	. = ..()
	GLOB.overmap_tiles_uncontrolled -= range(7,src)


/area/faction_base/unsc/upperlevel
	name = "UNSC Cassius Station (Upper)"
	icon_state = "green"

/area/faction_base/unsc/lowerlevel
	name = "UNSC Cassius Station (Lower)"
	icon_state = "yellow"

/area/faction_base/unsc/mac
	name = "UNSC Cassius Station MAC"
	icon_state = "firingrange"

/area/faction_base/unsc/engineering
	name = "UNSC Cassius Station Shuttle"
	icon_state = "engine"