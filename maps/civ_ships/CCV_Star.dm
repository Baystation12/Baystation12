
#include "_om_ship_areas_definition.dm"

/obj/effect/overmap/ship/CCV_star
	name = "Civilian Vessel"
	desc = "A Civilian vessel with a traditional cargo-hauler design."

	icon = 'maps/first_contact/freighter.dmi'
	icon_state = "ship"
	fore_dir = WEST
	vessel_mass = 5


	map_bounds = list(102,160,154,117) //Aah standardised designs.

/area/om_ships/star
	name = "CCV Star"
