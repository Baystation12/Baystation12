#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/replicator
	name = T_BOARD("food replicator")
	build_path = /obj/machinery/food_replicator
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1)