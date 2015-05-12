#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it! 
#endif

/obj/item/weapon/circuitboard/clonepod
	name = T_BOARD("clone pod")
	build_path = "/obj/machinery/clonepod"
	board_type = "machine"
	origin_tech = "programming=3;biotech=3"
	req_components = list(
							"/obj/item/stack/cable_coil" = 2,
							"/obj/item/weapon/stock_parts/scanning_module" = 2,
							"/obj/item/weapon/stock_parts/manipulator" = 2,
							"/obj/item/weapon/stock_parts/console_screen" = 1)

/obj/item/weapon/circuitboard/clonescanner
	name = T_BOARD("cloning scanner")
	build_path = "/obj/machinery/dna_scannernew"
	board_type = "machine"
	origin_tech = "programming=2;biotech=2"
	req_components = list(
							"/obj/item/weapon/stock_parts/scanning_module" = 1,
							"/obj/item/weapon/stock_parts/manipulator" = 1,
							"/obj/item/weapon/stock_parts/micro_laser" = 1,
							"/obj/item/weapon/stock_parts/console_screen" = 1,
							"/obj/item/stack/cable_coil" = 2)
