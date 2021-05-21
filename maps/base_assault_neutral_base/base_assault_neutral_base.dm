
/datum/map/neutral_city
	name = "KS7-535, Unknown Colony"
	full_name = "111 Tauri System, UNSC Outpost"
	system_name = "111 Tauri"
	path = "base_Assault_neutral_base"
	station_levels = list()
	admin_levels = list()
	accessible_z_levels = list()
	lobby_icon = 'code/modules/halo/splashworks/title6.jpg'
	id_hud_icons = 'maps/ks7_elmsville/hud_icons.dmi'
	station_networks = list()
	station_name  = "UNSC Outpost"
	station_short = "UNSC Outpost"
	dock_name     = "Space Elevator"
	boss_name     = "United Nations Space Command"
	boss_short    = "UNSC HIGHCOM"
	company_name  = "United Nations Space Command"
	company_short = "UNSC"

	use_overmap = 1
	overmap_size= 30
	overmap_event_tokens = 1

	allowed_gamemodes = list("base_assault_capture_and_hold")
	map_admin_faxes = list("Ministry of Tranquility (General)","Ministry of Resolution (War Matters)","Ministry of Fervent Intercession (Internal Affairs)")


#if !defined(using_map_DATUM)

	#define using_map_DATUM /datum/map/neutral_city

	#include "unit_tests.dm"

	#include "../npc_ships/om_ship_areas.dm"
	#include "../area_holders/overmap_ship_area_holder.dmm"

	#include "../Admin Planet/includes.dm"

	#include "../faction_bases/complex046/complex046.dm"

	#include "../UNSC_Difference_Of_Opinion/includes.dm"

	#include "gm.dm"

	#include "areas.dm"
	#include "overmap.dm"
	#include "neutral_city.dmm"

	#include "../CRS_Unyielding_Transgression/includes.dm"

	#include "../../code/modules/halo/lobby_music/odst_music.dm"
	#include "../../code/modules/halo/lobby_music/halo_music.dm"

	#include "../../code/modules/halo/supply/unsc.dm"
	#include "../../code/modules/halo/supply/oni.dm"
	#include "../../code/modules/halo/supply/covenant.dm"

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Base Assault, neutral base

#endif


/datum/map/neutral_city
	allowed_jobs = list(\
	/datum/job/unsc/spartan_two,
	/datum/job/unsc/marine,
	/datum/job/unsc/marine/specialist,
	/datum/job/unsc/marine/hellbringer,\
	/datum/job/unsc/marine/squad_leader,
	/datum/job/unsc/odst,
	/datum/job/unsc/odst/squad_leader,
	/datum/job/unsc/commanding_officer,
	/datum/job/unsc/executive_officer,
	/datum/job/covenant/huragok,
	/datum/job/covenant/sangheili_minor,
	/datum/job/covenant/sangheili_major,
	/datum/job/covenant/sangheili_ultra,
	/datum/job/covenant/sangheili_shipmaster,
	/datum/job/covenant/kigyarminor,
	/datum/job/covenant/unggoy_minor,
	/datum/job/covenant/unggoy_major,
	/datum/job/covenant/unggoy_ultra,
	/datum/job/covenant/unggoy_deacon,
	/datum/job/covenant/unggoy_heavy,
	/datum/job/covenant/skirmmurmillo,
	/datum/job/covenant/skirmcommando,
	/datum/job/covenant/skirmchampion,
	/datum/job/covenant/brute_minor,
	/datum/job/covenant/brute_major,
	/datum/job/covenant/brute_captain,
	/datum/job/covenant/yanmee_minor,
	/datum/job/covenant/yanmee_major,
	/datum/job/covenant/yanmee_ultra,
	/datum/job/covenant/yanmee_leader,
	/datum/job/covenant/mgalekgolo,
	)

	allowed_spawns = list(\
		DEFAULT_SPAWNPOINT_ID,\
		"UNSC Base Spawns",\
		"UNSC Base Fallback Spawns"\
		)

	default_spawn = DEFAULT_SPAWNPOINT_ID

//Move the unsc backup base to nullspace.
/obj/effect/overmap/complex046/Initialize()
	. = ..()
	loc = null

/obj/effect/overmap/ship/covenant_light_cruiser
	occupy_range = 2
	has_external_dropship_points = 0
	alpha = 0
	is_boardable = 0
	mouse_opacity = 0

/obj/effect/overmap/ship/unscDoO
	occupy_range = 2
	has_external_dropship_points = 0
	alpha = 0
	is_boardable = 0
	mouse_opacity = 0
