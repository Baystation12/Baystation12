/obj/item/weapon/stock_parts/circuitboard/shuttle_sensor
	name = T_BOARD("ship sensors")
	board_type = "machine"
	build_path = /obj/machinery/shipsensors
	origin_tech = list(TECH_MAGNET = 5, TECH_DATA = 5, TECH_BLUESPACE = 4)
	req_components = list(
							/obj/item/weapon/stock_parts/scanning_module = 3,
							/obj/item/weapon/stock_parts/subspace/analyzer = 1,
							/obj/item/weapon/stock_parts/capacitor = 1)

/obj/item/weapon/stock_parts/circuitboard/shuttle_sensor/weak
	name = T_BOARD("weak ship sensors")
	board_type = "machine"
	build_path = /obj/machinery/shipsensors/weak
	origin_tech = list(TECH_MAGNET = 3, TECH_DATA = 3)