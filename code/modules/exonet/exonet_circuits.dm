/obj/item/weapon/stock_parts/circuitboard/exonet/router
	name = T_BOARD("exonet router")
	build_path = /obj/machinery/exonet/broadcaster/router
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	req_components = list(
		/obj/item/weapon/stock_parts/console_screen = 1,
		/obj/item/stack/cable_coil = 5
	)

/obj/item/weapon/stock_parts/circuitboard/exonet/modem
	name = T_BOARD("exonet modem")
	build_path = /obj/machinery/exonet/modem
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	req_components = list(
		/obj/item/weapon/stock_parts/console_screen = 1,
		/obj/item/stack/cable_coil = 5
	)

/obj/item/weapon/stock_parts/circuitboard/exonet/access_directory
	name = T_BOARD("exonet directory controller")
	build_path = /obj/machinery/exonet/access_directory
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	req_components = list(
		/obj/item/weapon/stock_parts/console_screen = 1,
		/obj/item/stack/cable_coil = 5
	)

/obj/item/weapon/stock_parts/circuitboard/exonet/mainframe
	name = T_BOARD("exonet mainframe")
	build_path = /obj/machinery/exonet/mainframe
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	req_components = list(
		/obj/item/weapon/stock_parts/console_screen = 1,
		/obj/item/stack/cable_coil = 5
	)

/obj/item/weapon/stock_parts/circuitboard/exonet/relay
	name = T_BOARD("exonet relay")
	build_path = /obj/machinery/exonet/broadcaster/relay
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	req_components = list(
		/obj/item/weapon/stock_parts/console_screen = 1,
		/obj/item/stack/cable_coil = 5
	)

/datum/design/circuit/exonet/router
	name = "exonet router"
	id = "exonet_router"
	sort_string = "MAAAA"
	build_path = /obj/item/weapon/stock_parts/circuitboard/exonet/router
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 3, TECH_MATERIAL = 3)

/datum/design/circuit/exonet/modem
	name = "exonet modem"
	id = "exonet_modem"
	sort_string = "MAAAB"
	build_path = /obj/item/weapon/stock_parts/circuitboard/exonet/modem
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 3, TECH_MATERIAL = 3)

/datum/design/circuit/exonet/access_directory
	name = "exonet directory controller"
	id = "exonet_directory_controller"
	sort_string = "MAAAC"
	build_path = /obj/item/weapon/stock_parts/circuitboard/exonet/access_directory
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 3, TECH_MATERIAL = 3)

/datum/design/circuit/exonet/mainframe
	name = "exonet mainframe"
	id = "exonet_mainframe"
	sort_string = "MAAAD"
	build_path = /obj/item/weapon/stock_parts/circuitboard/exonet/mainframe
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 3, TECH_MATERIAL = 3)

/datum/design/circuit/exonet/relay
	name = "exonet relay"
	id = "exonet_relay"
	sort_string = "MAAAE"
	build_path = /obj/item/weapon/stock_parts/circuitboard/exonet/relay
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 3, TECH_MATERIAL = 3)