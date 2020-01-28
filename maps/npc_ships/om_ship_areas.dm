/////////////////
//OVERMAP SHIPS//
/////////////////

#include "_om_ship_areas_definition.dm"

/area/om_ships/hauler
	name = "Haul4U"

/area/om_ships/Elivagar
	name = "CMV Elivagar"

/area/om_ships/unscpatrol
	name = "UNSC Patrol Vessel"
	requires_power = 0

/area/om_ships/covpatrol
	name = "Covenant Patrol Vessel"
	requires_power = 0

/area/om_ships/star
	name = "CCV Star"

/area/om_ships/caelum
	name = "CCV Slow But Steady"
	has_gravity = 0


/area/om_ships/deliverance
	name = "CCV Deliverance"

/area/om_ships/comet
	name = "CCV Comet"

/area/om_ships/hum_ert
	name = "Human ERT Vessel"
	requires_power = 0

/area/om_ships/cov_ert
	name = "Covenant ERT Vessel"
	requires_power = 0

/area/om_ships/comms_station
	name = "Communications Station"
	icon_state = "red"
	requires_power = 0
	has_gravity = 1

/area/om_ships/comms_station/station1
	base_turf = /turf/simulated/floor/asteroid

/area/om_ships/req_console_ship
	name = "Ship"
