#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/cell_charger
	name = T_BOARD("cell charger")
	build_path = /obj/machinery/cell_charger
	board_type = "machine"
	origin_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	req_components = list(/obj/item/weapon/stock_parts/capacitor = 1)

/obj/item/weapon/circuitboard/recharger
	name = T_BOARD("recharger")
	build_path = /obj/machinery/recharger
	board_type = "machine"
	origin_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	req_components = list(/obj/item/weapon/stock_parts/capacitor = 1)

/obj/item/weapon/circuitboard/sleeper
	name = T_BOARD("sleeper")
	desc = "The circuitboard for a sleeper."
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2, TECH_ENGINEERING = 2)
	build_path = /obj/machinery/sleeper
	board_type = "machine"
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 2,
							/obj/item/weapon/stock_parts/scanning_module = 2,
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/reagent_containers/glass/beaker/large = 1)
