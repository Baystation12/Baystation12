
#include "../faction_base_unsc.dm"

#include "areas.dm"
#include "ai_items.dm"
#include "presets.dm"
#include "ODP_Cassius_1.dmm"
#include "ODP_Cassius_2.dmm"

/obj/effect/overmap/ship/unsc_odp_cassius
	name = "ODP Cassius"
	desc = "Located in geosynchronous orbit above the planet, this relatively compact Moncton-class Orbital Defense Platform has enough firepower to pierce any spacecraft known to man in a single hit."
	icon = 'code/modules/halo/icons/overmap/faction_misc.dmi'
	icon_state = "SMAC"
	faction = "UNSC"
	overmap_spawn_near_me = list(/obj/effect/overmap/sector/geminus_city)
	base = 1
	block_slipspace = 1
	fore_dir = WEST
	anchored = 1

	parent_area_type = /area/faction_base/unsc

	map_bounds = list(23,106,140,32) //Format: (TOP_LEFT_X,TOP_LEFT_Y,BOTTOM_RIGHT_X,BOTTOM_RIGHT_Y)

	occupy_range = 7

/obj/effect/overmap/ship/unsc_odp_cassius/Destroy()
	var/datum/game_mode/outer_colonies/gm = ticker.mode
	if(istype(gm))
		gm.allow_scan = 1

		//unlock a spartan slot after a short delay
		spawn(100)
			var/datum/job/special_job = job_master.occupations_by_title[/datum/job/unsc/spartan_two]
			if(special_job)
				special_job.total_positions += 1
				GLOB.UNSC.AnnounceCommand("Spartan IIs have been deployed to the battlefront.")
	. = ..()
