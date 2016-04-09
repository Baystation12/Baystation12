#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it! 
#endif

/obj/item/weapon/circuitboard/telecomms
	board_type = "machine"

/obj/item/weapon/circuitboard/telecomms/receiver
	name = T_BOARD("subspace receiver")
	build_path = /obj/machinery/telecomms/receiver
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_BLUESPACE = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/subspace/ansible = 1,
							/obj/item/weapon/stock_parts/subspace/filter = 1,
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/weapon/stock_parts/micro_laser = 1)

/obj/item/weapon/circuitboard/telecomms/hub
	name = T_BOARD("hub mainframe")
	build_path = /obj/machinery/telecomms/hub
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/subspace/filter = 2)

/obj/item/weapon/circuitboard/telecomms/relay
	name = T_BOARD("relay mainframe")
	build_path = /obj/machinery/telecomms/relay
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 4, TECH_BLUESPACE = 3)
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/subspace/filter = 2)

/obj/item/weapon/circuitboard/telecomms/bus
	name = T_BOARD("bus mainframe")
	build_path = /obj/machinery/telecomms/bus
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/stack/cable_coil = 1,
							/obj/item/weapon/stock_parts/subspace/filter = 1)

/obj/item/weapon/circuitboard/telecomms/processor
	name = T_BOARD("processor unit")
	build_path = /obj/machinery/telecomms/processor
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 3,
							/obj/item/weapon/stock_parts/subspace/filter = 1,
							/obj/item/weapon/stock_parts/subspace/treatment = 2,
							/obj/item/weapon/stock_parts/subspace/analyzer = 1,
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/subspace/amplifier = 1)

/obj/item/weapon/circuitboard/telecomms/server
	name = T_BOARD("telecommunication server")
	build_path = /obj/machinery/telecomms/server
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/stack/cable_coil = 1,
							/obj/item/weapon/stock_parts/subspace/filter = 1)

/obj/item/weapon/circuitboard/telecomms/broadcaster
	name = T_BOARD("subspace broadcaster")
	build_path = /obj/machinery/telecomms/broadcaster
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_BLUESPACE = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/stack/cable_coil = 1,
							/obj/item/weapon/stock_parts/subspace/filter = 1,
							/obj/item/weapon/stock_parts/subspace/crystal = 1,
							/obj/item/weapon/stock_parts/micro_laser/high = 2)
