#include "northstar_area.dm"

/datum/map_template/ruin/away_site/northstar
	name = "Maxim Interplanar Layover"
	id = "northstar"
	description = "Considered a standout in recent Solar-Gilgameshi relations. Joint Station Northstar, as dubbed by the Solar Assembly - and Krasnyy-Balise by the Gilgameshi rests atop Maxim's World. It is transmitting a unique free-for-all IDENT-tag 'MIL-14b'."
	suffixes = list("maps/event/e14b_station/northstar-1.dmm", "maps/event/e14b_station/northstar-2.dmm")
	spawn_cost = 1

	apc_test_exempt_areas = list(
		/area/northstar = NO_SCRUBBER|NO_VENT
	)

	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/obj/overmap/visitable/sector/northstar
	name = "Maxim Interplanar Layover"
	desc = "Combined SCG-GCC joint transit base which leads to Maxim's World via shuttles. It is transmitting unique free-for-all IDENT-tags, 'MIL-14b'."
	icon_state = "northstar"
	hide_from_reports = FALSE
	scannable = TRUE
	sensor_visibility = 15

// Areas

/area/northstar
	icon = 'maps/event/e14b_station/northstar.dmi'
	req_access = list("ACCESS_TORCH")


// Deck One
/area/northstar/deckone
	name = "Maxim Interplanar Deck One"
	icon_state = "d1"


// Deck Two
/area/northstar/decktwo
	name = "Maxim Interplanar Deck Two"
	icon_state = "d2"


// Deck Three
/area/northstar/deckthree
	name = "Maxim Interplanar Deck Three"
	icon_state = "d3"
