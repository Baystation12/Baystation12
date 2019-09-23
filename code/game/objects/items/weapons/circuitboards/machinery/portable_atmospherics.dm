/obj/item/weapon/stock_parts/circuitboard/portable_scrubber
	name = T_BOARD("portable scrubber")
	board_type = "machine"
	build_path = /obj/machinery/portable_atmospherics/powered/scrubber
	origin_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 4)
	req_components = list(
		/obj/item/weapon/stock_parts/capacitor = 2,
		/obj/item/weapon/stock_parts/matter_bin = 2,
		/obj/item/pipe = 2)
	additional_spawn_components = list(
		/obj/item/weapon/stock_parts/console_screen = 1,
		/obj/item/weapon/stock_parts/keyboard = 1,
		/obj/item/weapon/stock_parts/power/apc/buildable = 1,
		/obj/item/weapon/stock_parts/power/battery/buildable/stock = 1,
		/obj/item/weapon/cell = 1
	)

/obj/item/weapon/stock_parts/circuitboard/portable_scrubber/pump
	name = T_BOARD("portable pump")
	board_type = "machine"
	build_path = /obj/machinery/portable_atmospherics/powered/pump

/obj/item/weapon/stock_parts/circuitboard/portable_scrubber/huge
	name = T_BOARD("large portable scrubber")
	board_type = "machine"
	build_path = /obj/machinery/portable_atmospherics/powered/scrubber/huge
	origin_tech = list(TECH_ENGINEERING = 5, TECH_POWER = 5, TECH_MATERIAL = 5)
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 4,
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/pipe = 4)

/obj/item/weapon/stock_parts/circuitboard/portable_scrubber/huge/stationary
	name = T_BOARD("large stationary portable scrubber")
	board_type = "machine"
	build_path = /obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary

/obj/item/weapon/stock_parts/circuitboard/tray
	name = T_BOARD("hydroponics tray")
	board_type = "machine"
	build_path = /obj/machinery/portable_atmospherics/hydroponics
	origin_tech = list(TECH_BIO = 3, TECH_MATERIAL = 2, TECH_DATA = 1)
	req_components = list(
		/obj/item/weapon/stock_parts/matter_bin = 2,
		/obj/item/weapon/reagent_containers/glass/beaker = 1,
		/obj/item/weedkiller = 1,
		/obj/item/pipe = 2)
	additional_spawn_components = list(
		/obj/item/weapon/stock_parts/console_screen = 1,
		/obj/item/weapon/stock_parts/keyboard = 1,
		/obj/item/weapon/stock_parts/power/apc/buildable = 1
	)