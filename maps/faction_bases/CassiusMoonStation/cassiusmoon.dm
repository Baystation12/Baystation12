
#include "../faction_base_unsc.dm"

#include "areas.dm"

#include "ai_items.dm"
#include "presets.dm"
#include "CassiusMoon.dmm"

/obj/effect/overmap/unsc_cassius_moon
	name = "Cassius Orbital Facility"
	desc = "This orbital facility transmits power wirelessly to an orbital MAC."
	icon = 'code/modules/halo/icons/overmap/faction_bases.dmi'
	icon_state = "moonbase"
	faction = "UNSC"
	overmap_spawn_near_me = list()
	base = 1
	block_slipspace = 1
	//fore_dir = WEST
	anchored = 1

	parent_area_type = /area/faction_base/unsc/moonbase

	map_bounds = list(1,150,150,1) //Format: (TOP_LEFT_X,TOP_LEFT_Y,BOTTOM_RIGHT_X,BOTTOM_RIGHT_Y)

	occupy_range = 7

/obj/effect/overmap/unsc_cassius_moon/Initialize()
	. = ..()
	loot_distributor.loot_list["bombRandom"] = list(/obj/effect/bombpoint_mark,/obj/effect/bombpoint_mark)

/obj/effect/overmap/unsc_cassius_moon/CanUntargetedBombard(var/obj/console_from)
	console_from.visible_message("<span class = 'notice'>Post firing scan reveals any viable targets are located deep underground, requiring direct designation.</span>")
	return 0

/obj/effect/overmap/unsc_cassius_moon/nuked_effects(var/nuke_at_loc)
	. = ..()
	superstructure_failing = 0
	pre_superstructure_failing()

