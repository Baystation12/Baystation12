
/obj/item/weapon/circuitboard/recharger
	name = T_BOARD("recharger")
	build_path = /obj/machinery/recharger
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_ENERGY = 3)
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stack/material/glass = 5,
		/obj/item/stack/material/gold = 5,
		/obj/item/weapon/stock_parts/capacitor = 1,
		/obj/item/weapon/stock_parts/micro_laser = 1)

/obj/item/weapon/circuitboard/cell_charger
	name = T_BOARD("cell charger")
	build_path = /obj/machinery/cell_charger
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_ENERGY = 3)
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stack/material/glass = 5,
		/obj/item/stack/material/gold = 5,
		/obj/item/weapon/stock_parts/capacitor = 1,
		/obj/item/weapon/stock_parts/micro_laser = 1)
