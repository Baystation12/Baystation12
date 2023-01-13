/obj/item/stock_parts/circuitboard/gravgen
	name = T_BOARD("gravitational generator")
	build_path = /obj/machinery/gravity_generator
	board_type = "machine"
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_MATERIAL = 3, TECH_BLUESPACE = 4)
	req_components = list(
		/obj/item/stock_parts/capacitor/adv = 6
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)
