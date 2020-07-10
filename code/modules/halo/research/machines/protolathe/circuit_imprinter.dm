
/obj/machinery/research/protolathe/circuits
	name = "\improper circuit imprinter"
	icon_state = "circuit_imprinter"
	state_base = "circuit_imprinter"
	design_build_flag = IMPRINTER
	circuit_type = /obj/item/weapon/circuitboard/circuit_printer

/obj/item/weapon/circuitboard/circuit_printer
	name = T_BOARD("circuit imprinter")
	build_path = /obj/machinery/research/protolathe/circuits
	board_type = "machine"
	origin_tech = list(TECH_DATA = 4)
	req_components = list(
		/obj/item/stack/material/glass = 20,
		/obj/item/stack/material/plastic = 5,
		/obj/item/weapon/stock_parts/console_screen = 1)
