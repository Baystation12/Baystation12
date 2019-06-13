/obj/item/weapon/stock_parts/circuitboard/washer
	name = T_BOARD("washing machine")
	build_path = /obj/machinery/washing_machine
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	req_components = list(
		/obj/item/weapon/stock_parts/manipulator = 1,
		/obj/item/weapon/stock_parts/micro_laser = 1,
		/obj/item/weapon/stock_parts/matter_bin = 1,
		/obj/item/pipe = 1)

/obj/item/weapon/stock_parts/circuitboard/microwave
	name = T_BOARD("washing machine")
	build_path = /obj/machinery/microwave
	board_type = "machine"
	origin_tech = list(TECH_BIO = 2, TECH_ENGINEERING = 2)
	req_components = list(
		/obj/item/weapon/stock_parts/manipulator = 1,
		/obj/item/weapon/stock_parts/micro_laser = 2,
		/obj/item/weapon/stock_parts/matter_bin = 1)

/obj/item/weapon/stock_parts/circuitboard/gibber
	name = T_BOARD("meat gibber")
	build_path = /obj/machinery/gibber
	board_type = "machine"
	origin_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2)
	req_components = list(
		/obj/item/weapon/stock_parts/manipulator = 2,
		/obj/item/weapon/stock_parts/matter_bin = 1,
		/obj/item/weapon/material/knife/kitchen/cleaver = 1)

/obj/item/weapon/stock_parts/circuitboard/cooker
	name = T_BOARD("candy machine")
	build_path = /obj/machinery/cooker/candy
	board_type = "machine"
	origin_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2)
	req_components = list(
		/obj/item/weapon/stock_parts/manipulator = 2,
		/obj/item/weapon/stock_parts/matter_bin = 1,
		/obj/item/stack/cable_coil = 10)

/obj/item/weapon/stock_parts/circuitboard/cooker/cereal
	name = T_BOARD("cereal maker")
	build_path = /obj/machinery/cooker/cereal

/obj/item/weapon/stock_parts/circuitboard/cooker/fryer
	name = T_BOARD("deep fryer")
	build_path = /obj/machinery/cooker/fryer

/obj/item/weapon/stock_parts/circuitboard/cooker/oven
	name = T_BOARD("oven")
	build_path = /obj/machinery/cooker/oven

/obj/item/weapon/stock_parts/circuitboard/cooker/grill
	name = T_BOARD("griddle")
	build_path = /obj/machinery/cooker/grill