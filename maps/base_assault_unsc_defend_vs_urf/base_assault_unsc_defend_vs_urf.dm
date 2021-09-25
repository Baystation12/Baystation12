#include "../base_assault/base_assault_gm.dm"
#include "urf_unsc_gm.dm"

/datum/map/base_assault_unsc_vs_urf
	name = "UNSC Outpost"
	full_name = "111 Tauri System, UNSC Outpost"
	system_name = "111 Tauri"
	path = "base_assault_unsc_defend_vs_urf"
	station_levels = list()
	admin_levels = list()
	accessible_z_levels = list()
	lobby_icon = 'code/modules/halo/splashworks/title6.jpg'
	id_hud_icons = 'maps/ks7_elmsville/hud_icons.dmi'
	station_networks = list("Exodus")
	station_name  = "UNSC Outpost"
	station_short = "UNSC Outpost"
	dock_name     = "Space Elevator"
	boss_name     = "United Nations Space Command"
	boss_short    = "UNSC HIGHCOM"
	company_name  = "United Nations Space Command"
	company_short = "UNSC"

	use_overmap = 1
	overmap_size= 15
	overmap_event_tokens = 1

	allowed_gamemodes = list("base_assault_unsc_urf")
	map_admin_faxes = list("URF Command", "HIGHCOM")

#if !defined(using_map_DATUM)

	#define using_map_DATUM /datum/map/base_assault_unsc_vs_urf

	#include "unit_tests.dm"

	#include "../npc_ships/om_ship_areas.dm"
	#include "../area_holders/overmap_ship_area_holder.dmm"

	#include "../Admin Planet/includes.dm"

	#include "../faction_bases/complex046/complex046.dm"

	#include "../faction_bases/CassiusMoonStation/cassiusmoon.dm"

	#include "../urf_flagship/includes.dm"

	#include "../../code/modules/halo/lobby_music/odst_music.dm"
	#include "../../code/modules/halo/lobby_music/halo_music.dm"

	#include "../../code/modules/halo/supply/unsc.dm"
	#include "../../code/modules/halo/supply/oni.dm"

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Base Assault
#endif

//Spawn In Overrides//
/obj/effect/overmap/complex046

/obj/effect/overmap/unsc_cassius_moon
	overmap_spawn_in_me = list(/obj/effect/overmap/complex046)

/datum/map/base_assault_unsc_vs_urf
	allowed_jobs = list(
	/datum/job/unsc/marine,
	/datum/job/unsc/marine/specialist,
	/datum/job/unsc/marine/hellbringer,
	/datum/job/unsc/marine/squad_leader,
	/datum/job/unsc/odst,
	/datum/job/unsc/odst/squad_leader,
	/datum/job/unsc/commanding_officer,
	/datum/job/unsc/executive_officer,
	/datum/job/geminus_innie,
	/datum/job/geminus_innie/officer,
	/datum/job/geminus_innie/commander,
	/datum/job/soe_commando,
	/datum/job/soe_commando_officer,
	/datum/job/soe_commando_captain,
	/datum/job/geminus_innie/orion_defector,
	)

	allowed_spawns = list(\
		DEFAULT_SPAWNPOINT_ID,\
		"UNSC Base Spawns",\
		"UNSC Base Fallback Spawns"\
		)

	default_spawn = DEFAULT_SPAWNPOINT_ID