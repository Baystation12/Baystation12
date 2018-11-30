#if !defined(using_map_DATUM)

	#include "overall_overmap.dm"

	#include "../first_contact/maps/Exoplanet Research/includes.dm"

	#include "../first_contact/maps/UNSC_Prowler/includes.dm"

	#include "../first_contact/maps/Exoplanet Icy/includes.dm"

	#include "../first_contact/maps/Admin Planet/includes.dm"

	#include "../overmap_ships/nh_overmap.dm"
	#include "../overmap_ships/om_ship_areas.dm"

	#include "../first_contact/maps/UNSC_Bertels/includes.dm"

	#include "../first_contact/maps/URF Commando Ship/includes.dm"

	#include "../first_contact/maps/Asteroid Listening Post/includes.dm"

	#include "../first_contact/maps/UNSC_Thorin/includes.dm"

	#include "../first_contact/maps/Covenant Corvette/includes.dm"

	#include "maps/ccv_star_spawns.dm"
	#include "maps/CCV_Star.dmm"

	#include "maps/comet_spawns.dm"


	#include "maps/sbs_spawns.dm"
	#include "maps/CCV_Slow_But_Steady.dmm"

	#include "maps/ccv_deliverance_spawns.dm"
	#include "maps/CCV_Deliverance.dmm"


	#include "overall_outfits.dm"
	#include "overall_jobdefs.dm"
	#include "mapdef.dm"

	#include "../../code/modules/halo/lobby_music/odst_music.dm"
	#include "../../code/modules/halo/lobby_music/halo_music.dm"

	#define using_map_DATUM /datum/map/first_contact

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Scenario: First Contact

#endif
