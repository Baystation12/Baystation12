#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it! 
#endif

/obj/item/weapon/stock_parts/circuitboard/biogenerator
	name = T_BOARD("biogenerator")
	build_path = /obj/machinery/biogenerator
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/manipulator = 1)

/obj/item/weapon/stock_parts/circuitboard/bio_editor
	name = T_BOARD("biogenerator")
	build_path = /obj/machinery/botany/editor
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/scanning_module = 2)

/obj/item/weapon/stock_parts/circuitboard/bio_extractor
	name = T_BOARD("biogenerator")
	build_path = /obj/machinery/botany/extractor
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/weapon/stock_parts/scanning_module = 1)