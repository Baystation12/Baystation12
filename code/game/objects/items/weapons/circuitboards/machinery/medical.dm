#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/optable
	name = T_BOARD("operating table")
	build_path = /obj/machinery/optable
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 1, TECH_BIO = 3, TECH_DATA = 3)
	req_components = list(
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/weapon/stock_parts/capacitor  = 1)

obj/item/weapon/circuitboard/bodyscanner
	name = T_BOARD("body scanner")
	build_path = /obj/machinery/bodyscanner
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 2, TECH_BIO = 4, TECH_DATA = 4)
	req_components = list(
							/obj/item/weapon/stock_parts/scanning_module = 2,
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/weapon/stock_parts/console_screen = 1)

obj/item/weapon/circuitboard/body_scanconsole
	name = T_BOARD("body scanner console")
	build_path = /obj/machinery/body_scanconsole
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 2, TECH_BIO = 4, TECH_DATA = 4)
	req_components = list(
							/obj/item/weapon/stock_parts/console_screen = 1)

obj/item/weapon/circuitboard/sleeper
	name = T_BOARD("sleeper")
	build_path = /obj/machinery/sleeper
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 3, TECH_BIO = 5, TECH_DATA = 3)
	req_components = list (
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/reagent_containers/syringe = 2,
							/obj/item/weapon/reagent_containers/glass/beaker/large = 1)

obj/item/weapon/circuitboard/cryo_cell
	name = T_BOARD("cryo cell")
	build_path = /obj/machinery/atmospherics/unary/cryo_cell
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 4, TECH_BIO = 6, TECH_DATA = 3)
	req_components = list (
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/pipe = 1)