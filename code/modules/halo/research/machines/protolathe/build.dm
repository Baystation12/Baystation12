
/obj/item/weapon/circuitboard/protolathe
	name = T_BOARD("protolathe")
	build_path = /obj/machinery/research/protolathe
	board_type = "machine"
	origin_tech = list(TECH_DATA = 4)
	req_components = list(
		/obj/item/stack/material/glass = 20,
		/obj/item/stack/material/plastic = 5,
		/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/circuit_printer
	name = T_BOARD("circuit imprinter")
	build_path = /obj/machinery/research/protolathe/circuits
	board_type = "machine"
	origin_tech = list(TECH_DATA = 4)
	req_components = list(
		/obj/item/stack/material/glass = 20,
		/obj/item/stack/material/plastic = 5,
		/obj/item/weapon/stock_parts/console_screen = 1)
