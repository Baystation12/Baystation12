
#include "complex046_area.dm"
#include "complex046.dmm"

/obj/effect/overmap/complex046
	name = "Complex 046"
	icon = 'maps/faction_bases/complex046/complex046.dmi'
	icon_state = "oni"

//override this to use the ONI base
/datum/faction/unsc/find_objective_delivery_target()
	var/obj/effect/overmap/complex046/C = locate()
	if(C)
		return C
	return ..()
