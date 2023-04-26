/obj/item/stock_parts/circuitboard/microwave
	name = "circuit board (microwave)"
	build_path = /obj/machinery/microwave
	board_type = "machine"
	origin_tech = list(TECH_BIO = 2, TECH_ENGINEERING = 2)
	req_components = list(
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/matter_bin = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/gibber
	name = "circuit board (meat gibber)"
	build_path = /obj/machinery/gibber
	board_type = "machine"
	origin_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2)
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/material/knife/kitchen/cleaver = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/cooker
	name = "circuit board (candy machine)"
	build_path = /obj/machinery/cooker/candy
	board_type = "machine"
	origin_tech = list(TECH_BIO = 1, TECH_MATERIAL = 1)
	buildtype_select = TRUE
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stack/cable_coil = 10)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/cooker/get_buildable_types()
	return subtypesof(/obj/machinery/cooker)

/obj/item/stock_parts/circuitboard/honey
	name = "circuit board (honey extractor)"
	build_path = /obj/machinery/honey_extractor
	board_type = "machine"
	origin_tech = list(TECH_BIO = 2, TECH_ENGINEERING = 1)
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/matter_bin = 2)

/obj/item/stock_parts/circuitboard/honey/seed
	name = "circuit board (seed extractor)"
	build_path = /obj/machinery/seed_extractor
	board_type = "machine"

/obj/item/stock_parts/circuitboard/washer
	name = "circuit board (washing machine)"
	build_path = /obj/machinery/washing_machine
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 1)
	req_components = list(
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/pipe = 1)

/obj/item/stock_parts/circuitboard/vending
	name = "circuit board (vending machine)"
	build_path = /obj/machinery/vending/generic
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 2)
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)
	buildtype_select = TRUE

/obj/item/stock_parts/circuitboard/vending/get_buildable_types()
	. = list()
	for(var/path in typesof(/obj/machinery/vending))
		var/obj/machinery/vending/vendor = path
		var/base_type = initial(vendor.base_type) || path
		. |= base_type

/obj/item/stock_parts/circuitboard/shipmap
	name = "circuit board (ship holomap)"
	board_type = "machine"
	build_path = /obj/machinery/ship_map
	origin_tech = list(TECH_ENGINEERING = 1)
	req_components = list()
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)
