/obj/effect/overmap/ship/unscDoO
	name = "UNSC Difference Of Opinion"
	desc = "Halberd Class Destroyer."

	icon = 'halberdclass_new.dmi'
	icon_state = "ship"
	fore_dir = WEST
	vessel_mass = 4
	faction = "UNSC"
	flagship = 1

	occupy_range = 14

	map_bounds = list(24,98,115,52)// Format: "location" = list(TOP_LEFT_X,TOP_LEFT_Y,BOTTOM_RIGHT_X,BOTTOM_RIGHT_Y)

	parent_area_type = /area/unscDoO

	ship_max_speed = SHIP_DEFAULT_PIXEL_SPEED - 1

/obj/machinery/button/toggle/alarm_button/unsc_DoO
	area_base = /area/unscDoO