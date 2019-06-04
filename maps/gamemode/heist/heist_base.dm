#include "heist_base_areas.dm"

/obj/effect/overmap/sector/heist_base
	name = "asteroid base"
	desc = "A large asteroid emitting faint traces of sub-space activity."
	icon_state = "meteor2"
	known = 0

/datum/map_template/gamemode_site/heist_base
	name = "asteroid base"
	id = "awaysite_heist_hideout"
	description = "Just another large asteroid."
	suffixes = list("heist/heist_base.dmm")
