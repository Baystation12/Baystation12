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

	#include "../first_contact/maps/UNSC_Bertels/includes.dm"

	#include "../first_contact/maps/URF Commando Ship/includes.dm"

	#include "../first_contact/maps/Asteroid Listening Post/includes.dm"

	#include "../first_contact/maps/UNSC_Thorin/includes.dm"

	#include "../first_contact/maps/Covenant Corvette/includes.dm"

	#include "maps/innie_crew_jobs.dm"
	#include "maps/innie_crew_spawns.dm"
	#include "maps/odst_crew_jobs.dm"
	#include "maps/civ_crew_jobs.dm"
	#include "maps/civ_crew_spawns.dm"
	#include "maps/medic_crew_jobs.dm"
	#include "maps/medic_crew_spawns.dm"

	#include "../overmap_ships/CCV_Comet.dm"
	#include "maps/CCV_Comet.dmm"
	#include "../overmap_ships/CCV_Deliverance.dm"
	#include "maps/CCV_Deliverance.dmm"
	#include "../overmap_ships/CCV_Slow_But_Steady.dm"
	#include "maps/CCV_Slow_But_Steady.dmm"
	#include "../overmap_ships/CCV_Star.dm"
	#include "maps/CCV_Star.dmm"

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
