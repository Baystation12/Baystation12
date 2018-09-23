#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/reagent_heater
	name = T_BOARD("chemical heater")
	build_path = /obj/machinery/reagent_temperature
	board_type = "machine"
	origin_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 1)
	req_components = list(
		/obj/item/weapon/stock_parts/micro_laser = 1,
		/obj/item/weapon/stock_parts/capacitor = 1
	)

/obj/item/weapon/circuitboard/reagent_heater/cooler
	name = T_BOARD("chemical cooler")
	build_path = /obj/machinery/reagent_temperature/cooler
