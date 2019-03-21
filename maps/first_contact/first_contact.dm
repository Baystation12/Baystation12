#if !defined(using_map_DATUM)

	#include "../first_contact/maps/faction_bases/base_areas.dm"

	#include "../first_contact/maps/faction_bases/faction_spawns.dm"

	#include "../first_contact/maps/faction_bases/Covenant_Station.dmm"

	#include "../first_contact/maps/faction_bases/Human_Station_1.dmm"

	#include "../first_contact/maps/faction_bases/Human_Station_2.dmm"

	#include "../first_contact/maps/faction_bases/Innie_Base.dmm"

	#include "../first_contact/maps/Exoplanet Research/includes.dm"

	#include "../first_contact/maps/Exoplanet Icy/includes.dm"

	#include "../first_contact/maps/Admin Planet/includes.dm"

	#include "../first_contact/maps/UNSC_Heaven_Above/unsc_frigate_base_includes.dm"

	#include "../first_contact/maps/URF Commando Ship/includes.dm"

	#include "../first_contact/maps/Asteroid Listening Post/includes.dm"

	#include "../first_contact/maps/UNSC_Thorin/includes.dm"

	#include "../first_contact/maps/Covenant Corvette/includes.dm"

	#include "../first_contact/maps/kig_yar_pirates/includes.dm"

	#include "maps/innie_crew_jobs.dm"
	#include "maps/innie_crew_spawns.dm"
	#include "maps/odst_crew_jobs.dm"

	#include "overall_outfits.dm"
	#include "overall_jobdefs.dm"
	#include "mapdef.dm"

	#include "../../code/modules/halo/lobby_music/odst_music.dm"
	#include "../../code/modules/halo/lobby_music/halo_music.dm"

	#include "../_gamemodes/invasion/invasion.dm"

	#define using_map_DATUM /datum/map/first_contact

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Scenario: First Contact

#endif
