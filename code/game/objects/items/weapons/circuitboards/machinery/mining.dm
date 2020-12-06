#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/mineral_processing
	name = T_BOARD("mineral processing console")
	build_path = /obj/machinery/computer/mining
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)

/obj/item/weapon/circuitboard/mining_processor
	name = T_BOARD("ore processor")
	build_path = /obj/machinery/mineral/processing_unit
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	req_components = list(
		/obj/item/weapon/stock_parts/manipulator = 1,
		/obj/item/weapon/stock_parts/micro_laser = 2
		)

/obj/item/weapon/circuitboard/mining_unloader
	name = T_BOARD("unloading machine")
	build_path = /obj/machinery/mineral/unloading_machine
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	req_components = list(
		/obj/item/weapon/stock_parts/manipulator = 2
		)

/obj/item/weapon/circuitboard/mining_stacker
	name = T_BOARD("stacking machine")
	build_path = /obj/machinery/mineral/stacking_machine
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	req_components = list(
		/obj/item/weapon/stock_parts/matter_bin = 1,
		/obj/item/weapon/stock_parts/manipulator = 1
		)