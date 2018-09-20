#if !defined(using_map_DATUM)

	#include "unsc_frigate_base_includes.dm"

	#include "unsc_frigate_spawndefs.dm"

	#include "../first_contact/overall_overmap.dm"

	#include "../first_contact/maps//UNSC_Bertels/jobs.dm"
	#include "../first_contact/maps//UNSC_Bertels/outfits.dm"
	#include "../first_contact/maps//UNSC_Bertels/spawns_jobs.dm"

	#define using_map_DATUM /datum/map/unsc_frigate

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring UNSC frigate

#endif
