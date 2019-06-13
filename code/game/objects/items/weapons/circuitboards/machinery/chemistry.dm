#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/stock_parts/circuitboard/reagent_heater
	name = T_BOARD("chemical heater")
	build_path = /obj/machinery/reagent_temperature
	board_type = "machine"
	origin_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 1)
	req_components = list(
		/obj/item/weapon/stock_parts/micro_laser = 1,
		/obj/item/weapon/stock_parts/capacitor = 1
	)

/obj/item/weapon/stock_parts/circuitboard/reagent_heater/cooler
	name = T_BOARD("chemical cooler")
	build_path = /obj/machinery/reagent_temperature/cooler

/obj/item/weapon/stock_parts/circuitboard/chem_dispenser
	name = T_BOARD("chemical dispenser")
	build_path = /obj/machinery/chemical_dispenser
	origin_tech = list(TECH_ENGINEERING = 3, TECH_BIO = 4)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/weapon/stock_parts/manipulator = 2)

/obj/item/weapon/stock_parts/circuitboard/chem_dispenser/drink
	name = T_BOARD("soft drink dispenser")
	build_path = /obj/machinery/chemical_dispenser/bar_soft
	origin_tech = list(TECH_ENGINEERING = 1, TECH_BIO = 2)

/obj/item/weapon/stock_parts/circuitboard/chem_dispenser/drink/booze
	name = T_BOARD("booze dispenser")
	build_path = /obj/machinery/chemical_dispenser/bar_alc

/obj/item/weapon/stock_parts/circuitboard/chem_dispenser/drink/coffee
	name = T_BOARD("coffee dispenser")
	build_path = /obj/machinery/chemical_dispenser/bar_coffee