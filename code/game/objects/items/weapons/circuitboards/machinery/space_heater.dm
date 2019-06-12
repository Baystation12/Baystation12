/obj/item/weapon/stock_parts/circuitboard/space_heater
	name = T_BOARD("space_heater")
	board_type = "machine"
	build_path = /obj/machinery/space_heater
	origin_tech = list(TECH_ENGINEERING = 2, TECH_POWER = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 2,
							/obj/item/weapon/stock_parts/micro_laser = 2,
							/obj/item/stack/cable_coil = 20,
							/obj/item/weapon/cell = 1)