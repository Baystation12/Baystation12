
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

/obj/effect/overmap/unsc_cassius_moon/Destroy()
	var/datum/game_mode/outer_colonies/gm = ticker.mode
	if(istype(gm))
		gm.allow_scan = 1

		//unlock some new job slots after a short delay
		spawn(30)
			GLOB.UNSC.unlock_special_job()
			GLOB.COVENANT.unlock_special_job()

		//this is janky, i really should fix spawns instead
		//its necessary because the AI initial spawn is on the ODP
		//without the ODP the AI will spawn somewhere random like the Cov ship
		var/datum/job/ai_job = job_master.occupations_by_type[/datum/job/unsc_ai]
		ai_job.total_positions = 0

	. = ..()
