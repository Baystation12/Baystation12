/obj/overmap/visitable/ship/landable/sfc_wolfe
	name = "SFC Wolfe"
	desc = "A small CV-57 Boarding Craft, broadcasting SCGF codes and the callsign 'Tempe Terra-1 Wolfe'."
	shuttle = "SFC Wolfe"
	fore_dir = WEST
	color = "#d4ad00"
	vessel_mass = 750
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/ship/helm/tempeterra
	req_access = list("ACCESS_TORCH")

/obj/machinery/computer/shuttle_control/explore/sfc_wolfe
	name = "landing control console"
	shuttle_tag = "SFC Wolfe"

/obj/shuttle_landmark/sfc_wolfe
	name = "TempeTerra Hangar"
	landmark_tag = "nav_hangar_tempeterra"
	base_area = /area/tempeterra/hangar
	base_turf = /turf/simulated/floor/plating

/obj/shuttle_landmark/transit/sfc_wolfe
	name = "In transit"
	landmark_tag = "nav_transit_sfc_wolfe"

/obj/shuttle_landmark/tempeterra/generic
	name = "Dock One"
	landmark_tag = "nav_tempeterra_one"

/obj/shuttle_landmark/tempeterra/generic/two
	name = "Dock Two"
	landmark_tag = "nav_tempeterra_two"

/obj/shuttle_landmark/tempeterra/generic/three
	name = "Dock Three"
	landmark_tag = "nav_tempeterra_three"

/obj/shuttle_landmark/tempeterra/generic/four
	name = "Dock Four"
	landmark_tag = "nav_tempeterra_four"

/obj/shuttle_landmark/tempeterra/generic/five
	name = "Dock Five"
	landmark_tag = "nav_tempeterra_five"

/obj/shuttle_landmark/tempeterra/generic/six
	name = "Dock Six"
	landmark_tag = "nav_tempeterra_six"
