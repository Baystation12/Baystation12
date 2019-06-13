obj/item/weapon/stock_parts/circuitboard/pipe_dispenser
	name = T_BOARD("pipe dispenser")
	build_path = /obj/machinery/pipedispenser
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 5, TECH_MATERIAL = 5, TECH_DATA = 3)
	req_components = list (
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/pipe = 3)

obj/item/weapon/stock_parts/circuitboard/pipe_dispenser/disposal
	name = T_BOARD("disposal pipe dispenser")
	build_path = /obj/machinery/pipedispenser/disposal