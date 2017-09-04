#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/bluespacerelay
	name = T_BOARD("bluespacerelay")
	build_path = /obj/machinery/bluespacerelay
	board_type = "machine"
	origin_tech = list(TECH_BLUESPACE = 2, TECH_DATA = 2)
	req_components = list(
							/obj/item/stack/cable_coil = 30,
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/weapon/stock_parts/subspace/filter = 1,
							/obj/item/weapon/stock_parts/subspace/crystal = 1,
						  )