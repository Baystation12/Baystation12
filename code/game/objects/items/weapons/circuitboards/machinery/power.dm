#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/stock_parts/circuitboard/smes
	name = T_BOARD("superconductive magnetic energy storage")
	build_path = /obj/machinery/power/smes/buildable
	board_type = "machine"
	origin_tech = list(TECH_POWER = 6, TECH_ENGINEERING = 4)
	req_components = list(/obj/item/weapon/stock_parts/smes_coil = 1, /obj/item/stack/cable_coil = 30)


/obj/item/weapon/stock_parts/circuitboard/batteryrack
	name = T_BOARD("battery rack PSU")
	build_path = /obj/machinery/power/smes/batteryrack
	board_type = "machine"
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 2)
	req_components = list(/obj/item/weapon/stock_parts/capacitor/ = 3, /obj/item/weapon/stock_parts/matter_bin/ = 1)

/obj/item/weapon/stock_parts/circuitboard/emitter
	name = T_BOARD("emitter")
	build_path = /obj/machinery/power/emitter
	board_type = "machine"
	origin_tech = list(TECH_POWER = 4, TECH_ENGINEERING = 2)
	req_components = list(
		/obj/item/weapon/stock_parts/capacitor = 3,
		/obj/item/weapon/stock_parts/micro_laser = 2)

/obj/item/weapon/stock_parts/circuitboard/emitter/gyrotron
	name = T_BOARD("gyrotron")
	build_path = /obj/machinery/power/emitter/gyrotron
	board_type = "machine"
	origin_tech = list(TECH_POWER = 6, TECH_ENGINEERING = 6)

/obj/item/weapon/stock_parts/circuitboard/rad_collector
	name = T_BOARD("radiation collector")
	build_path = /obj/machinery/power/rad_collector
	board_type = "machine"
	origin_tech = list(TECH_POWER = 4, TECH_ENGINEERING = 4, TECH_MAGNET = 2)
	req_components = list(
		/obj/item/weapon/stock_parts/capacitor = 3,
		/obj/item/weapon/stock_parts/micro_laser = 1,
		/obj/item/stack/cable_coil = 20)