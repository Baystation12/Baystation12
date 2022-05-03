/obj/item/stock_parts/circuitboard/mineral_processing
	name = T_BOARD("mineral processing console")
	build_path = /obj/machinery/computer/mining
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)

/obj/item/stock_parts/circuitboard/mining_processor
	name = T_BOARD("ore processor")
	build_path = /obj/machinery/mineral/processing_unit
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	req_components = list(
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 2
		)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/mining_unloader
	name = T_BOARD("unloading machine")
	build_path = /obj/machinery/mineral/unloading_machine
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	req_components = list(
		/obj/item/stock_parts/manipulator = 2
		)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/mining_stacker
	name = T_BOARD("stacking machine")
	build_path = /obj/machinery/mineral/stacking_machine
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1
		)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)