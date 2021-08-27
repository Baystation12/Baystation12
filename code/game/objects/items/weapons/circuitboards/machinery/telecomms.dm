/obj/item/stock_parts/circuitboard/telecomms
	board_type = "machine"
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/telecomms/receiver
	name = T_BOARD("subspace receiver")
	build_path = /obj/machinery/telecomms/receiver
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_BLUESPACE = 2)
	req_components = list(
							/obj/item/stock_parts/subspace/ansible = 1,
							/obj/item/stock_parts/subspace/filter = 1,
							/obj/item/stock_parts/manipulator = 2,
							/obj/item/stock_parts/micro_laser = 1)

/obj/item/stock_parts/circuitboard/telecomms/hub
	name = T_BOARD("hub mainframe")
	build_path = /obj/machinery/telecomms/hub
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	req_components = list(
							/obj/item/stock_parts/manipulator = 2,
							/obj/item/stock_parts/subspace/filter = 2)

/obj/item/stock_parts/circuitboard/telecomms/bus
	name = T_BOARD("bus mainframe")
	build_path = /obj/machinery/telecomms/bus
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	req_components = list(
							/obj/item/stock_parts/manipulator = 2,
							/obj/item/stock_parts/subspace/filter = 1)

/obj/item/stock_parts/circuitboard/telecomms/processor
	name = T_BOARD("processor unit")
	build_path = /obj/machinery/telecomms/processor
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	req_components = list(
							/obj/item/stock_parts/manipulator = 3,
							/obj/item/stock_parts/subspace/filter = 1,
							/obj/item/stock_parts/subspace/treatment = 2,
							/obj/item/stock_parts/subspace/analyzer = 1,
							/obj/item/stock_parts/subspace/amplifier = 1)

/obj/item/stock_parts/circuitboard/telecomms/server
	name = T_BOARD("telecommunication server")
	build_path = /obj/machinery/telecomms/server
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	req_components = list(
							/obj/item/stock_parts/manipulator = 2,
							/obj/item/stock_parts/subspace/filter = 1)

/obj/item/stock_parts/circuitboard/telecomms/broadcaster
	name = T_BOARD("subspace broadcaster")
	build_path = /obj/machinery/telecomms/broadcaster
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_BLUESPACE = 2)
	req_components = list(
							/obj/item/stock_parts/manipulator = 2,
							/obj/item/stock_parts/subspace/filter = 1,
							/obj/item/stock_parts/subspace/crystal = 1,
							/obj/item/stock_parts/micro_laser/high = 2)

/obj/item/stock_parts/circuitboard/telecomms/allinone
	name = T_BOARD("telecommunication mainframe")
	build_path = /obj/machinery/telecomms/allinone
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3);
	req_components = list(
							/obj/item/stock_parts/subspace/ansible = 1,
							/obj/item/stock_parts/subspace/filter = 1,
							/obj/item/stock_parts/subspace/treatment = 2,
							/obj/item/stock_parts/subspace/analyzer = 1,
							/obj/item/stock_parts/subspace/amplifier = 1,
							/obj/item/stock_parts/subspace/crystal = 1)
