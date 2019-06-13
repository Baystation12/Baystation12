obj/item/weapon/stock_parts/circuitboard/forensics
	name = T_BOARD("DNA analyzer")
	build_path = /obj/machinery/dnaforensics
	board_type = "machine"
	origin_tech = list(TECH_BIO = 3, TECH_DATA = 3)
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/stock_parts/scanning_module = 2,
							/obj/item/weapon/forensics/sample_kit = 1)

obj/item/weapon/stock_parts/circuitboard/microscope
	name = T_BOARD("microscope")
	build_path = /obj/machinery/microscope
	board_type = "machine"
	origin_tech = list(TECH_BIO = 3, TECH_DATA = 3)
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/stock_parts/scanning_module = 2,
							/obj/item/weapon/evidencebag = 1)