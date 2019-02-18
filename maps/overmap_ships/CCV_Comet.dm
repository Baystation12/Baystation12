
#include "_om_ship_areas_definition.dm"

/area/om_ships/comet
	name = "CCV Comet"

/area/om_ships/comet/cometrockets
	name = "CCV Comet - Rocket Pods"

/obj/machinery/overmap_weapon_console/deck_gun_control/local/comet
	deck_gun_area = /area/om_ships/comet

/obj/machinery/overmap_weapon_console/deck_gun_control/local/missile_control/comet
	deck_gun_area = /area/om_ships/comet/cometrockets
