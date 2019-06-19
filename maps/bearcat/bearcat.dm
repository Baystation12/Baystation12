#if !defined(using_map_DATUM)
	#include "bearcat_unit_testing.dm"

	#include "../../code/datums/music_tracks/businessend.dm"
	#include "../../code/datums/music_tracks/salutjohn.dm"

	#include "bearcat_areas.dm"
	#include "bearcat_jobs.dm"
	#include "bearcat_lobby.dm"
	#include "bearcat_shuttles.dm"
	#include "bearcat_overmap.dm"
	#include "bearcat_overrides.dm"
	#include "bearcat_loadouts.dm"
	#include "bearcat-1.dmm"
	#include "bearcat-2.dmm"

	#define using_map_DATUM /datum/map/bearcat

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Bearcat

#endif


/turf/simulated/floor
	name = "bare deck"

/turf/simulated/floor/tiled
	name = "deck"

/decl/flooring/tiling
	name = "deck"

/turf/simulated/wall/r_wall/hull
	color = COLOR_DARK_BROWN

/obj/machinery/door/airlock/hatch/autoname

/obj/machinery/door/airlock/hatch/autoname/Initialize()
	. = ..()
	var/area/A = get_area(src)
	SetName("hatch ([A.name])")

/obj/machinery/door/airlock/hatch/autoname/general
	stripe_color = COLOR_CIVIE_GREEN

/obj/machinery/door/airlock/hatch/autoname/maintenance
	stripe_color = COLOR_AMBER

/obj/machinery/door/airlock/hatch/autoname/command
	stripe_color = COLOR_COMMAND_BLUE

/obj/machinery/door/airlock/hatch/autoname/engineering
	stripe_color = COLOR_AMBER


//wild capitalism
/datum/computer_file/program/merchant
	required_access = null