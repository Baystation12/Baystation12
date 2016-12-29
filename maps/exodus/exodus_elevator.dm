/obj/turbolift_map_holder/exodus
	icon = 'icons/obj/turbolift_preview_2x2.dmi'
	depth = 2
	lift_size_x = 3
	lift_size_y = 3

/obj/turbolift_map_holder/exodus/sec
	name = "Exodus turbolift map placeholder - Securiy"
	dir = EAST

	areas_to_use = list(
		/area/shuttle/turbolift/security_maintenance,
		/area/shuttle/turbolift/security_station
		)

/obj/turbolift_map_holder/exodus/research
	name = "Exodus turbolift map placeholder - Research"
	dir = WEST

	areas_to_use = list(
		/area/shuttle/turbolift/research_maintenance,
		/area/shuttle/turbolift/research_station
		)

/obj/turbolift_map_holder/exodus/engineering
	name = "Exodus turbolift map placeholder - Engineering"
	icon = 'icons/obj/turbolift_preview_3x3.dmi'
	dir = EAST
	lift_size_x = 4
	lift_size_y = 4

	areas_to_use = list(
		/area/shuttle/turbolift/engineering_maintenance,
		/area/shuttle/turbolift/engineering_station
		)

/obj/turbolift_map_holder/exodus/cargo
	name = "Exodus turbolift map placeholder - Cargo"

	areas_to_use = list(
		/area/shuttle/turbolift/cargo_maintenance,
		/area/shuttle/turbolift/cargo_station
		)
