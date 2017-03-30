#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif
/obj/item/weapon/circuitboard/bioprinter
	name = T_BOARD("bioprinter")
	build_path = /obj/machinery/organ_printer/flesh
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 1, TECH_BIO = 3, TECH_DATA = 3)
	req_components = list(
							/obj/item/device/healthanalyzer = 1,
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/weapon/stock_parts/manipulator = 2,
							)

/obj/item/weapon/circuitboard/roboprinter
	name = T_BOARD("prosthetic organ fabricator")
	build_path = /obj/machinery/organ_printer/robot
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/weapon/stock_parts/manipulator = 2,
							)