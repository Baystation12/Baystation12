/obj/item/stock_parts/circuitboard/optable
	name = T_BOARD("operating table")
	build_path = /obj/machinery/optable
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 1, TECH_BIO = 3, TECH_DATA = 3)
	req_components = list(
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/capacitor  = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/bodyscanner
	name = T_BOARD("body scanner")
	build_path = /obj/machinery/bodyscanner
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 2, TECH_BIO = 4, TECH_DATA = 4)
	req_components = list(
		/obj/item/stock_parts/scanning_module = 2,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/console_screen = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/body_scanconsole
	name = T_BOARD("body scanner console")
	build_path = /obj/machinery/body_scanconsole
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 2, TECH_BIO = 4, TECH_DATA = 4)
	req_components = list(
		/obj/item/stock_parts/console_screen = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/body_scanconsole/display
	name = T_BOARD("body scanner display")
	build_path = /obj/machinery/body_scan_display
	origin_tech = list(TECH_BIO = 2, TECH_DATA = 2)

/obj/item/stock_parts/circuitboard/sleeper
	name = T_BOARD("sleeper")
	build_path = /obj/machinery/sleeper
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 3, TECH_BIO = 5, TECH_DATA = 3)
	req_components = list (
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/reagent_containers/syringe = 2)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/cryo_cell
	name = T_BOARD("cryo cell")
	build_path = /obj/machinery/atmospherics/unary/cryo_cell
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 4, TECH_BIO = 6, TECH_DATA = 3)
	req_components = list (
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/pipe = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)