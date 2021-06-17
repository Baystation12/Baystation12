/obj/item/stock_parts/circuitboard/reagent_heater
	name = T_BOARD("chemical heater")
	build_path = /obj/machinery/reagent_temperature
	board_type = "machine"
	origin_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 1)
	req_components = list(
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/capacitor = 1
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/reagent_heater/cooler
	name = T_BOARD("chemical cooler")
	build_path = /obj/machinery/reagent_temperature/cooler

/obj/item/stock_parts/circuitboard/sublimator
	name = T_BOARD("reagent sublimator")
	build_path = /obj/machinery/portable_atmospherics/reagent_sublimator
	board_type = "machine"
	origin_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 1)
	req_components = list(
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/matter_bin = 1
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/sublimator/sauna
	name = T_BOARD("sauna sublimator")
	build_path = /obj/machinery/portable_atmospherics/reagent_sublimator/sauna


/obj/item/stock_parts/circuitboard/reagentgrinder
	name = T_BOARD("reagent grinder")
	build_path = /obj/machinery/reagentgrinder
	board_type = "machine"
	origin_tech = list(TECH_BIO = 1, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/capacitor = 2
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/juicer
	name = T_BOARD("blender")
	build_path = /obj/machinery/reagentgrinder/juicer
	board_type = "machine"
	origin_tech = list(TECH_BIO = 1, TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/capacitor = 1
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)
