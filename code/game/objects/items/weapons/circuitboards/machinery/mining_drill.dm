#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it! 
#endif

/obj/item/weapon/circuitboard/miningdrill
	name = T_BOARD("mining drill head")
	build_path = "/obj/machinery/mining/drill"
	board_type = "machine"
	origin_tech = "programming=1;engineering=1"
	frame_desc = "Requires 1 capacitor, 1 cell, 1 matter bin, and 1 micro laser."
	req_components = list(
							"/obj/item/weapon/stock_parts/capacitor" = 1,
							"/obj/item/weapon/cell" = 1,
							"/obj/item/weapon/stock_parts/matter_bin" = 1,
							"/obj/item/weapon/stock_parts/micro_laser" = 1)