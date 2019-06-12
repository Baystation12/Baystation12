/obj/item/weapon/stock_parts/circuitboard/suit_storage
	name = T_BOARD("suit storage unit")
	board_type = "machine"
	build_path = /obj/machinery/suit_storage_unit
	origin_tech = list(TECH_ENGINEERING = 5, TECH_MATERIAL = 3, TECH_MAGNET = 3)
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 2,
							/obj/item/weapon/stock_parts/micro_laser = 2,
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/stack/cable_coil = 10,
							/obj/item/pipe = 1)