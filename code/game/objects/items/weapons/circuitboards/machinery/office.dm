/obj/item/weapon/stock_parts/circuitboard/shredder
	name = T_BOARD("paper shredder")
	build_path = /obj/machinery/papershredder
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	req_components = list(
		/obj/item/weapon/stock_parts/manipulator = 1,
		/obj/item/weapon/stock_parts/micro_laser = 1,
		/obj/item/weapon/stock_parts/matter_bin = 1)

/obj/item/weapon/stock_parts/circuitboard/shredder/copier
	name = T_BOARD("photocopier")
	build_path = /obj/machinery/photocopier
	req_components = list(
		/obj/item/weapon/stock_parts/manipulator = 1,
		/obj/item/weapon/stock_parts/micro_laser = 1,
		/obj/item/weapon/stock_parts/matter_bin = 1,
		/obj/item/weapon/stock_parts/scanning_module = 1)

/obj/item/weapon/stock_parts/circuitboard/shredder/fax
	name = T_BOARD("fax machine")
	build_path = /obj/machinery/photocopier/faxmachine
	origin_tech = list(TECH_DATA = 7, TECH_BLUESPACE = 7)
	req_components = list(
		/obj/item/weapon/stock_parts/manipulator = 1,
		/obj/item/weapon/stock_parts/micro_laser = 1,
		/obj/item/weapon/stock_parts/matter_bin = 1,
		/obj/item/weapon/stock_parts/subspace/transmitter = 1)

/obj/item/weapon/stock_parts/circuitboard/shredder/binder
	name = T_BOARD("book binder")
	build_path = /obj/machinery/bookbinder

/obj/item/weapon/stock_parts/circuitboard/shredder/library
	name = T_BOARD("library scanner")
	build_path = /obj/machinery/libraryscanner
	req_components = list(
		/obj/item/weapon/stock_parts/manipulator = 1,
		/obj/item/weapon/stock_parts/micro_laser = 1,
		/obj/item/weapon/stock_parts/matter_bin = 1,
		/obj/item/weapon/stock_parts/scanning_module = 1)