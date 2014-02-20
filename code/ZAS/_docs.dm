/*

Zone Air System:

This air system divides the station into impermeable areas called zones.
When something happens, i.e. a door opening or a wall being taken down,
zones equalize and eventually merge. Making an airtight area closes the connection again.

Important Functions:

air_master.mark_for_update(turf)
	When stuff happens, call this. It works on everything.

*/

#define AIR_BLOCKED 1
#define ZONE_BLOCKED 2
#define BLOCKED 3