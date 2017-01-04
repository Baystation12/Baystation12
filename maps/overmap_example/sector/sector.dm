/obj/effect/overmap/sector/test1
	name = "Test Sector #1"
	color = "#00FF00"
	//landing_spots = list(/area/sector/shuttle/ingoing1,/area/sector/shuttle/ingoing3,/area/sector/shuttle/ingoing4) //TODO
	start_x = 8
	start_y = 8

/obj/effect/overmap/sector/test2
	name = "Test Sector #2"
	color = "#FF0000"
	//landing_areas = list(/area/sector/shuttle/ingoing2) //TODO
	start_x = 6
	start_y = 8

/obj/machinery/computer/shuttle_control/explore/test2
	name = "abandoned pod console"
	shuttle_tag = "Exploration Pod"
	//parking_spot = /area/sector/shuttle/outgoing2 //TODO

/area/sector/shuttle/
	name = "\improper Entry Point"
	icon_state = "tcomsatcham"
	requires_power = 0
	luminosity = 1
	lighting_use_dynamic = 0

/area/sector/shuttle/ingoing1
	name = "\improper Entry Point #1"

/area/sector/shuttle/ingoing2
	name = "\improper Entry Point #2"

/area/sector/shuttle/ingoing3
	name = "\improper Entry Point #3"

/area/sector/shuttle/ingoing4
	name = "\improper Entry Point #4"

/area/sector/shuttle/outgoing2
	name = "\improper Exit Point #2"