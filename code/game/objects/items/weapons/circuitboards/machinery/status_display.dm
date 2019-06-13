/obj/item/weapon/stock_parts/circuitboard/status_display
	name = T_BOARD("status display")
	board_type = "machine"
	build_path = /obj/machinery/status_display
	origin_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/stack/cable_coil = 5)

/obj/item/weapon/stock_parts/circuitboard/status_display/supply
	name = T_BOARD("supply status display")
	board_type = "machine"
	build_path = /obj/machinery/status_display/supply_display