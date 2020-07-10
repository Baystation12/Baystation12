/obj/machinery/research/destructive_analyzer
	circuit_type = /obj/item/weapon/circuitboard/destructor

/obj/item/weapon/circuitboard/destructor
	name = T_BOARD("destructive analyzer")
	build_path = /obj/machinery/research/destructive_analyzer
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3)
	req_components = list(
		/obj/item/stack/material/glass = 10,
		/obj/item/stack/material/plastic = 1,
		/obj/item/weapon/stock_parts/scanning_module = 1,
		/obj/item/weapon/stock_parts/micro_laser = 2)
