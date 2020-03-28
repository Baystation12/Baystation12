/obj/effect/overmap/ship/unsclightbrigade
	name = "UNSC Light Brigade"
	desc = "Halberd Class Destroyer."

	icon = 'halberdclass_new.dmi'
	icon_state = "ship"
	fore_dir = WEST
	vessel_mass = 4
	faction = "UNSC"
	flagship = 1

	map_bounds = list(24,98,115,52)// Format: "location" = list(TOP_LEFT_X,TOP_LEFT_Y,BOTTOM_RIGHT_X,BOTTOM_RIGHT_Y)

	parent_area_type = /area/destroyer/unsclightbrigade

	ship_max_speed = 2

/obj/machinery/button/toggle/alarm_button/destroyer
	area_base = /area/destroyer/unsclightbrigade
