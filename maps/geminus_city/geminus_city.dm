#if !defined(using_map_DATUM)

	#define using_map_DATUM /datum/map/geminus_city

	#include "areas.dm"

	#include "geminus_city_overmap.dm"
	#include "geminus_city_map.dm"

	/*
	#include "innie_quest/transport_area.dm"
	#include "innie_quest/computer_comms.dm"
	#include "innie_quest/computer_shuttle.dm"
	#include "innie_quest/file_comms.dm"
	#include "innie_quest/file_coord.dm"
	#include "innie_quest/program_comms.dm"
	#include "innie_quest/program_shuttle.dm"
	#include "innie_quest/transport_shuttle.dm"

	#include "innie_supply/supply_area.dm"
	#include "innie_supply/computer.dm"
	#include "innie_supply/supply_program.dm"
	#include "innie_supply/supply_shuttle.dm"
	*/

	#include "../../code/modules/halo/supply/unsc.dm"
	#include "../../code/modules/halo/supply/oni.dm"
	#include "../../code/modules/halo/supply/covenant.dm"

	//#include "geminus_city_jobdefs.dm"
	#include "ai_items.dm"
	#include "invasion_geminus.dm"

	//#include "geminuscity_4.dmm"
	#include "geminuscity_3.dmm"
	#include "geminuscity_2.dmm"
	#include "geminuscity_1.dmm"

	#include "../faction_bases/complex046/complex046.dm"

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring GeminusCity

#endif
