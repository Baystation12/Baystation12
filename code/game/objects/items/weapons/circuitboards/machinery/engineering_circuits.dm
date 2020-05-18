/obj/item/weapon/stock_parts/circuitboard/floodlight
	name = T_BOARD("emergency floodlight")
	build_path = /obj/machinery/floodlight
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 1)
	req_components = list(
		/obj/item/stack/cable_coil = 10)
	additional_spawn_components = list(
		/obj/item/weapon/stock_parts/capacitor = 1,
		/obj/item/weapon/stock_parts/power/battery/buildable/crap = 1,
		/obj/item/weapon/cell/crap = 1)

/obj/item/weapon/stock_parts/circuitboard/pipedispensor
	name = T_BOARD("pipe dispenser")
	build_path = /obj/machinery/pipedispenser
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 6, TECH_MATERIAL = 5)
	req_components = list(
		/obj/item/weapon/stock_parts/manipulator = 1,
		/obj/item/weapon/stock_parts/matter_bin = 2,
		/obj/item/weapon/rcd_ammo/large = 2)
	additional_spawn_components = list(
		/obj/item/weapon/stock_parts/keyboard = 1,
		/obj/item/weapon/stock_parts/power/apc/buildable = 1)

/obj/item/weapon/stock_parts/circuitboard/pipedispensor/disposal
	name = T_BOARD("disposal pipe dispenser")
	build_path = /obj/machinery/pipedispenser/disposal