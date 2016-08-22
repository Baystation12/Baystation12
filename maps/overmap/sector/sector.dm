/obj/effect/mapinfo/sector/test1
	name = "Test Sector #1"
	landing_area = /area/sector/shuttle/ingoing1
	obj_type = /obj/effect/map/sector/test1
	mapx = 8
	mapy = 8

/obj/effect/map/sector/test1
	name = "Test Sector #1"
	color = "#00FF00"

/obj/effect/mapinfo/sector/test2
	name = "Test Sector #2"
	landing_area = /area/sector/shuttle/ingoing2
	obj_type = /obj/effect/map/sector/test2
	mapx = 6
	mapy = 8

/obj/effect/map/sector/test2
	name = "Test Sector #2"
	color = "#FF0000"

/obj/machinery/computer/shuttle_control/explore/test2
	name = "abandoned pod console"
	shuttle_tag = "Exploration Pod"
	landing_type = /area/sector/shuttle/outgoing2

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

/area/sector/shuttle/outgoing2
	name = "\improper Exit Point #2"