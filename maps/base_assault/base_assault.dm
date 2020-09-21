
/datum/game_mode/base_assault
	name = "Base Assault"
	config_tag = "base_assault"
	round_description = "Assault a well-defended UNSC base."
	extended_round_description = "Assault a well defended UNSC base and plant a bomb."
	probability = 1
	ship_lockdown_duration = 10 MINUTES
	faction_balance = list(/datum/faction/covenant,/datum/faction/unsc)

/datum/game_mode/base_assault/pre_setup()
	. = ..()
	var/list/objective_types = list(\
		/datum/objective/overmap/covenant_ship,
		/datum/objective/overmap/covenant_odp,
		)
	GLOB.COVENANT.setup_faction_objectives(objective_types)
	GLOB.COVENANT.has_flagship = 1

	//setup unsc objectives
	objective_types = list(\
		/datum/objective/overmap/unsc_cov_ship,
		)
	GLOB.UNSC.setup_faction_objectives(objective_types)
	GLOB.UNSC.has_base = 1

/datum/game_mode/base_assault/check_finished()
	var/obj/base = GLOB.UNSC.get_base()
	if(!base | !base.loc)
		return 1
	base = GLOB.COVENANT.get_flagship()
	if(!base | !base.loc)
		return 1
	return 0

/datum/map/base_assault
	name = "UNSC Outpost"
	full_name = "111 Tauri System, UNSC Outpost"
	system_name = "111 Tauri"
	path = "base_assault"
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
	overmap_size= 10
	overmap_event_tokens = 1

	allowed_gamemodes = list("base_assault")
	map_admin_faxes = list("Ministry of Tranquility (General)","Ministry of Resolution (War Matters)","Ministry of Fervent Intercession (Internal Affairs)")


#if !defined(using_map_DATUM)

	#define using_map_DATUM /datum/map/base_assault

	#include "unit_tests.dm"

	#include "../npc_ships/om_ship_areas.dm"
	#include "../area_holders/overmap_ship_area_holder.dmm"

	#include "../Admin Planet/includes.dm"

	#include "../faction_bases/CassiusMoonStation/cassiusmoon.dm"

	#include "../CRS_Unyielding_Transgression/includes.dm"

	#include "../../code/modules/halo/lobby_music/odst_music.dm"
	#include "../../code/modules/halo/lobby_music/halo_music.dm"

	#include "../../code/modules/halo/supply/unsc.dm"
	#include "../../code/modules/halo/supply/oni.dm"
	#include "../../code/modules/halo/supply/covenant.dm"

	#include "../faction_bases/complex046/complex046.dm"

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Base Assault
#endif

//Spawn In Overrides//
/obj/effect/overmap/unsc_cassius_moon
	overmap_spawn_in_me = list(/obj/effect/overmap/complex046)