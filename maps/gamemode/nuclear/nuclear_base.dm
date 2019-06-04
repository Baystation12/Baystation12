#include "nuclear_base_areas.dm"

/obj/effect/overmap/sector/nuclear_base
	name = "asteroid base"
	desc = "A large asteroid emitting faint traces of sub-space activity."
	icon_state = "meteor1"
	known = 0

/datum/map_template/gamemode_site/nuclear_base
	name = "asteroid base"
	id = "awaysite_nuclear_hideout"
	description = "Just another large asteroid."
	suffixes = list("nuclearn/nuclear_base.dmm")
