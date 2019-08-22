/obj/item/weapon/stock_parts/circuitboard/floodlight
	name = T_BOARD("emergency floodlight")
	build_path = /obj/machinery/floodlight
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 1)
	req_components = list(
		/obj/item/weapon/stock_parts/capacitor,
		/obj/item/stack/cable_coil = 10)
	additional_spawn_components = list(
		/obj/item/weapon/stock_parts/power/battery/buildable/crap,
		/obj/item/weapon/cell/crap = 1)